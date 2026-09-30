package com.mycompany.restaurantehamburgueria.service;

import java.util.logging.Logger;

/**
 * Fábrica do enviador e textos das mensagens.
 *
 * A escolha é automática, nesta ordem: Mailgun, Twilio, log. Basta configurar
 * as chaves de um deles (ambiente, -D ou .env — ver Config) para o envio
 * passar a sair de verdade, sem tocar em código.
 *
 * Isso evita dois problemas: ninguém precisa mexer no código para ligar o
 * envio, e o projeto continua rodando em qualquer máquina sem a chave — o que
 * importa num trabalho que vai ser aberto por outra pessoa.
 *
 * A credencial NUNCA entra no repositório. Ver EnviadorTwilio e CONFIGURAR-EMAIL.md.
 */
public final class Emails {

    private static final Logger LOG = Logger.getLogger(Emails.class.getName());

    private static final String REMETENTE = "Big Tites";

    private static final EnviadorDeEmail ENVIADOR = escolher();

    private Emails() {
    }

    private static EnviadorDeEmail escolher() {
        // Mailgun primeiro: aceita conteúdo próprio já no sandbox, que é o que
        // o link de verificação exige. O Twilio em trial não aceita.
        EnviadorDeEmail mailgun = EnviadorMailgun.daConfig();
        if (mailgun != null) {
            LOG.info("Envio de email por " + mailgun.getNome());
            return mailgun;
        }

        

        LOG.warning("Nenhum provedor configurado (MAILGUN_API_KEY+MAILGUN_DOMINIO "
                  + "ou TWILIO_ACCOUNT_SID+TWILIO_AUTH_TOKEN): os emails vão para o "
                  + "log, não para a caixa de entrada. Ver CONFIGURAR-EMAIL.md.");
        return new EnviadorLog();
    }

    public static EnviadorDeEmail enviador() {
        return ENVIADOR;
    }

    /** Assunto do email de verificação. */
    public static String assuntoVerificacao() {
        return "Confirme seu email — " + REMETENTE;
    }

    public static String textoVerificacao(String nome, String link) {
        return "Oi, " + nome + "!\n\n"
             + "Confirme seu email para liberar sua conta na Big Tites:\n\n"
             + link + "\n\n"
             + "O link vale por " + Tokens.HORAS_DE_VALIDADE + " horas.\n"
             + "Se não foi você que criou a conta, ignore esta mensagem.\n\n"
             + REMETENTE;
    }

    public static String htmlVerificacao(String nome, String link) {
        return "<div style=\"font-family:system-ui,sans-serif;max-width:480px;color:#17201B\">"
             + "<h2 style=\"color:#123B2E;margin:0 0 16px\">Confirme seu email</h2>"
             + "<p>Oi, " + escapar(nome) + "! Falta um passo para liberar sua conta na Big Tites.</p>"
             + "<p style=\"margin:24px 0\">"
             + "<a href=\"" + escapar(link) + "\" "
             + "style=\"background:#E8A317;color:#0B2219;padding:14px 26px;border-radius:999px;"
             + "text-decoration:none;font-weight:700;display:inline-block\">Confirmar meu email</a>"
             + "</p>"
             + "<p style=\"color:#6B7A70;font-size:14px\">O link vale por "
             + Tokens.HORAS_DE_VALIDADE + " horas. "
             + "Se não foi você que criou a conta, ignore esta mensagem.</p>"
             + "<p style=\"color:#6B7A70;font-size:12px;word-break:break-all\">"
             + "Se o botão não funcionar, cole no navegador:<br>" + escapar(link) + "</p>"
             + "</div>";
    }

    // ---------------------------------------------------------------
    // Recuperação de senha
    // ---------------------------------------------------------------

    public static String assuntoRecuperacao() {
        return "Redefinir sua senha — " + REMETENTE;
    }

    public static String textoRecuperacao(String nome, String link, int minutos) {
        return "Oi, " + nome + "!\n\n"
             + "Alguém pediu para redefinir a senha da sua conta na Big Tites.\n"
             + "Se foi você, use o link abaixo:\n\n"
             + link + "\n\n"
             + "O link vale por " + minutos + " minutos e só funciona uma vez.\n\n"
             + "Se NÃO foi você, ignore esta mensagem: sua senha continua a mesma\n"
             + "e ninguém consegue trocá-la sem abrir este link.\n\n"
             + REMETENTE;
    }

    public static String htmlRecuperacao(String nome, String link, int minutos) {
        return "<div style=\"font-family:system-ui,sans-serif;max-width:480px;color:#17201B\">"
             + "<h2 style=\"color:#123B2E;margin:0 0 16px\">Redefinir sua senha</h2>"
             + "<p>Oi, " + escapar(nome) + "! Alguém pediu para redefinir a senha da sua "
             + "conta na Big Tites.</p>"
             + "<p style=\"margin:24px 0\">"
             + "<a href=\"" + escapar(link) + "\" "
             + "style=\"background:#E8A317;color:#0B2219;padding:14px 26px;border-radius:999px;"
             + "text-decoration:none;font-weight:700;display:inline-block\">Criar uma senha nova</a>"
             + "</p>"
             + "<p style=\"color:#6B7A70;font-size:14px\">O link vale por " + minutos
             + " minutos e só funciona uma vez.</p>"
             + "<p style=\"color:#6B7A70;font-size:14px\"><b>Se não foi você</b>, ignore esta "
             + "mensagem: sua senha continua a mesma e ninguém consegue trocá-la sem abrir "
             + "este link.</p>"
             + "<p style=\"color:#6B7A70;font-size:12px;word-break:break-all\">"
             + "Se o botão não funcionar, cole no navegador:<br>" + escapar(link) + "</p>"
             + "</div>";
    }

    /** Evita que um nome com &lt; ou &amp; quebre o HTML do email. */
    private static String escapar(String texto) {
        if (texto == null) {
            return "";
        }
        return texto.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;");
    }
}
