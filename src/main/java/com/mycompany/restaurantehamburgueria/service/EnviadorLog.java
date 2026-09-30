package com.mycompany.restaurantehamburgueria.service;

import java.util.logging.Logger;

/**
 * Enviador de desenvolvimento: escreve o email no log do servidor em vez de
 * mandar de verdade.
 *
 * Serve para o fluxo inteiro ficar testável antes de existir provedor: o link
 * de verificação aparece no server.log do GlassFish e dá para colar no
 * navegador. Não use em produção — ele não entrega nada a ninguém.
 */
public class EnviadorLog implements EnviadorDeEmail {

    private static final Logger LOG = Logger.getLogger(EnviadorLog.class.getName());

    @Override
    public void enviar(String para, String assunto, String corpoHtml, String corpoTexto) {
        LOG.info(
            "\n"
          + "============ EMAIL (nao enviado de verdade) ============\n"
          + "Para   : " + para + "\n"
          + "Assunto: " + assunto + "\n"
          + "-------------------------------------------------------\n"
          + corpoTexto + "\n"
          + "=======================================================");
    }

    @Override
    public String getNome() {
        return "log (desenvolvimento)";
    }
}
