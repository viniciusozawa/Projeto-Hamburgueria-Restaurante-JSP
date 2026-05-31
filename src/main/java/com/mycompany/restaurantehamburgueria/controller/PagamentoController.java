package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.PagamentoDao;
import com.mycompany.restaurantehamburgueria.model.dao.PedidoDao;
import com.mycompany.restaurantehamburgueria.model.entity.Pagamento;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(WebConstante.BASE_PATH + "/PagamentoController")
public class PagamentoController extends HttpServlet {

    private final PagamentoDao dao = new PagamentoDao();
    private final PedidoDao pedidoDao = new PedidoDao();

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
        Pagamento obj = new Pagamento();
        obj.setFormaPagamento(req.getParameter("formaPagamento"));
        obj.setStatusPagamento(req.getParameter("statusPagamento"));
        String ped = req.getParameter("pedido_codpedido");
        if (ped != null && !ped.isEmpty()) obj.setPedido_codpedido(Integer.parseInt(ped));
        dao.salvar(obj);
        encaminhar(req, res, "Pagamento registrado com sucesso! Valor calculado automaticamente.");
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("codPagamento", req.getParameter("codPagamento"));
        req.setAttribute("formaPagamento", req.getParameter("formaPagamento"));
        req.setAttribute("statusPagamento", req.getParameter("statusPagamento"));
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res, null);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Pagamento obj = new Pagamento();
        obj.setCodPagamento(Integer.parseInt(req.getParameter("codPagamento")));
        obj.setFormaPagamento(req.getParameter("formaPagamento"));
        obj.setStatusPagamento(req.getParameter("statusPagamento"));
        dao.alterar(obj);
        encaminhar(req, res, "Pagamento alterado com sucesso!");
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("codPagamento", req.getParameter("codPagamento"));
        req.setAttribute("mensagem", "Confirme a exclusão.");
        encaminhar(req, res, null);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Pagamento obj = new Pagamento();
        obj.setCodPagamento(Integer.parseInt(req.getParameter("codPagamento")));
        dao.excluir(obj);
        encaminhar(req, res, "Pagamento excluído com sucesso!");
    }

    private void encaminhar(HttpServletRequest req, HttpServletResponse res, String msg) throws ServletException, IOException {
        req.setAttribute("pagamentos", dao.buscarTodos());
        req.setAttribute("pedidos", pedidoDao.buscarTodos());
        if (msg != null) req.setAttribute("mensagem", msg);
        RequestDispatcher rd = req.getRequestDispatcher("/CadastroPagamento.jsp");
        rd.forward(req, res);
    }
}
