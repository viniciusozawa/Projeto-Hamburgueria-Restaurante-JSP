package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.ClienteDao;
import com.mycompany.restaurantehamburgueria.model.entity.Usuario;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Segunda tela do cadastro: telefone e CPF.
 *
 * Só chega aqui quem já confirmou o email. Enquanto `cadastroCompleto` for 0,
 * o cliente entra mas não consegue chamar o garçom nem abrir pedido.
 */
@WebServlet(WebConstante.BASE_PATH + "/PerfilControlador")
public class PerfilControlador extends HttpServlet {

    private final ClienteDao dao = new ClienteDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession sessao = req.getSession(false);
        Usuario usuario = sessao == null ? null : (Usuario) sessao.getAttribute("usuario");

        if (usuario == null || !usuario.isCliente()) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String telefone = texto(req.getParameter("telefone"));
        String cpf      = apenasDigitos(req.getParameter("cpfCliente"));

        String problema = conferir(telefone, cpf, usuario.getCodigo());
        if (problema != null) {
            req.setAttribute("erro", problema);
            req.setAttribute("telefoneDigitado", telefone);
            req.setAttribute("cpfDigitado", cpf);
            req.getRequestDispatcher("/completar-cadastro.jsp").forward(req, res);
            return;
        }

        dao.completarCadastro(usuario.getCodigo(), telefone, cpf);

        // A sessão guarda uma cópia do usuário: sem atualizar aqui, a conta
        // continuaria parecendo incompleta até o próximo login.
        usuario.setCadastroCompleto(true);
        sessao.setAttribute("usuario", usuario);
        sessao.setAttribute("flash", "Cadastro completo. Bom apetite!");

        res.sendRedirect(req.getContextPath() + "/index.jsp");
    }

    private String conferir(String telefone, String cpf, int codCliente) {
        if (telefone.isEmpty()) {
            return "Informe um telefone para a gente avisar quando o pedido sair.";
        }
        if (telefone.replaceAll("[^0-9]", "").length() < 10) {
            return "Esse telefone parece curto. Inclua o DDD.";
        }
        if (cpf.isEmpty()) {
            return "Informe o CPF.";
        }
        if (cpf.length() != 11) {
            return "O CPF precisa ter 11 dígitos.";
        }
        if (dao.cpfDeOutroCliente(cpf, codCliente)) {
            return "Esse CPF já está em outra conta.";
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.sendRedirect(req.getContextPath() + "/completar-cadastro.jsp");
    }

    private String texto(String v) {
        return v == null ? "" : v.trim();
    }

    /** Guarda o CPF só com dígitos: a máscara é assunto da tela. */
    private String apenasDigitos(String v) {
        return v == null ? "" : v.replaceAll("[^0-9]", "");
    }
}
