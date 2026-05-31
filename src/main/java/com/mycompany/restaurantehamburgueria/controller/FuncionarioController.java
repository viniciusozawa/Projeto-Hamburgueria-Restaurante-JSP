package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.CargoDao;
import com.mycompany.restaurantehamburgueria.model.dao.FuncionarioDao;
import com.mycompany.restaurantehamburgueria.model.dao.TurnosDao;
import com.mycompany.restaurantehamburgueria.model.entity.Funcionario;
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
import java.util.List;

@WebServlet(WebConstante.BASE_PATH + "/FuncionarioController")
public class FuncionarioController extends HttpServlet {

    private final FuncionarioDao dao = new FuncionarioDao();
    private final CargoDao cargoDao = new CargoDao();
    private final TurnosDao turnosDao = new TurnosDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        try {
            switch (opcao) {
                case "listar"          -> encaminhar(request, response, null);
                case "cadastrar"       -> cadastrar(request, response);
                case "enviarAlterar"   -> enviarAlterar(request, response);
                case "confirmarAlterar"-> confirmarAlterar(request, response);
                case "enviarExcluir"   -> enviarExcluir(request, response);
                case "confirmarExcluir"-> confirmarExcluir(request, response);
                case "cancelar"        -> encaminhar(request, response, null);
                default                -> encaminhar(request, response, null);
            }
        } catch (Exception e) {
            response.getWriter().println("Erro: " + e.getMessage());
        }
    }

    private void cadastrar(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Funcionario obj = fromRequest(req);
        dao.salvar(obj);
        encaminhar(req, res, "Funcionário cadastrado com sucesso!");
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        populateFromParams(req);
        encaminhar(req, res, null);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Funcionario obj = fromRequest(req);
        obj.setCodFuncionario(Integer.parseInt(req.getParameter("codFuncionario")));
        dao.alterar(obj);
        encaminhar(req, res, "Funcionário alterado com sucesso!");
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusão.");
        populateFromParams(req);
        encaminhar(req, res, null);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Funcionario obj = new Funcionario();
        obj.setCodFuncionario(Integer.parseInt(req.getParameter("codFuncionario")));
        dao.excluir(obj);
        encaminhar(req, res, "Funcionário excluído com sucesso!");
    }

    private Funcionario fromRequest(HttpServletRequest req) {
        Funcionario obj = new Funcionario();
        obj.setNomeFuncionario(req.getParameter("nomeFuncionario"));
        String dn = req.getParameter("dataNascimento");
        if (dn != null && !dn.isEmpty()) obj.setDataNascimento(LocalDate.parse(dn));
        obj.setSenhaFuncionario(req.getParameter("senhaFuncionario"));
        obj.setCpfFuncionario(req.getParameter("cpfFuncionario"));
        String sal = req.getParameter("salarioFuncionario");
        if (sal != null && !sal.isEmpty()) obj.setSalarioFuncionario(new BigDecimal(sal.replace(",", ".")));
        String turno = req.getParameter("turnos_codTurnos");
        if (turno != null && !turno.isEmpty()) obj.setTurnos_codTurnos(Integer.parseInt(turno));
        String cargo = req.getParameter("cargo_codCargo");
        if (cargo != null && !cargo.isEmpty()) obj.setCargo_codCargo(Integer.parseInt(cargo));
        return obj;
    }

    private void populateFromParams(HttpServletRequest req) {
        req.setAttribute("codFuncionario", req.getParameter("codFuncionario"));
        req.setAttribute("nomeFuncionario", req.getParameter("nomeFuncionario"));
        req.setAttribute("dataNascimento", req.getParameter("dataNascimento"));
        req.setAttribute("senhaFuncionario", req.getParameter("senhaFuncionario"));
        req.setAttribute("cpfFuncionario", req.getParameter("cpfFuncionario"));
        req.setAttribute("salarioFuncionario", req.getParameter("salarioFuncionario"));
        req.setAttribute("turnos_codTurnos", req.getParameter("turnos_codTurnos"));
        req.setAttribute("cargo_codCargo", req.getParameter("cargo_codCargo"));
    }

    private void encaminhar(HttpServletRequest req, HttpServletResponse res, String msg) throws ServletException, IOException {
        req.setAttribute("funcionarios", dao.buscarTodos());
        req.setAttribute("cargos", cargoDao.buscarTodos());
        req.setAttribute("turnos", turnosDao.buscarTodos());
        if (msg != null) req.setAttribute("mensagem", msg);
        RequestDispatcher rd = req.getRequestDispatcher("/CadastroFuncionario.jsp");
        rd.forward(req, res);
    }
}
