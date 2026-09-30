package com.mycompany.restaurantehamburgueria.service;

import jakarta.servlet.http.HttpServletRequest;
import java.util.logging.Logger;

/**
 * Monta os endereços que vão dentro de emails.
 *
 * O PROBLEMA QUE ISTO RESOLVE: um link montado a partir da requisição herda o
 * host que o navegador usou. Quem desenvolve acessa por "localhost", então o
 * email sai com http://localhost:8080/... — e no celular "localhost" é o
 * próprio celular. O botão do email simplesmente não vai a lugar nenhum.
 *
 * Com APP_BASE_URL definido, o link passa a apontar para um endereço que
 * existe fora desta máquina:
 *
 *   APP_BASE_URL=http://localhost:8080/restauranteHamburgueria
 *
 * Sem ele, cai no comportamento antigo (monta pela requisição) e registra um
 * aviso quando o host for localhost, que é justamente o caso que quebra.
 */
public final class Links {

    private static final Logger LOG = Logger.getLogger(Links.class.getName());

    /** Para não repetir o aviso a cada email enviado. */
    private static boolean jaAvisou = false;

    private Links() {
    }

    /**
     * Endereço absoluto de um caminho dentro da aplicação.
     *
     * @param caminho começando com barra, ex.: "/com/.../VerificacaoControlador?t=abc"
     */
    public static String absoluto(HttpServletRequest req, String caminho) {
        String base = Config.get("APP_BASE_URL");

        if (base != null) {
            return semBarraFinal(base) + caminho;
        }

        String host = req.getServerName();
        if (ehLocal(host)) {
            avisarUmaVez(host);
        }
        return daRequisicao(req) + caminho;
    }

    private static boolean ehLocal(String host) {
        return "localhost".equalsIgnoreCase(host)
            || "127.0.0.1".equals(host)
            || "[::1]".equals(host)
            || "0:0:0:0:0:0:0:1".equals(host);
    }

    private static synchronized void avisarUmaVez(String host) {
        if (jaAvisou) {
            return;
        }
        jaAvisou = true;
        LOG.warning(
            "Os links dos emails estão apontando para \"" + host + "\", que só existe "
          + "nesta máquina — o botão do email não vai funcionar no celular nem em outro "
          + "computador. Defina APP_BASE_URL no .env com um endereço alcançável, "
          + "ex.: http://192.168.0.103:8080/restauranteHamburgueria");
    }

    /** Esquema, host e porta como o navegador os viu, mais o contexto da app. */
    private static String daRequisicao(HttpServletRequest req) {
        StringBuilder base = new StringBuilder()
                .append(req.getScheme()).append("://").append(req.getServerName());

        int porta = req.getServerPort();
        boolean portaPadrao = ("http".equals(req.getScheme()) && porta == 80)
                           || ("https".equals(req.getScheme()) && porta == 443);
        if (!portaPadrao) {
            base.append(':').append(porta);
        }

        return base.append(req.getContextPath()).toString();
    }

    private static String semBarraFinal(String url) {
        String limpo = url.trim();
        return limpo.endsWith("/") ? limpo.substring(0, limpo.length() - 1) : limpo;
    }
}
