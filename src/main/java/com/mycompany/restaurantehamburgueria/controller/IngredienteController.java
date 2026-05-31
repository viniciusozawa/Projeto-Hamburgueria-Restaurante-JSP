package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.FornecedorDao;
import com.mycompany.restaurantehamburgueria.model.dao.IngredienteDao;
import com.mycompany.restaurantehamburgueria.model.entity.Ingrediente;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

@WebServlet(WebConstante.BASE_PATH + "/IngredienteController")
public class IngredienteController extends HttpServlet {

    private final IngredienteDao dao = new IngredienteDao();
    private final FornecedorDao fornecedorDao = new FornecedorDao();

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
        dao.salvar(fromRequest(req));
        encaminhar(req, res, "Ingrediente cadastrado com sucesso!");
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        populateFromParams(req);
        encaminhar(req, res, null);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Ingrediente obj = fromRequest(req);
        obj.setCodIngrediente(Integer.parseInt(req.getParameter("codIngrediente")));
        dao.alterar(obj);
        encaminhar(req, res, "Ingrediente alterado com sucesso!");
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusão.");
        populateFromParams(req);
        encaminhar(req, res, null);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Ingrediente obj = new Ingrediente();
        obj.setCodIngrediente(Integer.parseInt(req.getParameter("codIngrediente")));
        dao.excluir(obj);
        encaminhar(req, res, "Ingrediente excluído com sucesso!");
    }

    private Ingrediente fromRequest(HttpServletRequest req) {
        Ingrediente obj = new Ingrediente();
        obj.setNomeIngredientes(req.getParameter("nomeIngredientes"));
        String quant = req.getParameter("quantiIngredientes");
        if (quant != null && !quant.isEmpty()) obj.setQuantiIngredientes(new BigDecimal(quant.replace(",", ".")));
        String dp = req.getParameter("dataProducao");
        if (dp != null && !dp.isEmpty()) obj.setDataProducao(LocalDate.parse(dp));
        String dv = req.getParameter("dataVencimento");
        if (dv != null && !dv.isEmpty()) obj.setDataVencimento(LocalDate.parse(dv));
        String val = req.getParameter("valorIngrediente");
        if (val != null && !val.isEmpty()) obj.setValorIngrediente(new BigDecimal(val.replace(",", ".")));
        obj.setDescricaoIngrediente(req.getParameter("descricaoIngrediente"));
        String forn = req.getParameter("fornecedores_codFornecedor");
        if (forn != null && !forn.isEmpty()) obj.setFornecedores_codFornecedor(Integer.parseInt(forn));
        return obj;
    }

    private void populateFromParams(HttpServletRequest req) {
        req.setAttribute("codIngrediente", req.getParameter("codIngrediente"));
        req.setAttribute("nomeIngredientes", req.getParameter("nomeIngredientes"));
        req.setAttribute("quantiIngredientes", req.getParameter("quantiIngredientes"));
        req.setAttribute("dataProducao", req.getParameter("dataProducao"));
        req.setAttribute("dataVencimento", req.getParameter("dataVencimento"));
        req.setAttribute("valorIngrediente", req.getParameter("valorIngrediente"));
        req.setAttribute("descricaoIngrediente", req.getParameter("descricaoIngrediente"));
        req.setAttribute("fornecedores_codFornecedor", req.getParameter("fornecedores_codFornecedor"));
    }

    private void encaminhar(HttpServletRequest req, HttpServletResponse res, String msg) throws ServletException, IOException {
        req.setAttribute("ingredientes", dao.buscarTodos());
        req.setAttribute("fornecedores", fornecedorDao.buscarTodos());
        if (msg != null) req.setAttribute("mensagem", msg);
        RequestDispatcher rd = req.getRequestDispatcher("/CadastroIngrediente.jsp");
        rd.forward(req, res);
    }
}
