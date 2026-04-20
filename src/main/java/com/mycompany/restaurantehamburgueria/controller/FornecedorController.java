package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.FornecedorDao;
import com.mycompany.restaurantehamburgueria.model.entity.Fornecedor;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(WebConstante.BASE_PATH + "/FornecedorController")
public class FornecedorController extends HttpServlet {

    private final FornecedorDao dao = new FornecedorDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        String codIn    = request.getParameter("codFornecedor");
        String nomeIn   = request.getParameter("nomeFornecedor");
        String cnpjIn   = request.getParameter("cnpj");
        String endIn    = request.getParameter("endereco");
        String bairroIn = request.getParameter("bairro");
        String cidadeIn = request.getParameter("cidade");
        String estadoIn = request.getParameter("estado");

        try {
            switch (opcao) {
                case "listar"           -> encaminhar(request, response);
                case "cadastrar"        -> cadastrar(request, response, nomeIn, cnpjIn, endIn, bairroIn, cidadeIn, estadoIn);
                case "enviarAlterar"    -> enviarAlterar(request, response, codIn, nomeIn, cnpjIn, endIn, bairroIn, cidadeIn, estadoIn);
                case "confirmarAlterar" -> confirmarAlterar(request, response, codIn, nomeIn, cnpjIn, endIn, bairroIn, cidadeIn, estadoIn);
                case "enviarExcluir"    -> enviarExcluir(request, response, codIn, nomeIn, cnpjIn, endIn, bairroIn, cidadeIn, estadoIn);
                case "confirmarExcluir" -> confirmarExcluir(request, response, codIn);
                case "cancelar"         -> encaminhar(request, response);
                default                 -> encaminhar(request, response);
            }
        } catch (Exception e) {
            response.getWriter().println("Erro: " + e.getMessage());
        }
    }

    private Fornecedor montar(String nome, String cnpj, String end, String bairro, String cidade, String estado) {
        Fornecedor obj = new Fornecedor();
        obj.setNomeFornecedor(nome);
        obj.setCnpj(cnpj);
        obj.setEndereco(end);
        obj.setBairro(bairro);
        obj.setCidade(cidade);
        obj.setEstado(estado);
        return obj;
    }

    private void cadastrar(HttpServletRequest req, HttpServletResponse res, String nome, String cnpj, String end, String bairro, String cidade, String estado) throws ServletException, IOException {
        dao.salvar(montar(nome, cnpj, end, bairro, cidade, estado));
        req.setAttribute("mensagem", "Fornecedor cadastrado com sucesso!");
        encaminhar(req, res);
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res, String cod, String nome, String cnpj, String end, String bairro, String cidade, String estado) throws ServletException, IOException {
        req.setAttribute("codFornecedor", cod);
        req.setAttribute("nomeFornecedor", nome);
        req.setAttribute("cnpj", cnpj);
        req.setAttribute("endereco", end);
        req.setAttribute("bairro", bairro);
        req.setAttribute("cidade", cidade);
        req.setAttribute("estado", estado);
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res, String cod, String nome, String cnpj, String end, String bairro, String cidade, String estado) throws ServletException, IOException {
        Fornecedor obj = montar(nome, cnpj, end, bairro, cidade, estado);
        obj.setCodFornecedor(Integer.valueOf(cod));
        dao.alterar(obj);
        req.setAttribute("mensagem", "Fornecedor alterado com sucesso!");
        encaminhar(req, res);
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res, String cod, String nome, String cnpj, String end, String bairro, String cidade, String estado) throws ServletException, IOException {
        req.setAttribute("codFornecedor", cod);
        req.setAttribute("nomeFornecedor", nome);
        req.setAttribute("cnpj", cnpj);
        req.setAttribute("endereco", end);
        req.setAttribute("bairro", bairro);
        req.setAttribute("cidade", cidade);
        req.setAttribute("estado", estado);
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusão clicando em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res, String cod) throws ServletException, IOException {
        Fornecedor obj = new Fornecedor();
        obj.setCodFornecedor(Integer.valueOf(cod));
        dao.excluir(obj);
        req.setAttribute("mensagem", "Fornecedor excluído com sucesso!");
        encaminhar(req, res);
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Fornecedor> lista = dao.buscarTodos();
        request.setAttribute("fornecedores", lista);
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroFornecedor.jsp");
        rd.forward(request, response);
    }
}
