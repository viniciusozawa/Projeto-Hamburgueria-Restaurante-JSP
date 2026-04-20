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

        String codIn = request.getParameter("codCargo");
        String nomeIn = request.getParameter("nomeCargo");

        try {
            switch (opcao) {
                case "listar" -> listar(request, response);
                case "cadastrar" -> cadastrar(request, response, nomeIn);
                case "enviarAlterar" -> enviarAlterar(request, response, codIn, nomeIn);
                case "confirmarAlterar" -> confirmarAlterar(request, response, codIn, nomeIn);
                case "enviarExcluir" -> enviarExcluir(request, response, codIn, nomeIn);
                case "confirmarExcluir" -> confirmarExcluir(request, response, codIn);
                case "cancelar" -> cancelar(request, response);
                default -> listar(request, response);
            }
        } catch (Exception e) {
            response.getWriter().println("Erro: " + e.getMessage());
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        encaminhar(request, response, null);
    }

    private void cadastrar(HttpServletRequest request, HttpServletResponse response, String nome) throws ServletException, IOException {
        Cargo obj = new Cargo();
        obj.setNomeCargo(nome);
        dao.salvar(obj);
        request.setAttribute("mensagem", "Cargo cadastrado com sucesso!");
        encaminhar(request, response, null);
    }

    private void enviarAlterar(HttpServletRequest request, HttpServletResponse response, String cod, String nome) throws ServletException, IOException {
        request.setAttribute("codCargo", cod);
        request.setAttribute("nomeCargo", nome);
        request.setAttribute("opcao", "confirmarAlterar");
        request.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(request, response, null);
    }

    private void confirmarAlterar(HttpServletRequest request, HttpServletResponse response, String cod, String nome) throws ServletException, IOException {
        Cargo obj = new Cargo();
        obj.setCodCargo(Integer.valueOf(cod));
        obj.setNomeCargo(nome);
        dao.alterar(obj);
        request.setAttribute("mensagem", "Cargo alterado com sucesso!");
        encaminhar(request, response, null);
    }

    private void enviarExcluir(HttpServletRequest request, HttpServletResponse response, String cod, String nome) throws ServletException, IOException {
        request.setAttribute("codCargo", cod);
        request.setAttribute("nomeCargo", nome);
        request.setAttribute("opcao", "confirmarExcluir");
        request.setAttribute("mensagem", "Confirme a exclusão clicando em Salvar.");
        encaminhar(request, response, null);
    }

    private void confirmarExcluir(HttpServletRequest request, HttpServletResponse response, String cod) throws ServletException, IOException {
        Cargo obj = new Cargo();
        obj.setCodCargo(Integer.valueOf(cod));
        dao.excluir(obj);
        request.setAttribute("mensagem", "Cargo excluído com sucesso!");
        encaminhar(request, response, null);
    }

    private void cancelar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("opcao", "listar");
        encaminhar(request, response, null);
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response, String msg) throws ServletException, IOException {
        List<Cargo> lista = dao.buscarTodos();
        request.setAttribute("cargos", lista);
        if (msg != null) request.setAttribute("mensagem", msg);
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroCargo.jsp");
        rd.forward(request, response);
    }
}
