package com.mycompany.restaurantehamburgueria.service;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Envio pela API da Mailgun.
 *
 * POST https://api.mailgun.net/v3/&lt;dominio&gt;/messages
 *
 * Ao contrário do Twilio em modo trial, a Mailgun aceita conteúdo próprio já
 * no domínio sandbox — o que é justamente o que a verificação de email exige.
 * A restrição do sandbox é outra: só entrega para destinatários autorizados,
 * cadastrados no painel.
 *
 * Não usa Unirest. O exemplo da Mailgun sugere essa biblioteca, mas ela é de
 * 2017, está sem manutenção e puxa httpclient e jackson junto. O HttpClient do
 * Java 11 faz o mesmo sem dependência nenhuma.
 *
 * O corpo vai em application/x-www-form-urlencoded, não JSON — é o formato que
 * a API da Mailgun espera.
 *
 * CONFIGURAÇÃO (ambiente, -D ou .env — ver Config):
 *   MAILGUN_API_KEY        a chave privada da conta
 *   MAILGUN_DOMINIO        ex.: sandboxXXXX.mailgun.org
 *   MAILGUN_REMETENTE      opcional; padrão postmaster@&lt;dominio&gt;
 *   MAILGUN_REMETENTE_NOME opcional; padrão "Big Tites"
 *   MAILGUN_BASE_URL       opcional; use https://api.eu.mailgun.net/v3 na UE
 */
public class EnviadorMailgun implements EnviadorDeEmail {

    private static final Logger LOG = Logger.getLogger(EnviadorMailgun.class.getName());

    private static final String BASE_PADRAO = "https://api.mailgun.net/v3";
    private static final Duration ESPERA = Duration.ofSeconds(20);

    private final String autorizacao;
    private final String url;
    private final String remetente;

    private final HttpClient http = HttpClient.newBuilder()
            .connectTimeout(ESPERA)
            .build();

    public EnviadorMailgun(String chave, String dominio, String remetente,
                           String remetenteNome, String baseUrl) {

        // A Mailgun usa HTTP Basic com o usuário literal "api".
        String credencial = "api:" + chave;
        this.autorizacao = "Basic " + Base64.getEncoder()
                .encodeToString(credencial.getBytes(StandardCharsets.UTF_8));

        String base = (baseUrl == null || baseUrl.isEmpty()) ? BASE_PADRAO : baseUrl;
        this.url = base + "/" + dominio + "/messages";

        String endereco = (remetente == null || remetente.isEmpty())
                ? "postmaster@" + dominio : remetente;
        String nome = (remetenteNome == null || remetenteNome.isEmpty())
                ? "Big Tites" : remetenteNome;

        this.remetente = nome + " <" + endereco + ">";
    }

    /** Monta a partir da configuração. Devolve null se faltar chave ou domínio. */
    public static EnviadorMailgun daConfig() {
        String chave   = Config.get("MAILGUN_API_KEY");
        String dominio = Config.get("MAILGUN_DOMINIO");

        if (chave == null || dominio == null) {
            return null;
        }
        return new EnviadorMailgun(
                chave,
                dominio,
                Config.get("MAILGUN_REMETENTE"),
                Config.get("MAILGUN_REMETENTE_NOME"),
                Config.get("MAILGUN_BASE_URL"));
    }

    @Override
    public void enviar(String para, String assunto, String corpoHtml, String corpoTexto)
            throws EnvioFalhou {

        String corpo = campo("from", remetente)
                     + "&" + campo("to", para)
                     + "&" + campo("subject", assunto)
                     + "&" + campo("text", corpoTexto)
                     + "&" + campo("html", corpoHtml);

        HttpRequest requisicao = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(ESPERA)
                .header("Authorization", autorizacao)
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(corpo, StandardCharsets.UTF_8))
                .build();

        try {
            HttpResponse<String> resposta =
                    http.send(requisicao, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

            if (resposta.statusCode() == 200) {
                LOG.info("Mailgun aceitou o email para " + para
                       + " (" + identificador(resposta.body()) + ")");
                return;
            }

            String erro = resposta.body();

            // Traduz os dois tropeços que todo mundo comete no começo, senão
            // o erro parece problema do nosso código — e não é.
            if (erro != null && erro.contains("activate your Mailgun account")) {
                throw new EnvioFalhou("A conta Mailgun ainda não foi ativada. "
                        + "Procure o email de ativação da Mailgun e clique no link.");
            }
            if (erro != null && erro.contains("not an authorized recipient")) {
                throw new EnvioFalhou("O domínio sandbox só entrega para destinatários "
                        + "autorizados. Cadastre " + para + " em Sending → Overview → "
                        + "Authorized Recipients, ou use um domínio próprio.");
            }

            LOG.log(Level.SEVERE, "Mailgun recusou (HTTP {0}): {1}",
                    new Object[]{resposta.statusCode(), erro});
            throw new EnvioFalhou("Mailgun respondeu " + resposta.statusCode() + ": " + erro);

        } catch (IOException e) {
            throw new EnvioFalhou("Não consegui falar com a Mailgun. " + explicar(e), e);

        } catch (InterruptedException e) {
            // Restaura o sinal para quem estiver acima na pilha.
            Thread.currentThread().interrupt();
            throw new EnvioFalhou("Envio interrompido", e);
        }
    }

    /** Um par nome=valor já codificado para o corpo do formulário. */
    private static String campo(String nome, String valor) {
        return nome + "=" + URLEncoder.encode(valor == null ? "" : valor, StandardCharsets.UTF_8);
    }

    /** Pesca o id da mensagem na resposta, só para o log. */
    private static String identificador(String corpo) {
        if (corpo == null) {
            return "sem id";
        }
        int i = corpo.indexOf("\"id\"");
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
     * um cacerts.jks próprio que pode vir quase vazio — foi exatamente o que
     * aconteceu aqui. Sem essa dica, o erro parece problema de conectividade.
     */
    private static String explicar(java.io.IOException e) {
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
        return "Mailgun (" + remetente + ")";
    }
}
