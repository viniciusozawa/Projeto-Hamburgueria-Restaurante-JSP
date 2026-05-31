package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.CardapioDao;
import com.mycompany.restaurantehamburgueria.model.dao.CategoriaDao;
import com.mycompany.restaurantehamburgueria.model.entity.Cardapio;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(WebConstante.BASE_PATH + "/CardapioController")
public class CardapioController extends HttpServlet {

    private final CardapioDao dao = new CardapioDao();
    private final CategoriaDao categoriaDao = new CategoriaDao();

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
        encaminhar(req, res, "Item do cardápio cadastrado com sucesso!");
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        populateFromParams(req);
        encaminhar(req, res, null);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Cardapio obj = fromRequest(req);
        obj.setCodCardapio(Integer.parseInt(req.getParameter("codCardapio")));
        dao.alterar(obj);
        encaminhar(req, res, "Item alterado com sucesso!");
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusão.");
        populateFromParams(req);
        encaminhar(req, res, null);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Cardapio obj = new Cardapio();
        obj.setCodCardapio(Integer.parseInt(req.getParameter("codCardapio")));
        dao.excluir(obj);
        encaminhar(req, res, "Item excluído com sucesso!");
    }

    private Cardapio fromRequest(HttpServletRequest req) {
        Cardapio obj = new Cardapio();
        obj.setNomeComida(req.getParameter("nomeComida"));
        String val = req.getParameter("valorComida");
        if (val != null && !val.isEmpty()) obj.setValorComida(new BigDecimal(val.replace(",", ".")));
        obj.setDescricaoComida(req.getParameter("descricaoComida"));
        String cat = req.getParameter("categoria_codCategoria");
        if (cat != null && !cat.isEmpty()) obj.setCategoria_codCategoria(Integer.parseInt(cat));
        return obj;
    }

    private void populateFromParams(HttpServletRequest req) {
        req.setAttribute("codCardapio", req.getParameter("codCardapio"));
        req.setAttribute("nomeComida", req.getParameter("nomeComida"));
        req.setAttribute("valorComida", req.getParameter("valorComida"));
        req.setAttribute("descricaoComida", req.getParameter("descricaoComida"));
        req.setAttribute("categoria_codCategoria", req.getParameter("categoria_codCategoria"));
    }

    private void encaminhar(HttpServletRequest req, HttpServletResponse res, String msg) throws ServletException, IOException {
        req.setAttribute("cardapios", dao.buscarTodos());
        req.setAttribute("categorias", categoriaDao.buscarTodos());
        if (msg != null) req.setAttribute("mensagem", msg);
        RequestDispatcher rd = req.getRequestDispatcher("/CadastroCardapio.jsp");
        rd.forward(req, res);
    }
}
