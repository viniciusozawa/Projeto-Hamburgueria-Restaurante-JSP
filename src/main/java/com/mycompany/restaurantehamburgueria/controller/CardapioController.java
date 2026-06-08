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

    private final CardapioDao dao         = new CardapioDao();
    private final CategoriaDao categoriaDao = new CategoriaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao     = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        String codIn     = request.getParameter("codCardapio");
        String nomeIn    = request.getParameter("nomeComida");
        String valorIn   = request.getParameter("valorComida");
        String descIn    = request.getParameter("descricaoComida");
        String codCatIn  = request.getParameter("codCategoria");

        try {
            switch (opcao) {
                case "listar":
                    encaminhar(request, response);
                    break;
                case "cadastrar":
                    cadastrar(request, response, nomeIn, valorIn, descIn, codCatIn);
                    break;
                case "enviarAlterar":
                    enviarAlterar(request, response, codIn, nomeIn, valorIn, descIn, codCatIn);
                    break;
                case "confirmarAlterar":
                    confirmarAlterar(request, response, codIn, nomeIn, valorIn, descIn, codCatIn);
                    break;
                case "enviarExcluir":
                    enviarExcluir(request, response, codIn, nomeIn, valorIn, descIn, codCatIn);
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

    private Cardapio montar(String nome, String valor, String descricao, String codCat) {
        Cardapio obj = new Cardapio();
        obj.setNomeComida(nome);
        if (valor != null && !valor.isEmpty()) obj.setValorComida(Double.valueOf(valor));
        obj.setDescricaoComida(descricao);
        Categoria cat = new Categoria();
        cat.setCodCategoria(Integer.valueOf(codCat));
        obj.setCategoriaCardapio(cat);
        return obj;
    }

    private void cadastrar(HttpServletRequest req, HttpServletResponse res,
            String nome, String valor, String desc, String codCat) throws IOException {
        dao.salvar(montar(nome, valor, desc, codCat));
        req.getSession().setAttribute("flash", "Cardapio cadastrado com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/CardapioController?opcao=listar");
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res,
            String cod, String nome, String valor, String desc, String codCat) throws ServletException, IOException {
        req.setAttribute("codCardapio", cod);
        req.setAttribute("nomeComida", nome);
        req.setAttribute("valorComida", valor);
        req.setAttribute("descricaoComida", desc);
        req.setAttribute("codCategoriaAtual", Integer.valueOf(codCat));
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res,
            String cod, String nome, String valor, String desc, String codCat) throws IOException {
        Cardapio obj = montar(nome, valor, desc, codCat);
        obj.setCodCardapio(Integer.valueOf(cod));
        dao.alterar(obj);
        req.getSession().setAttribute("flash", "Cardapio alterado com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/CardapioController?opcao=listar");
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res,
            String cod, String nome, String valor, String desc, String codCat) throws ServletException, IOException {
        req.setAttribute("codCardapio", cod);
        req.setAttribute("nomeComida", nome);
        req.setAttribute("valorComida", valor);
        req.setAttribute("descricaoComida", desc);
        req.setAttribute("codCategoriaAtual", Integer.valueOf(codCat));
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusao clicando em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res, String cod) throws IOException {
        Cardapio obj = new Cardapio();
        obj.setCodCardapio(Integer.valueOf(cod));
        dao.excluir(obj);
        req.getSession().setAttribute("flash", "Cardapio excluido com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/CardapioController?opcao=listar");
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String flash = (String) request.getSession().getAttribute("flash");
        if (flash != null) {
            if (request.getAttribute("mensagem") == null) request.setAttribute("mensagem", flash);
            request.getSession().removeAttribute("flash");
        }
        List<Cardapio> lista = dao.buscarTodos();
        request.setAttribute("cardapios", lista);
        request.setAttribute("categorias", categoriaDao.buscarTodos());
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroCardapio.jsp");
        rd.forward(request, response);
    }
}
