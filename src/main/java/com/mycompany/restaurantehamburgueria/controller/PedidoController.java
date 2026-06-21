package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.ClienteDao;
import com.mycompany.restaurantehamburgueria.model.dao.FuncionarioDao;
import com.mycompany.restaurantehamburgueria.model.dao.MesaDao;
import com.mycompany.restaurantehamburgueria.model.dao.PedidoDao;
import com.mycompany.restaurantehamburgueria.model.entity.Cliente;
import com.mycompany.restaurantehamburgueria.model.entity.Funcionario;
import com.mycompany.restaurantehamburgueria.model.entity.Mesa;
import com.mycompany.restaurantehamburgueria.model.entity.Pedido;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(WebConstante.BASE_PATH + "/PedidoController")
public class PedidoController extends HttpServlet {

    private final PedidoDao dao             = new PedidoDao();
    private final ClienteDao clienteDao     = new ClienteDao();
    private final MesaDao mesaDao           = new MesaDao();
    private final FuncionarioDao funcionarioDao = new FuncionarioDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao        = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        String codIn        = request.getParameter("codpedido");
        String codClienteIn = request.getParameter("codCliente");
        String codMesaIn    = request.getParameter("codMesa");
        String codFuncIn    = request.getParameter("codFuncionario");

        try {
            switch (opcao) {
                case "listar":
                    encaminhar(request, response);
                    break;
                case "cadastrar":
                    cadastrar(request, response, codClienteIn, codMesaIn, codFuncIn);
                    break;
                case "enviarAlterar":
                    enviarAlterar(request, response, codIn, codClienteIn, codMesaIn, codFuncIn);
                    break;
                case "confirmarAlterar":
                    confirmarAlterar(request, response, codIn, codClienteIn, codMesaIn, codFuncIn);
                    break;
                case "enviarExcluir":
                    enviarExcluir(request, response, codIn, codClienteIn, codMesaIn, codFuncIn);
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

    private Pedido montar(String codCliente, String codMesa, String codFuncionario) {
        Pedido obj = new Pedido();
        Cliente cli = new Cliente(); cli.setCodCliente(Integer.valueOf(codCliente)); obj.setClientePedido(cli);
        Mesa mesa = new Mesa(); mesa.setCodMesa(Integer.valueOf(codMesa)); obj.setMesaPedido(mesa);
        Funcionario func = new Funcionario(); func.setCodFuncionario(Integer.valueOf(codFuncionario)); obj.setFuncionarioPedido(func);
        return obj;
    }

    private void cadastrar(HttpServletRequest req, HttpServletResponse res,
            String codCliente, String codMesa, String codFuncionario) throws IOException {
        dao.salvar(montar(codCliente, codMesa, codFuncionario));
        req.getSession().setAttribute("flash", "Pedido cadastrado com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/PedidoController?opcao=listar");
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res,
            String cod, String codCliente, String codMesa, String codFuncionario) throws ServletException, IOException {
        req.setAttribute("codpedido", cod);
        req.setAttribute("codClienteAtual", Integer.valueOf(codCliente));
        req.setAttribute("codMesaAtual", Integer.valueOf(codMesa));
        req.setAttribute("codFuncionarioAtual", Integer.valueOf(codFuncionario));
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res,
            String cod, String codCliente, String codMesa, String codFuncionario) throws IOException {
        Pedido obj = montar(codCliente, codMesa, codFuncionario);
        obj.setCodpedido(Integer.valueOf(cod));
        dao.alterar(obj);
        req.getSession().setAttribute("flash", "Pedido alterado com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/PedidoController?opcao=listar");
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res,
            String cod, String codCliente, String codMesa, String codFuncionario) throws ServletException, IOException {
        req.setAttribute("codpedido", cod);
        req.setAttribute("codClienteAtual", Integer.valueOf(codCliente));
        req.setAttribute("codMesaAtual", Integer.valueOf(codMesa));
        req.setAttribute("codFuncionarioAtual", Integer.valueOf(codFuncionario));
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusao clicando em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res, String cod) throws IOException {
        Pedido obj = new Pedido();
        obj.setCodpedido(Integer.valueOf(cod));
        dao.excluir(obj);
        req.getSession().setAttribute("flash", "Pedido excluido com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/PedidoController?opcao=listar");
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String flash = (String) request.getSession().getAttribute("flash");
        if (flash != null) {
            if (request.getAttribute("mensagem") == null) request.setAttribute("mensagem", flash);
            request.getSession().removeAttribute("flash");
        }
        List<Pedido> lista = dao.buscarTodos();
        request.setAttribute("pedidos", lista);
        request.setAttribute("clientes", clienteDao.buscarTodos());
        request.setAttribute("mesas", mesaDao.buscarTodos());
        request.setAttribute("funcionarios", funcionarioDao.buscarTodos());
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroPedido.jsp");
        rd.forward(request, response);
    }
}
