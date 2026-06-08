package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.CargoDao;
import com.mycompany.restaurantehamburgueria.model.entity.Cargo;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(WebConstante.BASE_PATH + "/CargoController")
public class CargoController extends HttpServlet {

    private final CargoDao dao = new CargoDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        String codIn  = request.getParameter("codCargo");
        String nomeIn = request.getParameter("nomeCargo");

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
        Cargo obj = new Cargo();
        obj.setNomeCargo(nome);
        dao.salvar(obj);
        req.getSession().setAttribute("flash", "Cargo cadastrado com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/CargoController?opcao=listar");
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res, String cod, String nome) throws ServletException, IOException {
        req.setAttribute("codCargo", cod);
        req.setAttribute("nomeCargo", nome);
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res, String cod, String nome) throws IOException {
        Cargo obj = new Cargo();
        obj.setCodCargo(Integer.valueOf(cod));
        obj.setNomeCargo(nome);
        dao.alterar(obj);
        req.getSession().setAttribute("flash", "Cargo alterado com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/CargoController?opcao=listar");
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res, String cod, String nome) throws ServletException, IOException {
        req.setAttribute("codCargo", cod);
        req.setAttribute("nomeCargo", nome);
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusao clicando em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res, String cod) throws IOException {
        Cargo obj = new Cargo();
        obj.setCodCargo(Integer.valueOf(cod));
        dao.excluir(obj);
        req.getSession().setAttribute("flash", "Cargo excluido com sucesso!");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/CargoController?opcao=listar");
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String flash = (String) request.getSession().getAttribute("flash");
        if (flash != null) {
            if (request.getAttribute("mensagem") == null) request.setAttribute("mensagem", flash);
            request.getSession().removeAttribute("flash");
        }
        List<Cargo> lista = dao.buscarTodos();
        request.setAttribute("cargos", lista);
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroCargo.jsp");
        rd.forward(request, response);
    }
}
