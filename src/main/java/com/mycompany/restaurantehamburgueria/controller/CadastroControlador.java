package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.UsuarioDao;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Criação de conta de cliente pela vitrine.
 *
 * Controlador próprio, e não o ClienteController: liberar aquele no
 * AuthFilter deixaria `opcao=listar` aberta e a lista de clientes ficaria
 * pública. Aqui só existe uma operação, e ela só grava.
 */
@WebServlet(WebConstante.BASE_PATH + "/CadastroControlador")
public class CadastroControlador extends HttpServlet {

    private static final int SENHA_MINIMA = 6;

    private final UsuarioDao dao = new UsuarioDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String nome     = texto(req.getParameter("nomeCliente"));
        String email    = texto(req.getParameter("email"));
        String senha    = req.getParameter("senhaCliente");
        String telefone = texto(req.getParameter("telefone"));

        String problema = conferir(nome, email, senha);
        if (problema != null) {
            recusar(req, res, problema, nome, email, telefone);
            return;
        }

        int codigo = dao.cadastrarCliente(nome, email, senha, telefone);
        if (codigo <= 0) {
            recusar(req, res, "Não foi possível criar a conta agora. Tente de novo em instantes.",
                    nome, email, telefone);
            return;
        }

        // A conta nasce sem verificação. O link de confirmação sai agora.
        boolean saiu = VerificacaoControlador.dispararEmail(req, codigo, nome, email);

        req.getSession().setAttribute("emailPendente", email);
        req.getSession().setAttribute("flash", saiu
                ? "Conta criada. Enviamos um link de confirmação para " + email + "."
                : "Conta criada, mas o email de confirmação não saiu. Peça outro abaixo.");

        res.sendRedirect(req.getContextPath() + "/verificar-email.jsp");
    }

    /** Devolve a mensagem do que está errado, ou null se estiver tudo certo. */
    private String conferir(String nome, String email, String senha) {
        if (nome.isEmpty() || email.isEmpty() || senha == null || senha.isEmpty()) {
            return "Preencha nome, email e senha.";
        }
        if (nome.length() > 150) {
            return "O nome passa de 150 caracteres. Use uma versão mais curta.";
        }
        if (!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            return "Esse email não parece válido. Confira o endereço.";
        }
        if (email.length() > 255) {
            return "O email passa de 255 caracteres.";
        }
        if (senha.length() < SENHA_MINIMA) {
            return "A senha precisa de pelo menos " + SENHA_MINIMA + " caracteres.";
        }
        if (dao.emailJaUsado(email)) {
            return "Já existe uma conta com esse email. Entre em vez de criar outra.";
        }
        return null;
    }

    /** Volta para o formulário com o motivo e o que a pessoa já tinha digitado. */
    private void recusar(HttpServletRequest req, HttpServletResponse res, String motivo,
                         String nome, String email, String telefone)
            throws ServletException, IOException {

        req.setAttribute("erro", motivo);
        req.setAttribute("nomeDigitado", nome);
        req.setAttribute("emailDigitado", email);
        req.setAttribute("telefoneDigitado", telefone);
        req.getRequestDispatcher("/CadastroUsuario.jsp").forward(req, res);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.sendRedirect(req.getContextPath() + "/CadastroUsuario.jsp");
    }

    private String texto(String valor) {
        return valor == null ? "" : valor.trim();
    }
}
