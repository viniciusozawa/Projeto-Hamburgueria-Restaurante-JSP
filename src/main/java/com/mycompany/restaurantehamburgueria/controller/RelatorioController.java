package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.ConnectionFactory;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(WebConstante.BASE_PATH + "/RelatorioController")
public class RelatorioController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tipo = request.getParameter("tipo");
        String opcaoStr = request.getParameter("opcao");

        if (tipo == null) {
            RequestDispatcher rd = request.getRequestDispatcher("/Relatorios.jsp");
            rd.forward(request, response);
            return;
        }

        int opcao = 1;
        if (opcaoStr != null && !opcaoStr.isEmpty()) {
            try { opcao = Integer.parseInt(opcaoStr); } catch (NumberFormatException ignored) {}
        }

        String proc;
        String titulo;
        switch (tipo) {
            case "cardapio"     -> { proc = "{call proc_relatorioCardapio(?)}";    titulo = "Relatório Cardápio"; }
            case "clientes"     -> { proc = "{call proc_relatorioClientes(?)}";    titulo = "Relatório Clientes"; }
            case "funcionario"  -> { proc = "{call proc_relatorioFuncionario(?)}"; titulo = "Relatório Funcionários"; }
            default -> {
                request.setAttribute("erro", "Tipo de relatório inválido.");
                RequestDispatcher rd = request.getRequestDispatcher("/Relatorios.jsp");
                rd.forward(request, response);
                return;
            }
        }

        List<String> colunas = new ArrayList<>();
        List<Map<String, Object>> linhas = new ArrayList<>();

        try (Connection con = ConnectionFactory.getInstance().getConnection();
             CallableStatement cs = con.prepareCall(proc)) {
            cs.setInt(1, opcao);
            boolean temResultado = cs.execute();
            if (temResultado) {
                try (ResultSet rs = cs.getResultSet()) {
                    ResultSetMetaData meta = rs.getMetaData();
                    int cols = meta.getColumnCount();
                    for (int i = 1; i <= cols; i++) colunas.add(meta.getColumnLabel(i));
                    while (rs.next()) {
                        Map<String, Object> linha = new LinkedHashMap<>();
                        for (String col : colunas) linha.put(col, rs.getObject(col));
                        linhas.add(linha);
                    }
                }
            }
        } catch (Exception e) {
            request.setAttribute("erro", "Erro ao executar relatório: " + e.getMessage());
        }

        request.setAttribute("colunas", colunas);
        request.setAttribute("linhas", linhas);
        request.setAttribute("titulo", titulo);
        request.setAttribute("tipoAtivo", tipo);
        request.setAttribute("opcaoAtiva", opcao);
        RequestDispatcher rd = request.getRequestDispatcher("/Relatorios.jsp");
        rd.forward(request, response);
    }
}
