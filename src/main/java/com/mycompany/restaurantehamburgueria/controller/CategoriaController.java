package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.CategoriaDao;
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

@WebServlet(WebConstante.BASE_PATH + "/CategoriaController")
public class CategoriaController extends HttpServlet {

    private final CategoriaDao dao = new CategoriaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao  = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        String codIn  = request.getParameter("codCategoria");
        String nomeIn = request.getParameter("nomeCategoria");

        try {
            switch (opcao) {
                case "listar":
                    encaminhar(request, response);
                    break;
                case "cadastrar":
                    cadastrar(request, response, nomeIn);
                    break;
                case "enviarAlterar":
                    enviarAlterar(request, response, codIn, nomeIn);
                    break;
                case "confirmarAlterar":
                    confirmarAlterar(request, response, codIn, nomeIn);
                    break;
                case "enviarExcluir":
                    enviarExcluir(request, response, codIn, nomeIn);
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

    private void cadastrar(HttpServletRequest req, HttpServletResponse res, String nome) throws IOException {
        Categoria obj = new Categoria();
        obj.setNomeCategoria(nome);
        dao.salvar(obj);
        req.getSession().setAttribute("flash", "Categoria cadastrada com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/CategoriaController?opcao=listar");
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res, String cod, String nome) throws ServletException, IOException {
        req.setAttribute("codCategoria", cod);
        req.setAttribute("nomeCategoria", nome);
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res, String cod, String nome) throws IOException {
        Categoria obj = new Categoria();
        obj.setCodCategoria(Integer.valueOf(cod));
        obj.setNomeCategoria(nome);
        dao.alterar(obj);
        req.getSession().setAttribute("flash", "Categoria alterada com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/CategoriaController?opcao=listar");
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res, String cod, String nome) throws ServletException, IOException {
        req.setAttribute("codCategoria", cod);
        req.setAttribute("nomeCategoria", nome);
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusao clicando em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res, String cod) throws IOException {
        Categoria obj = new Categoria();
        obj.setCodCategoria(Integer.valueOf(cod));
        dao.excluir(obj);
        req.getSession().setAttribute("flash", "Categoria excluida com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/CategoriaController?opcao=listar");
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String flash = (String) request.getSession().getAttribute("flash");
        if (flash != null) {
            if (request.getAttribute("mensagem") == null) request.setAttribute("mensagem", flash);
            request.getSession().removeAttribute("flash");
        }
        List<Categoria> lista = dao.buscarTodos();
        request.setAttribute("categorias", lista);
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroCategoria.jsp");
        rd.forward(request, response);
    }
}
