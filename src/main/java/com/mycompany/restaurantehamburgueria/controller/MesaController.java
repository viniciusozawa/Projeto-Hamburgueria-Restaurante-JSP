package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.MesaDao;
import com.mycompany.restaurantehamburgueria.model.entity.Mesa;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(WebConstante.BASE_PATH + "/MesaController")
public class MesaController extends HttpServlet {

    private final MesaDao dao = new MesaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao   = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        String codIn    = request.getParameter("codMesa");
        String numIn    = request.getParameter("numeroMesa");
        String localIn  = request.getParameter("localMesa");

        try {
            switch (opcao) {
                case "listar"           -> encaminhar(request, response);
                case "cadastrar"        -> cadastrar(request, response, numIn, localIn);
                case "enviarAlterar"    -> enviarAlterar(request, response, codIn, numIn, localIn);
                case "confirmarAlterar" -> confirmarAlterar(request, response, codIn, numIn, localIn);
                case "enviarExcluir"    -> enviarExcluir(request, response, codIn, numIn, localIn);
                case "confirmarExcluir" -> confirmarExcluir(request, response, codIn);
                case "cancelar"         -> encaminhar(request, response);
                default                 -> encaminhar(request, response);
            }
        } catch (Exception e) {
            response.getWriter().println("Erro: " + e.getMessage());
        }
    }

    private void cadastrar(HttpServletRequest req, HttpServletResponse res, String num, String local) throws ServletException, IOException {
        Mesa obj = new Mesa();
        obj.setNumeroMesa(Integer.valueOf(num));
        obj.setLocalMesa(local);
        dao.salvar(obj);
        req.setAttribute("mensagem", "Mesa cadastrada com sucesso!");
        encaminhar(req, res);
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res, String cod, String num, String local) throws ServletException, IOException {
        req.setAttribute("codMesa", cod);
        req.setAttribute("numeroMesa", num);
        req.setAttribute("localMesa", local);
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res, String cod, String num, String local) throws ServletException, IOException {
        Mesa obj = new Mesa();
        obj.setCodMesa(Integer.valueOf(cod));
        obj.setNumeroMesa(Integer.valueOf(num));
        obj.setLocalMesa(local);
        dao.alterar(obj);
        req.setAttribute("mensagem", "Mesa alterada com sucesso!");
        encaminhar(req, res);
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res, String cod, String num, String local) throws ServletException, IOException {
        req.setAttribute("codMesa", cod);
        req.setAttribute("numeroMesa", num);
        req.setAttribute("localMesa", local);
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusão clicando em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res, String cod) throws ServletException, IOException {
        Mesa obj = new Mesa();
        obj.setCodMesa(Integer.valueOf(cod));
        dao.excluir(obj);
        req.setAttribute("mensagem", "Mesa excluída com sucesso!");
        encaminhar(req, res);
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Mesa> lista = dao.buscarTodos();
        request.setAttribute("mesas", lista);
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroMesa.jsp");
        rd.forward(request, response);
    }
}
