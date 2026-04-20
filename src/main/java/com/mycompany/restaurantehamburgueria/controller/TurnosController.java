package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.TurnosDao;
import com.mycompany.restaurantehamburgueria.model.entity.Turnos;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalTime;
import java.util.List;

@WebServlet(WebConstante.BASE_PATH + "/TurnosController")
public class TurnosController extends HttpServlet {

    private final TurnosDao dao = new TurnosDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao    = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        String codIn    = request.getParameter("codTurnos");
        String inicioIn = request.getParameter("horarioInicio");
        String finalIn  = request.getParameter("horarioFinal");

        try {
            switch (opcao) {
                case "listar"           -> encaminhar(request, response);
                case "cadastrar"        -> cadastrar(request, response, inicioIn, finalIn);
                case "enviarAlterar"    -> enviarAlterar(request, response, codIn, inicioIn, finalIn);
                case "confirmarAlterar" -> confirmarAlterar(request, response, codIn, inicioIn, finalIn);
                case "enviarExcluir"    -> enviarExcluir(request, response, codIn, inicioIn, finalIn);
                case "confirmarExcluir" -> confirmarExcluir(request, response, codIn);
                case "cancelar"         -> encaminhar(request, response);
                default                 -> encaminhar(request, response);
            }
        } catch (Exception e) {
            response.getWriter().println("Erro: " + e.getMessage());
        }
    }

    private Turnos montar(String inicio, String fim) {
        Turnos obj = new Turnos();
        if (inicio != null && !inicio.isEmpty()) obj.setHorarioInicio(LocalTime.parse(inicio));
        if (fim != null && !fim.isEmpty()) obj.setHorarioFinal(LocalTime.parse(fim));
        return obj;
    }

    private void cadastrar(HttpServletRequest req, HttpServletResponse res, String inicio, String fim) throws ServletException, IOException {
        dao.salvar(montar(inicio, fim));
        req.setAttribute("mensagem", "Turno cadastrado com sucesso!");
        encaminhar(req, res);
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res, String cod, String inicio, String fim) throws ServletException, IOException {
        req.setAttribute("codTurnos", cod);
        req.setAttribute("horarioInicio", inicio);
        req.setAttribute("horarioFinal", fim);
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res, String cod, String inicio, String fim) throws ServletException, IOException {
        Turnos obj = montar(inicio, fim);
        obj.setCodTurnos(Integer.valueOf(cod));
        dao.alterar(obj);
        req.setAttribute("mensagem", "Turno alterado com sucesso!");
        encaminhar(req, res);
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res, String cod, String inicio, String fim) throws ServletException, IOException {
        req.setAttribute("codTurnos", cod);
        req.setAttribute("horarioInicio", inicio);
        req.setAttribute("horarioFinal", fim);
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusão clicando em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res, String cod) throws ServletException, IOException {
        Turnos obj = new Turnos();
        obj.setCodTurnos(Integer.valueOf(cod));
        dao.excluir(obj);
        req.setAttribute("mensagem", "Turno excluído com sucesso!");
        encaminhar(req, res);
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Turnos> lista = dao.buscarTodos();
        request.setAttribute("turnos", lista);
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroTurnos.jsp");
        rd.forward(request, response);
    }
}
