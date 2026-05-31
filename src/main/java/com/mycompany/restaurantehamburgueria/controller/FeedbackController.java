package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.ClienteDao;
import com.mycompany.restaurantehamburgueria.model.dao.FeedbackDao;
import com.mycompany.restaurantehamburgueria.model.entity.Feedback;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(WebConstante.BASE_PATH + "/FeedbackController")
public class FeedbackController extends HttpServlet {

    private final FeedbackDao dao = new FeedbackDao();
    private final ClienteDao clienteDao = new ClienteDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        try {
            switch (opcao) {
                case "listar"           -> encaminhar(request, response, null);
                case "cadastrar"        -> cadastrar(request, response);
                case "enviarAlterar"    -> enviarAlterar(request, response);
                case "confirmarAlterar" -> confirmarAlterar(request, response);
                case "enviarExcluir"    -> enviarExcluir(request, response);
                case "confirmarExcluir" -> confirmarExcluir(request, response);
                case "cancelar"         -> encaminhar(request, response, null);
                default                 -> encaminhar(request, response, null);
            }
        } catch (Exception e) {
            response.getWriter().println("Erro: " + e.getMessage());
        }
    }

    private void cadastrar(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Feedback obj = fromRequest(req);
        dao.salvar(obj);
        encaminhar(req, res, "Feedback cadastrado com sucesso!");
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("codFeedback", req.getParameter("codFeedback"));
        req.setAttribute("nota", req.getParameter("nota"));
        req.setAttribute("descricao", req.getParameter("descricao"));
        req.setAttribute("cliente_codCliente", req.getParameter("cliente_codCliente"));
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res, null);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Feedback obj = fromRequest(req);
        obj.setCodFeedback(Integer.parseInt(req.getParameter("codFeedback")));
        dao.alterar(obj);
        encaminhar(req, res, "Feedback alterado com sucesso!");
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("codFeedback", req.getParameter("codFeedback"));
        req.setAttribute("mensagem", "Confirme a exclusão.");
        encaminhar(req, res, null);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Feedback obj = new Feedback();
        obj.setCodFeedback(Integer.parseInt(req.getParameter("codFeedback")));
        dao.excluir(obj);
        encaminhar(req, res, "Feedback excluído com sucesso!");
    }

    private Feedback fromRequest(HttpServletRequest req) {
        Feedback obj = new Feedback();
        String nota = req.getParameter("nota");
        if (nota != null && !nota.isEmpty()) obj.setNota(Integer.parseInt(nota));
        obj.setDescricao(req.getParameter("descricao"));
        String cli = req.getParameter("cliente_codCliente");
        if (cli != null && !cli.isEmpty()) obj.setCliente_codCliente(Integer.parseInt(cli));
        return obj;
    }

    private void encaminhar(HttpServletRequest req, HttpServletResponse res, String msg) throws ServletException, IOException {
        req.setAttribute("feedbacks", dao.buscarTodos());
        req.setAttribute("clientes", clienteDao.buscarTodos());
        if (msg != null) req.setAttribute("mensagem", msg);
        RequestDispatcher rd = req.getRequestDispatcher("/CadastroFeedback.jsp");
        rd.forward(req, res);
    }
}
