package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.FornecedorDao;
import com.mycompany.restaurantehamburgueria.model.dao.IngredienteDao;
import com.mycompany.restaurantehamburgueria.model.entity.Fornecedor;
import com.mycompany.restaurantehamburgueria.model.entity.Ingrediente;
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

@WebServlet(WebConstante.BASE_PATH + "/IngredienteController")
public class IngredienteController extends HttpServlet {

    private final IngredienteDao dao = new IngredienteDao();
    private final FornecedorDao fornecedorDao = new FornecedorDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        String codIn        = request.getParameter("codIngrediente");
        String nomeIn       = request.getParameter("nomeIngredientes");
        String quantiIn     = request.getParameter("quantiIngredientes");
        String producaoIn   = request.getParameter("dataProducao");
        String vencimentoIn = request.getParameter("dataVencimento");
        String valorIn      = request.getParameter("valorIngrediente");
        String descricaoIn  = request.getParameter("descricaoIngrediente");
        String codFornIn    = request.getParameter("codFornecedor");

        try {
            switch (opcao) {
                case "listar":
                    encaminhar(request, response);
                    break;
                case "cadastrar":
                    cadastrar(request, response, nomeIn, quantiIn, producaoIn, vencimentoIn, valorIn, descricaoIn, codFornIn);
                    break;
                case "enviarAlterar":
                    enviarAlterar(request, response, codIn, nomeIn, quantiIn, producaoIn, vencimentoIn, valorIn, descricaoIn, codFornIn);
                    break;
                case "confirmarAlterar":
                    confirmarAlterar(request, response, codIn, nomeIn, quantiIn, producaoIn, vencimentoIn, valorIn, descricaoIn, codFornIn);
                    break;
                case "enviarExcluir":
                    enviarExcluir(request, response, codIn, nomeIn, quantiIn, producaoIn, vencimentoIn, valorIn, descricaoIn, codFornIn);
                    break;
                case "confirmarExcluir":
                    confirmarExcluir(request, response, codIn);
                    break;
                case "cancelar":
                    encaminhar(request, response);
                    break;
                default:
                    encaminhar(request, response);
            }
        } catch (Exception e) {
            response.getWriter().println("Erro: " + e.getMessage());
        }
    }

    private Ingrediente montar(String nome, String quanti, String producao, String vencimento, String valor, String descricao, String codForn) {
        Ingrediente obj = new Ingrediente();
        obj.setNomeIngredientes(nome);
        if (quanti != null && !quanti.isEmpty()) obj.setQuantiIngredientes(Double.valueOf(quanti));
        if (producao != null && !producao.isEmpty()) obj.setDataProducao(LocalDate.parse(producao));
        if (vencimento != null && !vencimento.isEmpty()) obj.setDataVencimento(LocalDate.parse(vencimento));
        if (valor != null && !valor.isEmpty()) obj.setValorIngrediente(Double.valueOf(valor));
        obj.setDescricaoIngrediente(descricao);

        Fornecedor forn = new Fornecedor();
        forn.setCodFornecedor(Integer.valueOf(codForn));
        obj.setFornecedorIngrediente(forn);

        return obj;
    }

    private void cadastrar(HttpServletRequest req, HttpServletResponse res,
            String nome, String quanti, String producao, String vencimento, String valor, String descricao, String codForn)
            throws ServletException, IOException {
        dao.salvar(montar(nome, quanti, producao, vencimento, valor, descricao, codForn));
        req.setAttribute("mensagem", "Ingrediente cadastrado com sucesso!");
        encaminhar(req, res);
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res,
            String cod, String nome, String quanti, String producao, String vencimento, String valor, String descricao, String codForn)
            throws ServletException, IOException {
        req.setAttribute("codIngrediente", cod);
        req.setAttribute("nomeIngredientes", nome);
        req.setAttribute("quantiIngredientes", quanti);
        req.setAttribute("dataProducao", producao);
        req.setAttribute("dataVencimento", vencimento);
        req.setAttribute("valorIngrediente", valor);
        req.setAttribute("descricaoIngrediente", descricao);
        req.setAttribute("codFornecedorAtual", Integer.valueOf(codForn));
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res,
            String cod, String nome, String quanti, String producao, String vencimento, String valor, String descricao, String codForn)
            throws ServletException, IOException {
        Ingrediente obj = montar(nome, quanti, producao, vencimento, valor, descricao, codForn);
        obj.setCodIngrediente(Integer.valueOf(cod));
        dao.alterar(obj);
        req.setAttribute("mensagem", "Ingrediente alterado com sucesso!");
        encaminhar(req, res);
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res,
            String cod, String nome, String quanti, String producao, String vencimento, String valor, String descricao, String codForn)
            throws ServletException, IOException {
        req.setAttribute("codIngrediente", cod);
        req.setAttribute("nomeIngredientes", nome);
        req.setAttribute("quantiIngredientes", quanti);
        req.setAttribute("dataProducao", producao);
        req.setAttribute("dataVencimento", vencimento);
        req.setAttribute("valorIngrediente", valor);
        req.setAttribute("descricaoIngrediente", descricao);
        req.setAttribute("codFornecedorAtual", Integer.valueOf(codForn));
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusao clicando em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res, String cod) throws ServletException, IOException {
        Ingrediente obj = new Ingrediente();
        obj.setCodIngrediente(Integer.valueOf(cod));
        dao.excluir(obj);
        req.setAttribute("mensagem", "Ingrediente excluido com sucesso!");
        encaminhar(req, res);
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Ingrediente> lista = dao.buscarTodos();
        request.setAttribute("ingredientes", lista);
        request.setAttribute("fornecedores", fornecedorDao.buscarTodos());
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroIngrediente.jsp");
        rd.forward(request, response);
    }
}
