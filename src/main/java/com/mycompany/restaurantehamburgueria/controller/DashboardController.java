package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.DashboardDao;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet(WebConstante.BASE_PATH + "/DashboardController")
public class DashboardController extends HttpServlet {

    private final DashboardDao dao = new DashboardDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("gerente") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        Map<String, Integer> stats = dao.getContagens();
        request.setAttribute("stats", stats);
        RequestDispatcher rd = request.getRequestDispatcher("/gerente/dashboard.jsp");
        rd.forward(request, response);
    }
}
