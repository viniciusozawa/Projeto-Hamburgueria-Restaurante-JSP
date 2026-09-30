package com.mycompany.restaurantehamburgueria.service;

/**
 * Quem leva o email até a caixa de entrada.
 *
 * O resto do sistema só conhece esta interface. Trocar o provedor (Brevo,
 * Resend, SendGrid, SMTP) é escrever uma implementação nova e apontar a
 * fábrica em Emails.java — nenhum controlador muda.
 */
public interface EnviadorDeEmail {

    /** Levantada quando o email não saiu. Quem chama decide o que dizer. */
    class EnvioFalhou extends Exception {
        public EnvioFalhou(String mensagem, Throwable causa) {
            super(mensagem, causa);
        }

        public EnvioFalhou(String mensagem) {
            super(mensagem);
        }
    }

    /**
     * @param para       endereço de destino
     * @param assunto    linha de assunto
     * @param corpoHtml  versão com formatação
     * @param corpoTexto versão sem formatação, para quem não exibe HTML
     */
    void enviar(String para, String assunto, String corpoHtml, String corpoTexto) throws EnvioFalhou;

    /** Nome curto para aparecer no log. */
    String getNome();
}
