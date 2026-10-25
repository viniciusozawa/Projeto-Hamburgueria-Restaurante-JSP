package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.ExclusaoRecusada;
import com.mycompany.restaurantehamburgueria.model.dao.CargoDao;
import com.mycompany.restaurantehamburgueria.model.dao.FuncionarioDao;
import com.mycompany.restaurantehamburgueria.model.dao.TurnosDao;
import com.mycompany.restaurantehamburgueria.model.entity.Cargo;
import com.mycompany.restaurantehamburgueria.model.entity.Funcionario;
import com.mycompany.restaurantehamburgueria.model.entity.Turnos;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(WebConstante.BASE_PATH + "/FuncionarioController")
public class FuncionarioController extends HttpServlet {

    private final FuncionarioDao dao      = new FuncionarioDao();
    private final CargoDao cargoDao       = new CargoDao();
    private final TurnosDao turnosDao     = new TurnosDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao       = request.getParameter("opcao");
        if (opcao == null || opcao.isEmpty()) opcao = "listar";

        String codIn       = request.getParameter("codFuncionario");
        String nomeIn      = request.getParameter("nomeFuncionario");
        String nascIn      = request.getParameter("dataNascimento");
        String senhaIn     = request.getParameter("senhaFuncionario");
        String cpfIn       = apenasDigitos(request.getParameter("cpfFuncionario"));
        String salarioIn   = request.getParameter("salarioFuncionario");
        String codTurnosIn = request.getParameter("codTurnos");
        String codCargoIn  = request.getParameter("codCargo");

        try {
            switch (opcao) {
                case "listar":
                    encaminhar(request, response);
                    break;
                case "cadastrar":
                    cadastrar(request, response, nomeIn, nascIn, senhaIn, cpfIn, salarioIn, codTurnosIn, codCargoIn);
                    break;
                case "enviarAlterar":
                    enviarAlterar(request, response, codIn, nomeIn, nascIn, senhaIn, cpfIn, salarioIn, codTurnosIn, codCargoIn);
                    break;
                case "confirmarAlterar":
                    confirmarAlterar(request, response, codIn, nomeIn, nascIn, senhaIn, cpfIn, salarioIn, codTurnosIn, codCargoIn);
                    break;
                case "enviarExcluir":
                    enviarExcluir(request, response, codIn, nomeIn, nascIn, senhaIn, cpfIn, salarioIn, codTurnosIn, codCargoIn);
                    break;
                case "confirmarExcluir":
                    confirmarExcluir(request, response, codIn);
                    break;
                default:
                    encaminhar(request, response);
            }
        } catch (Exception e) {
            // sem o tipo, o navegador chuta a codificação e o acento da mensagem quebra
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().println("Erro: " + e.getMessage());
        }
    }

    private Funcionario montar(String nome, String nasc, String senha, String cpf, String salario, String codTurnos, String codCargo) {
        Funcionario obj = new Funcionario();
        obj.setNomeFuncionario(nome);
        if (nasc != null && !nasc.isEmpty()) obj.setDataNascimento(LocalDate.parse(nasc));
        obj.setSenhaFuncionario(senha);
        obj.setCpfFuncionario(cpf);
        if (salario != null && !salario.isEmpty()) obj.setSalarioFuncionario(Double.valueOf(salario));
        Turnos t = new Turnos(); t.setCodTurnos(Integer.valueOf(codTurnos)); obj.setTurnosFuncionario(t);
        Cargo c = new Cargo(); c.setCodCargo(Integer.valueOf(codCargo)); obj.setCargoFuncionario(c);
        return obj;
    }

    private void cadastrar(HttpServletRequest req, HttpServletResponse res,
            String nome, String nasc, String senha, String cpf, String salario, String codTurnos, String codCargo) throws IOException {
        dao.salvar(montar(nome, nasc, senha, cpf, salario, codTurnos, codCargo));
        req.getSession().setAttribute("flash", "Funcionário cadastrado.");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/FuncionarioController?opcao=listar");
    }

    private void enviarAlterar(HttpServletRequest req, HttpServletResponse res,
            String cod, String nome, String nasc, String senha, String cpf, String salario, String codTurnos, String codCargo) throws ServletException, IOException {
        req.setAttribute("codFuncionario", cod);
        req.setAttribute("nomeFuncionario", nome);
        req.setAttribute("dataNascimento", nasc);
        req.setAttribute("senhaFuncionario", senha);
        req.setAttribute("cpfFuncionario", cpf);
        req.setAttribute("salarioFuncionario", salario);
        req.setAttribute("codTurnosAtual", Integer.valueOf(codTurnos));
        req.setAttribute("codCargoAtual", Integer.valueOf(codCargo));
        req.setAttribute("opcao", "confirmarAlterar");
        req.setAttribute("mensagem", "Edite os dados e clique em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarAlterar(HttpServletRequest req, HttpServletResponse res,
            String cod, String nome, String nasc, String senha, String cpf, String salario, String codTurnos, String codCargo) throws IOException {
        Funcionario obj = montar(nome, nasc, senha, cpf, salario, codTurnos, codCargo);
        obj.setCodFuncionario(Integer.valueOf(cod));
        dao.alterar(obj);
        req.getSession().setAttribute("flash", "Funcionário alterado.");
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/FuncionarioController?opcao=listar");
    }

    private void enviarExcluir(HttpServletRequest req, HttpServletResponse res,
            String cod, String nome, String nasc, String senha, String cpf, String salario, String codTurnos, String codCargo) throws ServletException, IOException {
        req.setAttribute("codFuncionario", cod);
        req.setAttribute("nomeFuncionario", nome);
        req.setAttribute("dataNascimento", nasc);
        req.setAttribute("senhaFuncionario", senha);
        req.setAttribute("cpfFuncionario", cpf);
        req.setAttribute("salarioFuncionario", salario);
        req.setAttribute("codTurnosAtual", Integer.valueOf(codTurnos));
        req.setAttribute("codCargoAtual", Integer.valueOf(codCargo));
        req.setAttribute("opcao", "confirmarExcluir");
        req.setAttribute("mensagem", "Confirme a exclusao clicando em Salvar.");
        encaminhar(req, res);
    }

    private void confirmarExcluir(HttpServletRequest req, HttpServletResponse res, String cod) throws IOException {
        Funcionario obj = new Funcionario();
        obj.setCodFuncionario(Integer.valueOf(cod));
        try {
            dao.excluir(obj);
            req.getSession().setAttribute("flash", "Funcionário excluído.");
        } catch (ExclusaoRecusada e) {
            // o banco recusou (registro em uso): diz onde, em vez de fingir sucesso
            req.getSession().setAttribute("flash", e.getMessage());
            req.getSession().setAttribute("flashTipo", "alerta");
        }
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/FuncionarioController?opcao=listar");
    }

    /** Guarda o CPF só com dígitos: a máscara é assunto da tela (js/mascaras.js). */
    private static String apenasDigitos(String v) {
        return v == null ? null : v.replaceAll("[^0-9]", "");
    }

    private void encaminhar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String flash = (String) request.getSession().getAttribute("flash");
        if (flash != null) {
            if (request.getAttribute("mensagem") == null) request.setAttribute("mensagem", flash);
            request.getSession().removeAttribute("flash");
        }
        List<Funcionario> lista = dao.buscarTodos();
        request.setAttribute("funcionarios", lista);
        request.setAttribute("cargos", cargoDao.buscarTodos());
        request.setAttribute("turnos", turnosDao.buscarTodos());
        RequestDispatcher rd = request.getRequestDispatcher("/CadastroFuncionario.jsp");
        rd.forward(request, response);
    }
}
