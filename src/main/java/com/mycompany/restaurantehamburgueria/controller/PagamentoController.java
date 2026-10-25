package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.ExclusaoRecusada;
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
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Locale;

@WebServlet(WebConstante.BASE_PATH + "/PagamentoController")
public class PagamentoController extends HttpServlet {

    private final PagamentoDao dao      = new PagamentoDao();
    private final PedidoDao pedidoDao   = new PedidoDao();

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

        try {
            switch (opcao) {
                case "listar":
                    // veio do botão "Receber" da tela de pedidos: pedido já escolhido
                    if (codPedidoIn != null && !codPedidoIn.isEmpty()) {
                        request.setAttribute("codPedidoAtual", Integer.valueOf(codPedidoIn));
                    }
                    encaminhar(request, response);
                    break;
                case "cadastrar":
                    cadastrar(request, response, formaIn, valorIn, dataIn, statusIn, codPedidoIn);
                    break;
                case "enviarAlterar":
                    enviarAlterar(request, response, codIn, formaIn, valorIn, dataIn, statusIn, codPedidoIn);
                    break;
                case "confirmarAlterar":
                    confirmarAlterar(request, response, codIn, formaIn, valorIn, dataIn, statusIn, codPedidoIn);
                    break;
                case "enviarExcluir":
                    enviarExcluir(request, response, codIn, formaIn, valorIn, dataIn, statusIn, codPedidoIn);
                    break;
                case "confirmarExcluir":
                    confirmarExcluir(request, response, codIn);
                    break;
                default:
                    encaminhar(request, response);
            }
        } catch (Exception e) {
            // sem o tipo, o navegador chuta a codificação e o acento da mensagem quebra
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().println("Erro: " + e.getMessage());
        }
    }

    private Pagamento montar(String forma, String valor, String data, String status, String codPedido) {
        Pagamento obj = new Pagamento();
        obj.setFormaPagamento(forma);
        if (valor != null && !valor.isEmpty()) obj.setValorPago(Double.valueOf(valor));
        if (data != null && !data.isEmpty()) obj.setDataPagamento(LocalDate.parse(data));
        obj.setStatusPagamento(status);
        Pedido pedido = new Pedido(); pedido.setCodpedido(Integer.valueOf(codPedido)); obj.setPedidoPagamento(pedido);
        // O cliente vem sempre do pedido, nunca do formulário: assim não dá
        // para lançar o pagamento da comanda de um no nome de outro.
        Pedido doBanco = pedidoDao.buscarPorId(pedido.getCodpedido());
        if (doBanco == null || doBanco.getClientePedido() == null) {
            throw new IllegalArgumentException("o pedido #" + codPedido + " não existe ou está sem cliente.");
        }
        obj.setClientePagamento(doBanco.getClientePedido());
        return obj;
    }

    private void cadastrar(HttpServletRequest req, HttpServletResponse res,
            String forma, String valor, String data, String status, String codPedido) throws IOException {
        dao.salvar(montar(forma, valor, data, status, codPedido));
        req.getSession().setAttribute("flash", baixa(Integer.valueOf(codPedido)));
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/PagamentoController?opcao=listar");
    }

    /**
     * Diz se o pagamento deu baixa no pedido. A baixa não grava nada a mais:
     * o pedido conta como finalizado quando a soma dos pagamentos cobre o
     * total dele (Pedido.isFinalizado), e sai da lista "Em aberto".
     */
    private String baixa(int codPedido) {
        Pedido pedido = pedidoDao.buscarPorId(codPedido);
        if (pedido == null) {
            return "Pagamento registrado.";
        }
        if (pedido.isFinalizado()) {
            return "Pagamento registrado. Pedido #" + codPedido + " finalizado.";
        }
        return String.format(new Locale("pt", "BR"),
                "Pagamento registrado. Ainda falta R$ %,.2f no pedido #%d.", pedido.getFalta(), codPedido);
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res,
            String cod, String forma, String valor, String data, String status, String codPedido) throws ServletException, IOException {
        req.setAttribute("codPagamento", cod);
        req.setAttribute("formaPagamento", forma);
        req.setAttribute("valorPago", valor);
        req.setAttribute("dataPagamento", data);
        req.setAttribute("statusPagamento", status);
        req.setAttribute("codPedidoAtual", Integer.valueOf(codPedido));
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res,
            String cod, String forma, String valor, String data, String status, String codPedido) throws IOException {
        Pagamento obj = montar(forma, valor, data, status, codPedido);
        obj.setCodPagamento(Integer.valueOf(cod));
        dao.alterar(obj);
        req.getSession().setAttribute("flash", "Pagamento alterado.");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/PagamentoController?opcao=listar");
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res,
            String cod, String forma, String valor, String data, String status, String codPedido) throws ServletException, IOException {
        req.setAttribute("codPagamento", cod);
        req.setAttribute("formaPagamento", forma);
        req.setAttribute("valorPago", valor);
        req.setAttribute("dataPagamento", data);
        req.setAttribute("statusPagamento", status);
        req.setAttribute("codPedidoAtual", Integer.valueOf(codPedido));
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusao clicando em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res, String cod) throws IOException {
        Pagamento obj = new Pagamento();
        obj.setCodPagamento(Integer.valueOf(cod));
        try {
            dao.excluir(obj);
            req.getSession().setAttribute("flash", "Pagamento excluído.");
        } catch (ExclusaoRecusada e) {
            // o banco recusou (registro em uso): diz onde, em vez de fingir sucesso
            req.getSession().setAttribute("flash", e.getMessage());
            req.getSession().setAttribute("flashTipo", "alerta");
        }
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/PagamentoController?opcao=listar");
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String flash = (String) request.getSession().getAttribute("flash");
        if (flash != null) {
            if (request.getAttribute("mensagem") == null) request.setAttribute("mensagem", flash);
            request.getSession().removeAttribute("flash");
        }
        List<Pagamento> lista = dao.buscarTodos();
        double arrecadado = 0;
        for (Pagamento p : lista) {
            if (p.getValorPago() != null) arrecadado += p.getValorPago();
        }
        request.setAttribute("pagamentos", lista);
        request.setAttribute("totalArrecadado", arrecadado);
        // o formulário só oferece os pedidos em aberto (a JSP filtra)
        List<Pedido> pedidos = pedidoDao.buscarRecentesPrimeiro();
        request.setAttribute("pedidos", pedidos);
        // Primeiro passo do formulário: só os clientes com comanda para receber
        // (e, ao alterar, o dono do pedido deste pagamento), em ordem de nome.
        Object atual = request.getAttribute("codPedidoAtual");
        Map<Integer, Cliente> comComanda = new HashMap<>();
        for (Pedido p : pedidos) {
            boolean paraReceber = !p.isFinalizado() && p.getQtdItens() > 0;
            if ((paraReceber || p.getCodpedido().equals(atual)) && p.getClientePedido() != null) {
                comComanda.put(p.getClientePedido().getCodCliente(), p.getClientePedido());
            }
        }
        List<Cliente> clientes = new ArrayList<>(comComanda.values());
        clientes.sort(Comparator.comparing(c -> c.getNomeCliente() == null ? "" : c.getNomeCliente().toLowerCase()));
        request.setAttribute("clientesComComanda", clientes);
        if (request.getAttribute("dataPagamento") == null) {
            request.setAttribute("dataPagamento", LocalDate.now().toString());
        }
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroPagamento.jsp");
        rd.forward(request, response);
    }
}
