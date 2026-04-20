package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.ClienteDao;
import com.mycompany.restaurantehamburgueria.model.entity.Cliente;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(WebConstante.BASE_PATH + "/ClienteController")
public class ClienteController extends HttpServlet {

    private final ClienteDao dao = new ClienteDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        String codIn    = request.getParameter("codCliente");
        String nomeIn   = request.getParameter("nomeCliente");
        String cpfIn    = request.getParameter("cpfCliente");
        String senhaIn  = request.getParameter("senhaCliente");
        String telIn    = request.getParameter("telefone");
        String dataIn   = request.getParameter("dataCadastro");

        try {
            switch (opcao) {
                case "listar"           -> encaminhar(request, response);
                case "cadastrar"        -> cadastrar(request, response, nomeIn, cpfIn, senhaIn, telIn);
                case "enviarAlterar"    -> enviarAlterar(request, response, codIn, nomeIn, cpfIn, senhaIn, telIn, dataIn);
                case "confirmarAlterar" -> confirmarAlterar(request, response, codIn, nomeIn, cpfIn, senhaIn, telIn);
                case "enviarExcluir"    -> enviarExcluir(request, response, codIn, nomeIn, cpfIn, senhaIn, telIn, dataIn);
                case "confirmarExcluir" -> confirmarExcluir(request, response, codIn);
                case "cancelar"         -> encaminhar(request, response);
                default                 -> encaminhar(request, response);
            }
        } catch (Exception e) {
            response.getWriter().println("Erro: " + e.getMessage());
        }
    }

    private void cadastrar(HttpServletRequest req, HttpServletResponse res, String nome, String cpf, String senha, String tel) throws ServletException, IOException {
        Cliente obj = new Cliente();
        obj.setNomeCliente(nome);
        obj.setCpfCliente(cpf);
        obj.setSenhaCliente(senha);
        obj.setTelefone(tel);
        dao.salvar(obj);
        req.setAttribute("mensagem", "Cliente cadastrado com sucesso!");
        encaminhar(req, res);
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res, String cod, String nome, String cpf, String senha, String tel, String dataIn) throws ServletException, IOException {
        req.setAttribute("codCliente", cod);
        req.setAttribute("nomeCliente", nome);
        req.setAttribute("cpfCliente", cpf);
        req.setAttribute("senhaCliente", senha);
        req.setAttribute("telefone", tel);
        req.setAttribute("dataCadastro", dataIn);
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res, String cod, String nome, String cpf, String senha, String tel) throws ServletException, IOException {
        Cliente obj = new Cliente();
        obj.setCodCliente(Integer.valueOf(cod));
        obj.setNomeCliente(nome);
        obj.setCpfCliente(cpf);
        obj.setSenhaCliente(senha);
        obj.setTelefone(tel);
        dao.alterar(obj);
        req.setAttribute("mensagem", "Cliente alterado com sucesso!");
        encaminhar(req, res);
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res, String cod, String nome, String cpf, String senha, String tel, String dataIn) throws ServletException, IOException {
        req.setAttribute("codCliente", cod);
        req.setAttribute("nomeCliente", nome);
        req.setAttribute("cpfCliente", cpf);
        req.setAttribute("senhaCliente", senha);
        req.setAttribute("telefone", tel);
        req.setAttribute("dataCadastro", dataIn);
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusão clicando em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res, String cod) throws ServletException, IOException {
        Cliente obj = new Cliente();
        obj.setCodCliente(Integer.valueOf(cod));
        dao.excluir(obj);
        req.setAttribute("mensagem", "Cliente excluído com sucesso!");
        encaminhar(req, res);
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Cliente> lista = dao.buscarTodos();
        request.setAttribute("clientes", lista);
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroCliente.jsp");
        rd.forward(request, response);
    }
}
