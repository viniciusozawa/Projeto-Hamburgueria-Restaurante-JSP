package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.CardapioDao;
import com.mycompany.restaurantehamburgueria.model.dao.CardapioIngredienteDao;
import com.mycompany.restaurantehamburgueria.model.dao.ClienteDao;
import com.mycompany.restaurantehamburgueria.model.dao.FuncionarioDao;
import com.mycompany.restaurantehamburgueria.model.dao.MesaDao;
import com.mycompany.restaurantehamburgueria.model.dao.PedidoDao;
import com.mycompany.restaurantehamburgueria.model.dao.PedidoPorCardapioDao;
import com.mycompany.restaurantehamburgueria.model.entity.Cliente;
import com.mycompany.restaurantehamburgueria.model.entity.Funcionario;
import com.mycompany.restaurantehamburgueria.model.entity.Pedido;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;

@WebServlet(WebConstante.BASE_PATH + "/PedidoClienteController")
public class PedidoClienteController extends HttpServlet {

    private final CardapioDao cardapioDao          = new CardapioDao();
    private final CardapioIngredienteDao ingDao    = new CardapioIngredienteDao();
    private final MesaDao mesaDao                  = new MesaDao();
    private final ClienteDao clienteDao            = new ClienteDao();
    private final FuncionarioDao funcionarioDao    = new FuncionarioDao();
    private final PedidoDao pedidoDao              = new PedidoDao();
    private final PedidoPorCardapioDao ppcDao      = new PedidoPorCardapioDao();

    /** GET: exibe o menu de pedidos para o cliente */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        carregarDados(request);
        RequestDispatcher rd = request.getRequestDispatcher("/pedido-cliente.jsp");
        rd.forward(request, response);
    }

    /** POST: processa o pedido */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String nome      = request.getParameter("nomeCliente");
        String telefone  = request.getParameter("telefone");
        String mesaStr   = request.getParameter("codMesa");

        if (nome == null || nome.isBlank() || mesaStr == null || mesaStr.isBlank()) {
            request.setAttribute("erro", "Preencha nome e selecione uma mesa.");
            carregarDados(request);
            request.getRequestDispatcher("/pedido-cliente.jsp").forward(request, response);
            return;
        }

        int codMesa = Integer.parseInt(mesaStr);

        // --- Encontra ou cria o cliente ---
        int codCliente = encontrarOuCriarCliente(nome, telefone);

        // --- Encontra o primeiro funcionário disponível ---
        List<Funcionario> funcionarios = funcionarioDao.buscarTodos();
        if (funcionarios.isEmpty()) {
            request.setAttribute("erro", "Nenhum funcionário cadastrado. Contate o gerente.");
            carregarDados(request);
            request.getRequestDispatcher("/pedido-cliente.jsp").forward(request, response);
            return;
        }
        int codFuncionario = funcionarios.get(0).getCodFuncionario();

        // --- Verifica se algum item foi selecionado ---
        boolean temItem = false;
        Enumeration<String> params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String p = params.nextElement();
            if (p.startsWith("qty_")) {
                String val = request.getParameter(p);
                if (val != null && !val.isBlank() && Integer.parseInt(val) > 0) {
                    temItem = true;
                    break;
                }
            }
        }
        if (!temItem) {
            request.setAttribute("erro", "Selecione pelo menos um item do cardápio.");
            carregarDados(request);
            request.getRequestDispatcher("/pedido-cliente.jsp").forward(request, response);
            return;
        }

        // --- Cria o pedido ---
        Pedido pedido = new Pedido();
        pedido.setCliente_codCliente(codCliente);
        pedido.setMesa_codMesa(codMesa);
        pedido.setFuncionario_codFuncionario(codFuncionario);
        pedidoDao.salvar(pedido);
        int codPedido = pedidoDao.getLastId();

        // --- Insere os itens do pedido (trigger decrementa ingredientes) ---
        params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String p = params.nextElement();
            if (p.startsWith("qty_")) {
                String val = request.getParameter(p);
                if (val != null && !val.isBlank()) {
                    int quantidade = Integer.parseInt(val);
                    if (quantidade > 0) {
                        int codCardapio = Integer.parseInt(p.substring(4));
                        ppcDao.salvar(codPedido, codCardapio, quantidade);
                    }
                }
            }
        }

        // --- Sucesso ---
        request.setAttribute("sucesso", "Pedido #" + codPedido + " realizado com sucesso! Em breve seu atendente chegará.");
        carregarDados(request);
        request.getRequestDispatcher("/pedido-cliente.jsp").forward(request, response);
    }

    private void carregarDados(HttpServletRequest request) {
        request.setAttribute("cardapios", cardapioDao.buscarTodos());
        request.setAttribute("ingredientes", ingDao.buscarIngredientesPorTodosCardapios());
        request.setAttribute("mesas", mesaDao.buscarTodos());
    }

    private int encontrarOuCriarCliente(String nome, String telefone) {
        // Tenta buscar por nome
        List<?> todos = clienteDao.buscarTodos();
        for (Object o : todos) {
            Cliente c = (Cliente) o;
            if (nome.equalsIgnoreCase(c.getNomeCliente())) {
                return c.getCodCliente();
            }
        }
        // Cria novo cliente
        Cliente novo = new Cliente();
        novo.setNomeCliente(nome);
        novo.setCpfCliente("");
        novo.setSenhaCliente("cliente");
        novo.setTelefone(telefone != null ? telefone : "");
        clienteDao.salvar(novo);
        return clienteDao.getLastId();
    }
}
