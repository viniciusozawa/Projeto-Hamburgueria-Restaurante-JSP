package com.mycompany.restaurantehamburgueria.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/com/mycompany/restaurantehamburgueria/controller/LoginController")
public class LoginController extends HttpServlet {

    private static final String USUARIO_ADMIN = "admin";
    private static final String SENHA_ADMIN   = "admin123";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("usuario");
        String senha   = request.getParameter("senha");

        if (USUARIO_ADMIN.equals(usuario) && SENHA_ADMIN.equals(senha)) {
            HttpSession session = request.getSession();
            session.setAttribute("gerente", usuario);
            response.sendRedirect(request.getContextPath() + "/gerente/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.html?erro=1");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.html");
    }
}
