package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.CardapioDao;
import com.mycompany.restaurantehamburgueria.model.dao.CategoriaDao;
import com.mycompany.restaurantehamburgueria.model.entity.Cardapio;
import com.mycompany.restaurantehamburgueria.model.entity.Categoria;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(WebConstante.BASE_PATH + "/CardapioController")
public class CardapioController extends HttpServlet {

    private final CardapioDao dao = new CardapioDao();
    private final CategoriaDao categoriaDao = new CategoriaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        String codIn        = request.getParameter("codCardapio");
        String nomeIn       = request.getParameter("nomeComida");
        String valorIn      = request.getParameter("valorComida");
        String descricaoIn  = request.getParameter("descricaoComida");
        String codCatIn     = request.getParameter("codCategoria");

        try {
            switch (opcao) {
                case "listar":
                    encaminhar(request, response);
                    break;
                case "cadastrar":
                    cadastrar(request, response, nomeIn, valorIn, descricaoIn, codCatIn);
                    break;
                case "enviarAlterar":
                    enviarAlterar(request, response, codIn, nomeIn, valorIn, descricaoIn, codCatIn);
                    break;
                case "confirmarAlterar":
                    confirmarAlterar(request, response, codIn, nomeIn, valorIn, descricaoIn, codCatIn);
                    break;
                case "enviarExcluir":
                    enviarExcluir(request, response, codIn, nomeIn, valorIn, descricaoIn, codCatIn);
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

    private Cardapio montar(String nome, String valor, String descricao, String codCategoria) {
        Cardapio obj = new Cardapio();
        obj.setNomeComida(nome);
        if (valor != null && !valor.isEmpty()) obj.setValorComida(Double.valueOf(valor));
        obj.setDescricaoComida(descricao);

        Categoria cat = new Categoria();
        cat.setCodCategoria(Integer.valueOf(codCategoria));
        obj.setCategoriaCardapio(cat);

        return obj;
    }

    private void cadastrar(HttpServletRequest req, HttpServletResponse res,
            String nome, String valor, String descricao, String codCat) throws ServletException, IOException {
        dao.salvar(montar(nome, valor, descricao, codCat));
        req.setAttribute("mensagem", "Cardapio cadastrado com sucesso!");
        encaminhar(req, res);
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res,
            String cod, String nome, String valor, String descricao, String codCat) throws ServletException, IOException {
        req.setAttribute("codCardapio", cod);
        req.setAttribute("nomeComida", nome);
        req.setAttribute("valorComida", valor);
        req.setAttribute("descricaoComida", descricao);
        req.setAttribute("codCategoriaAtual", Integer.valueOf(codCat));
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res,
            String cod, String nome, String valor, String descricao, String codCat) throws ServletException, IOException {
        Cardapio obj = montar(nome, valor, descricao, codCat);
        obj.setCodCardapio(Integer.valueOf(cod));
        dao.alterar(obj);
        req.setAttribute("mensagem", "Cardapio alterado com sucesso!");
        encaminhar(req, res);
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res,
            String cod, String nome, String valor, String descricao, String codCat) throws ServletException, IOException {
        req.setAttribute("codCardapio", cod);
        req.setAttribute("nomeComida", nome);
        req.setAttribute("valorComida", valor);
        req.setAttribute("descricaoComida", descricao);
        req.setAttribute("codCategoriaAtual", Integer.valueOf(codCat));
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusao clicando em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res, String cod) throws ServletException, IOException {
        Cardapio obj = new Cardapio();
        obj.setCodCardapio(Integer.valueOf(cod));
        dao.excluir(obj);
        req.setAttribute("mensagem", "Cardapio excluido com sucesso!");
        encaminhar(req, res);
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Cardapio> lista = dao.buscarTodos();
        request.setAttribute("cardapios", lista);
        request.setAttribute("categorias", categoriaDao.buscarTodos());
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroCardapio.jsp");
        rd.forward(request, response);
    }
}
