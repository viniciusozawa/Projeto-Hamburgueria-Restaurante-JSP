package com.mycompany.restaurantehamburgueria.service;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class ConfigListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        sce.getServletContext().setAttribute("URL_BASE", WebConstante.BASE_PATH);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
