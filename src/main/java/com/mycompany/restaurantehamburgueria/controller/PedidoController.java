package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.ClienteDao;
import com.mycompany.restaurantehamburgueria.model.dao.FuncionarioDao;
import com.mycompany.restaurantehamburgueria.model.dao.MesaDao;
import com.mycompany.restaurantehamburgueria.model.dao.PedidoDao;
import com.mycompany.restaurantehamburgueria.model.entity.Pedido;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(WebConstante.BASE_PATH + "/PedidoController")
public class PedidoController extends HttpServlet {

    private final PedidoDao dao = new PedidoDao();
    private final ClienteDao clienteDao = new ClienteDao();
    private final MesaDao mesaDao = new MesaDao();
    private final FuncionarioDao funcionarioDao = new FuncionarioDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        try {
            switch (opcao) {
                case "listar"           -> encaminhar(request, response, null);
                case "cadastrar"        -> cadastrar(request, response);
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
        Pedido obj = new Pedido();
        String cli = req.getParameter("cliente_codCliente");
        String mes = req.getParameter("mesa_codMesa");
        String fun = req.getParameter("funcionario_codFuncionario");
        if (cli != null && !cli.isEmpty()) obj.setCliente_codCliente(Integer.parseInt(cli));
        if (mes != null && !mes.isEmpty()) obj.setMesa_codMesa(Integer.parseInt(mes));
        if (fun != null && !fun.isEmpty()) obj.setFuncionario_codFuncionario(Integer.parseInt(fun));
        dao.salvar(obj);
        encaminhar(req, res, "Pedido registrado com sucesso!");
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("codpedido", req.getParameter("codpedido"));
        req.setAttribute("mensagem", "Confirme a exclusão do pedido.");
        encaminhar(req, res, null);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Pedido obj = new Pedido();
        obj.setCodpedido(Integer.parseInt(req.getParameter("codpedido")));
        dao.excluir(obj);
        encaminhar(req, res, "Pedido excluído com sucesso!");
    }

    private void encaminhar(HttpServletRequest req, HttpServletResponse res, String msg) throws ServletException, IOException {
        req.setAttribute("pedidos", dao.buscarTodos());
        req.setAttribute("clientes", clienteDao.buscarTodos());
        req.setAttribute("mesas", mesaDao.buscarTodos());
        req.setAttribute("funcionarios", funcionarioDao.buscarTodos());
        if (msg != null) req.setAttribute("mensagem", msg);
        RequestDispatcher rd = req.getRequestDispatcher("/CadastroPedido.jsp");
        rd.forward(req, res);
    }
}
