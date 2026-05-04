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
        String opcao = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        String codIn = request.getParameter("codCategoria");
        String nomeIn = request.getParameter("nomeCategoria");

        try {
            switch (opcao) {
                case "listar":
                    encaminhar(request, response, null);
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
                case "cancelar":
                    encaminhar(request, response, null);
                    break;
                default:
                    encaminhar(request, response, null);
            }
        } catch (Exception e) {
            response.getWriter().println("Erro: " + e.getMessage());
        }
    }

    private void cadastrar(HttpServletRequest request, HttpServletResponse response, String nome) throws ServletException, IOException {
        Categoria obj = new Categoria();
        obj.setNomeCategoria(nome);
        dao.salvar(obj);
        request.setAttribute("mensagem", "Categoria cadastrada com sucesso!");
        encaminhar(request, response, null);
    }

    private void enviarAlterar(HttpServletRequest request, HttpServletResponse response, String cod, String nome) throws ServletException, IOException {
        request.setAttribute("codCategoria", cod);
        request.setAttribute("nomeCategoria", nome);
        request.setAttribute("opcao", "confirmarAlterar");
        request.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(request, response, null);
    }

    private void confirmarAlterar(HttpServletRequest request, HttpServletResponse response, String cod, String nome) throws ServletException, IOException {
        Categoria obj = new Categoria();
        obj.setCodCategoria(Integer.valueOf(cod));
        obj.setNomeCategoria(nome);
        dao.alterar(obj);
        request.setAttribute("mensagem", "Categoria alterada com sucesso!");
        encaminhar(request, response, null);
    }

    private void enviarExcluir(HttpServletRequest request, HttpServletResponse response, String cod, String nome) throws ServletException, IOException {
        request.setAttribute("codCategoria", cod);
        request.setAttribute("nomeCategoria", nome);
        request.setAttribute("opcao", "confirmarExcluir");
        request.setAttribute("mensagem", "Confirme a exclusão clicando em Salvar.");
        encaminhar(request, response, null);
    }

    private void confirmarExcluir(HttpServletRequest request, HttpServletResponse response, String cod) throws ServletException, IOException {
        Categoria obj = new Categoria();
        obj.setCodCategoria(Integer.valueOf(cod));
        dao.excluir(obj);
        request.setAttribute("mensagem", "Categoria excluída com sucesso!");
        encaminhar(request, response, null);
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response, String msg) throws ServletException, IOException {
        List<Categoria> lista = dao.buscarTodos();
        request.setAttribute("categorias", lista);
        if (msg != null) request.setAttribute("mensagem", msg);
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroCategoria.jsp");
        rd.forward(request, response);
    }
}
