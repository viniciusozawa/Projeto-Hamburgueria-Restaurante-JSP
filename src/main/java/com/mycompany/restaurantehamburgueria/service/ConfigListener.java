package com.mycompany.restaurantehamburgueria.service;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class ConfigListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        sce.getServletContext().setAttribute("URL_BASE", WebConstante.BASE_PATH);
        // Vai no fim dos links de CSS e JS (estilo.css?v=...). Muda a cada
        // deploy, então o navegador baixa a versão nova em vez de usar a que
        // guardou — sem isso a tela nova aparecia com o estilo antigo.
        sce.getServletContext().setAttribute("VERSAO", Long.toString(System.currentTimeMillis(), 36));
        // <fmt:formatNumber> usa o idioma do servidor, que aqui é inglês:
        // "R$ 897.98" em vez de "R$ 897,98". Este é o nome que o JSTL procura
        // (Config.FMT_LOCALE + ".application") para valer em todas as telas.
        sce.getServletContext().setAttribute("jakarta.servlet.jsp.jstl.fmt.locale.application",
                new java.util.Locale("pt", "BR"));
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
