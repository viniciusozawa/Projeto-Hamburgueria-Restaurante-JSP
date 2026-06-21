package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.ClienteDao;
import com.mycompany.restaurantehamburgueria.model.dao.PagamentoDao;
import com.mycompany.restaurantehamburgueria.model.dao.PedidoDao;
import com.mycompany.restaurantehamburgueria.model.entity.Cliente;
import com.mycompany.restaurantehamburgueria.model.entity.Pagamento;
import com.mycompany.restaurantehamburgueria.model.entity.Pedido;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(WebConstante.BASE_PATH + "/PagamentoController")
public class PagamentoController extends HttpServlet {

    private final PagamentoDao dao      = new PagamentoDao();
    private final PedidoDao pedidoDao   = new PedidoDao();
    private final ClienteDao clienteDao = new ClienteDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao        = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        String codIn        = request.getParameter("codPagamento");
        String formaIn       = request.getParameter("formaPagamento");
        String valorIn       = request.getParameter("valorPago");
        String dataIn        = request.getParameter("dataPagamento");
        String statusIn      = request.getParameter("statusPagamento");
        String codPedidoIn   = request.getParameter("codpedido");
        String codClienteIn  = request.getParameter("codCliente");

        try {
            switch (opcao) {
                case "listar":
                    encaminhar(request, response);
                    break;
                case "cadastrar":
                    cadastrar(request, response, formaIn, valorIn, dataIn, statusIn, codPedidoIn, codClienteIn);
                    break;
                case "enviarAlterar":
                    enviarAlterar(request, response, codIn, formaIn, valorIn, dataIn, statusIn, codPedidoIn, codClienteIn);
                    break;
                case "confirmarAlterar":
                    confirmarAlterar(request, response, codIn, formaIn, valorIn, dataIn, statusIn, codPedidoIn, codClienteIn);
                    break;
                case "enviarExcluir":
                    enviarExcluir(request, response, codIn, formaIn, valorIn, dataIn, statusIn, codPedidoIn, codClienteIn);
                    break;
                case "confirmarExcluir":
                    confirmarExcluir(request, response, codIn);
                    break;
                default:
                    encaminhar(request, response);
            }
        } catch (Exception e) {
            response.getWriter().println("Erro: " + e.getMessage());
        }
    }

    private Pagamento montar(String forma, String valor, String data, String status, String codPedido, String codCliente) {
        Pagamento obj = new Pagamento();
        obj.setFormaPagamento(forma);
        if (valor != null && !valor.isEmpty()) obj.setValorPago(Double.valueOf(valor));
        if (data != null && !data.isEmpty()) obj.setDataPagamento(LocalDate.parse(data));
        obj.setStatusPagamento(status);
        Pedido pedido = new Pedido(); pedido.setCodpedido(Integer.valueOf(codPedido)); obj.setPedidoPagamento(pedido);
        Cliente cliente = new Cliente(); cliente.setCodCliente(Integer.valueOf(codCliente)); obj.setClientePagamento(cliente);
        return obj;
    }

    private void cadastrar(HttpServletRequest req, HttpServletResponse res,
            String forma, String valor, String data, String status, String codPedido, String codCliente) throws IOException {
        dao.salvar(montar(forma, valor, data, status, codPedido, codCliente));
        req.getSession().setAttribute("flash", "Pagamento cadastrado com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/PagamentoController?opcao=listar");
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res,
            String cod, String forma, String valor, String data, String status, String codPedido, String codCliente) throws ServletException, IOException {
        req.setAttribute("codPagamento", cod);
        req.setAttribute("formaPagamento", forma);
        req.setAttribute("valorPago", valor);
        req.setAttribute("dataPagamento", data);
        req.setAttribute("statusPagamento", status);
        req.setAttribute("codPedidoAtual", Integer.valueOf(codPedido));
        req.setAttribute("codClienteAtual", Integer.valueOf(codCliente));
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res,
            String cod, String forma, String valor, String data, String status, String codPedido, String codCliente) throws IOException {
        Pagamento obj = montar(forma, valor, data, status, codPedido, codCliente);
        obj.setCodPagamento(Integer.valueOf(cod));
        dao.alterar(obj);
        req.getSession().setAttribute("flash", "Pagamento alterado com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/PagamentoController?opcao=listar");
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res,
            String cod, String forma, String valor, String data, String status, String codPedido, String codCliente) throws ServletException, IOException {
        req.setAttribute("codPagamento", cod);
        req.setAttribute("formaPagamento", forma);
        req.setAttribute("valorPago", valor);
        req.setAttribute("dataPagamento", data);
        req.setAttribute("statusPagamento", status);
        req.setAttribute("codPedidoAtual", Integer.valueOf(codPedido));
        req.setAttribute("codClienteAtual", Integer.valueOf(codCliente));
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusao clicando em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res, String cod) throws IOException {
        Pagamento obj = new Pagamento();
        obj.setCodPagamento(Integer.valueOf(cod));
        dao.excluir(obj);
        req.getSession().setAttribute("flash", "Pagamento excluido com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/PagamentoController?opcao=listar");
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String flash = (String) request.getSession().getAttribute("flash");
        if (flash != null) {
            if (request.getAttribute("mensagem") == null) request.setAttribute("mensagem", flash);
            request.getSession().removeAttribute("flash");
        }
        List<Pagamento> lista = dao.buscarTodos();
        request.setAttribute("pagamentos", lista);
        request.setAttribute("pedidos", pedidoDao.buscarTodos());
        request.setAttribute("clientes", clienteDao.buscarTodos());
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroPagamento.jsp");
        rd.forward(request, response);
    }
}
