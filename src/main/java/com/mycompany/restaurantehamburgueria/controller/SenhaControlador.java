package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.TokenSenhaDao;
import com.mycompany.restaurantehamburgueria.model.dao.UsuarioDao;
import com.mycompany.restaurantehamburgueria.model.entity.Usuario;
import com.mycompany.restaurantehamburgueria.service.Emails;
import com.mycompany.restaurantehamburgueria.service.EnviadorDeEmail;
import com.mycompany.restaurantehamburgueria.service.Senha;
import com.mycompany.restaurantehamburgueria.service.Links;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * "Esqueci minha senha", nas três etapas:
 *
 *   POST opcao=pedir      manda o link para o email
 *   GET  ?t=token         abre o formulário da senha nova
 *   POST opcao=redefinir  grava a senha nova
 *
 * Serve cliente e funcionário: os dois entram no sistema.
 * Fica liberado no AuthFilter — quem esqueceu a senha não consegue entrar.
 */
@WebServlet(WebConstante.BASE_PATH + "/SenhaControlador")
public class SenhaControlador extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(SenhaControlador.class.getName());

    private static final int SENHA_MINIMA = 6;

    private final UsuarioDao usuarios = new UsuarioDao();
    private final TokenSenhaDao tokens = new TokenSenhaDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if ("redefinir".equals(req.getParameter("opcao"))) {
            redefinir(req, res);
        } else {
            pedir(req, res);
        }
    }

    // ---------------------------------------------------------------
    // Etapa 1 — pedir o link
    // ---------------------------------------------------------------
    private void pedir(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        Usuario usuario = usuarios.buscarPorEmail(email);

        if (usuario != null) {
            if (tokens.pedidosNaUltimaHora(usuario) >= TokenSenhaDao.LIMITE_POR_HORA) {
                LOG.warning("Muitos pedidos de recuperação para " + usuario.getEmail());
            } else {
                dispararEmail(req, usuario);
            }
        }

        // MESMA resposta com ou sem conta. Dizer "esse email não existe"
        // transformaria a tela num consultor de quem tem cadastro aqui.
        req.setAttribute("aviso",
                "Se existir uma conta com esse email, o link de redefinição acabou de sair. "
              + "Ele vale por " + TokenSenhaDao.MINUTOS_DE_VALIDADE + " minutos.");
        req.setAttribute("emailDigitado", email == null ? "" : email.trim());
        req.getRequestDispatcher("/esqueci-senha.jsp").forward(req, res);
    }

    private void dispararEmail(HttpServletRequest req, Usuario usuario) {
        String token = tokens.emitirPara(usuario);
        if (token == null) {
            LOG.warning("Não consegui emitir token de senha para " + usuario.getEmail());
            return;
        }

        String link = Links.absoluto(req, WebConstante.BASE_PATH
                   + "/SenhaControlador?t=" + token);

        try {
            Emails.enviador().enviar(
                    usuario.getEmail(),
                    Emails.assuntoRecuperacao(),
                    Emails.htmlRecuperacao(usuario.getPrimeiroNome(), link,
                                           TokenSenhaDao.MINUTOS_DE_VALIDADE),
                    Emails.textoRecuperacao(usuario.getPrimeiroNome(), link,
                                            TokenSenhaDao.MINUTOS_DE_VALIDADE));
        } catch (EnviadorDeEmail.EnvioFalhou e) {
            LOG.log(Level.SEVERE, "Falha ao enviar recuperação para " + usuario.getEmail(), e);
        }
    }

    // ---------------------------------------------------------------
    // Etapa 2 — abrir o formulário da senha nova
    // ---------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String token = req.getParameter("t");
        TokenSenhaDao.Dono dono = tokens.donoDoTokenValido(token);

        if (dono == null) {
            // Vencido, já usado e inexistente dão a mesma resposta: quem abriu
            // um link velho precisa pedir outro, e o motivo exato não ajuda.
            req.setAttribute("erro",
                    "Esse link não vale mais. Peça outro abaixo — eles expiram em "
                  + TokenSenhaDao.MINUTOS_DE_VALIDADE + " minutos e só funcionam uma vez.");
            req.getRequestDispatcher("/esqueci-senha.jsp").forward(req, res);
            return;
        }

        // O token viaja escondido no formulário, e não na URL da próxima
        // requisição: URL vai para o histórico e para o cabeçalho Referer.
        req.setAttribute("token", token);
        req.getRequestDispatcher("/nova-senha.jsp").forward(req, res);
    }

    // ---------------------------------------------------------------
    // Etapa 3 — gravar a senha nova
    // ---------------------------------------------------------------
    private void redefinir(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String token     = req.getParameter("token");
        String senha     = req.getParameter("senha");
        String confirmar = req.getParameter("confirmar");

        // O token é reconferido aqui: quem enviou o formulário pode ter
        // demorado, e validar só na etapa 2 deixaria a porta aberta.
        TokenSenhaDao.Dono dono = tokens.donoDoTokenValido(token);
        if (dono == null) {
            req.setAttribute("erro", "Esse link não vale mais. Peça outro abaixo.");
            req.getRequestDispatcher("/esqueci-senha.jsp").forward(req, res);
            return;
        }

        String problema = conferir(senha, confirmar);
        if (problema != null) {
            req.setAttribute("erro", problema);
            req.setAttribute("token", token);
            req.getRequestDispatcher("/nova-senha.jsp").forward(req, res);
            return;
        }

        Usuario alvo = new Usuario();
        alvo.setCodigo(dono.codigo);
        alvo.setTipo(dono.tipo);
        usuarios.atualizarSenha(alvo, Senha.gerarHash(senha));

        tokens.marcarUsado(dono.codToken);

        // Sessão nova: se havia alguma sessão aberta nesta máquina, ela morre
        // junto com a senha antiga.
        HttpSession antiga = req.getSession(false);
        if (antiga != null) {
            antiga.invalidate();
        }
        req.getSession(true).setAttribute("flash",
                "Senha alterada. Entre com a senha nova.");

        LOG.info("Senha redefinida para " + dono.tipo + " #" + dono.codigo);
        res.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    private String conferir(String senha, String confirmar) {
        if (senha == null || senha.isEmpty()) {
            return "Digite a senha nova.";
        }
        if (senha.length() < SENHA_MINIMA) {
            return "A senha precisa de pelo menos " + SENHA_MINIMA + " caracteres.";
        }
        if (!senha.equals(confirmar)) {
            return "As senhas estão diferentes. Repita a mesma senha nos dois campos.";
        }
        return null;
    }

}
