package com.mycompany.restaurantehamburgueria.service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Envio pela API transacional da Brevo (antiga Sendinblue).
 *
 * POST https://api.brevo.com/v3/smtp/email
 *
 * Escolhida porque o plano gratuito (300 emails/dia) entrega para QUALQUER
 * destinatário sem exigir domínio próprio: basta cadastrar o remetente em
 * Settings → Senders, Domains, IPs → Senders e confirmar o código que chega
 * nele. A Mailgun (sandbox) e a Resend sem domínio só entregam para uma lista
 * fechada, o que impedia o professor de receber o email.
 *
 * Não usa o SDK da Brevo: ele puxa okhttp e gson junto. O HttpClient do Java 11
 * faz o mesmo sem dependência nenhuma.
 *
 * A chave vai no cabeçalho "api-key" e o corpo é JSON.
 *
 * CONFIGURAÇÃO (ambiente, -D ou .env — ver Config):
 *   BREVO_API_KEY        a chave (SMTP &amp; API → API Keys)
 *   BREVO_REMETENTE      o email cadastrado e confirmado como sender na Brevo
 *   BREVO_REMETENTE_NOME opcional; padrão "Big Tites"
 */
public class EnviadorBrevo implements EnviadorDeEmail {

    private static final Logger LOG = Logger.getLogger(EnviadorBrevo.class.getName());

    private static final String URL = "https://api.brevo.com/v3/smtp/email";
    private static final Duration ESPERA = Duration.ofSeconds(20);

    private final String chave;
    private final String remetenteEmail;
    private final String remetenteNome;

    private final HttpClient http = HttpClient.newBuilder()
            .connectTimeout(ESPERA)
            .build();

    public EnviadorBrevo(String chave, String remetente, String remetenteNome) {
        this.chave = chave;
        this.remetenteEmail = remetente;
        this.remetenteNome = (remetenteNome == null || remetenteNome.isEmpty())
                ? "Big Tites" : remetenteNome;
    }

    /** Monta a partir da configuração. Devolve null se faltar chave ou remetente. */
    public static EnviadorBrevo daConfig() {
        String chave     = Config.get("BREVO_API_KEY");
        String remetente = Config.get("BREVO_REMETENTE");

        if (chave == null || remetente == null) {
            return null;
        }
        return new EnviadorBrevo(chave, remetente, Config.get("BREVO_REMETENTE_NOME"));
    }

    @Override
    public void enviar(String para, String assunto, String corpoHtml, String corpoTexto)
            throws EnvioFalhou {

        String corpo = "{"
                + "\"sender\":{\"name\":" + json(remetenteNome)
                +            ",\"email\":" + json(remetenteEmail) + "},"
                + "\"to\":[{\"email\":" + json(para) + "}],"
                + "\"subject\":" + json(assunto) + ","
                + "\"htmlContent\":" + json(corpoHtml) + ","
                + "\"textContent\":" + json(corpoTexto)
                + "}";

        HttpRequest requisicao = HttpRequest.newBuilder()
                .uri(URI.create(URL))
                .timeout(ESPERA)
                .header("api-key", chave)
                .header("Content-Type", "application/json")
                .header("Accept", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(corpo, StandardCharsets.UTF_8))
                .build();

        try {
            HttpResponse<String> resposta =
                    http.send(requisicao, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

            // A Brevo responde 201 Created com {"messageId":"<...>"}.
            if (resposta.statusCode() == 201 || resposta.statusCode() == 200) {
                LOG.info("Brevo aceitou o email para " + para
                       + " (" + identificador(resposta.body()) + ")");
                return;
            }

            String erro = resposta.body();

            // Traduz os tropeços de conta nova, senão o erro parece problema
            // do nosso código — e não é.
            if (erro != null && erro.contains("unrecognised IP")) {
                throw new EnvioFalhou("A Brevo bloqueou o IP deste servidor. Libere-o em "
                        + "Settings → Security → Authorised IPs, ou desative o bloqueio por IP.");
            }
            if (erro != null && erro.toLowerCase().contains("sender")) {
                throw new EnvioFalhou("A Brevo não reconhece o remetente " + remetenteEmail
                        + ". Cadastre-o em Settings → Senders, Domains, IPs → Senders e "
                        + "confirme o código que chega nele.");
            }
            if (resposta.statusCode() == 401) {
                throw new EnvioFalhou("A Brevo recusou a chave (401). Confira BREVO_API_KEY no .env.");
            }

            LOG.log(Level.SEVERE, "Brevo recusou (HTTP {0}): {1}",
                    new Object[]{resposta.statusCode(), erro});
            throw new EnvioFalhou("Brevo respondeu " + resposta.statusCode() + ": " + erro);

        } catch (IOException e) {
            throw new EnvioFalhou("Não consegui falar com a Brevo. " + explicar(e), e);

        } catch (InterruptedException e) {
            // Restaura o sinal para quem estiver acima na pilha.
            Thread.currentThread().interrupt();
            throw new EnvioFalhou("Envio interrompido", e);
        }
    }

    /** Valor como string JSON, com aspas e escapes. Evita puxar uma biblioteca só para isso. */
    private static String json(String valor) {
        if (valor == null) {
            return "\"\"";
        }
        StringBuilder sb = new StringBuilder(valor.length() + 16).append('"');
        for (int i = 0; i < valor.length(); i++) {
            char c = valor.charAt(i);
            switch (c) {
                case '"':  sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\n': sb.append("\\n");  break;
                case '\r': sb.append("\\r");  break;
                case '\t': sb.append("\\t");  break;
                default:
                    if (c < 0x20) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
            }
        }
        return sb.append('"').toString();
    }

    /** Pesca o messageId na resposta, só para o log. */
    private static String identificador(String corpo) {
        if (corpo == null) {
            return "sem id";
        }
        int i = corpo.indexOf("\"messageId\"");
        if (i < 0) {
            return "sem id";
        }
        int abre = corpo.indexOf('"', corpo.indexOf(':', i) + 1);
        int fecha = abre < 0 ? -1 : corpo.indexOf('"', abre + 1);
        return (abre < 0 || fecha < 0) ? "sem id" : corpo.substring(abre + 1, fecha);
    }

    /**
     * Mensagem legível para uma falha de rede ou TLS.
     *
     * O erro de PKIX merece tratamento próprio: ele quer dizer que o
     * truststore do servidor não conhece a CA do provedor, e não que o
     * endereço esteja errado. No GlassFish isso é comum, porque o domínio tem
     * um cacerts.jks próprio que pode vir quase vazio. Sem essa dica, o erro
     * parece problema de conectividade.
     */
    private static String explicar(IOException e) {
        String detalhe = e.getClass().getSimpleName()
                       + (e.getMessage() == null ? "" : ": " + e.getMessage());

        for (Throwable t = e; t != null; t = t.getCause()) {
            String m = t.getMessage();
            if (m != null && (m.contains("PKIX path building failed")
                           || m.contains("unable to find valid certification path"))) {
                return detalhe + " — o truststore do servidor não confia na CA do "
                     + "provedor. No GlassFish, importe as CAs públicas em "
                     + "<dominio>/config/cacerts.jks (ver CONFIGURAR-EMAIL.md).";
            }
        }
        return detalhe;
    }

    @Override
    public String getNome() {
        return "Brevo (" + remetenteNome + " <" + remetenteEmail + ">)";
    }
}
