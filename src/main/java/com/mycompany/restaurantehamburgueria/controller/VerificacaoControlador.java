package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.ClienteDao;
import com.mycompany.restaurantehamburgueria.model.dao.TokenDao;
import com.mycompany.restaurantehamburgueria.model.dao.UsuarioDao;
import com.mycompany.restaurantehamburgueria.model.entity.Cliente;
import com.mycompany.restaurantehamburgueria.model.entity.TokenVerificacao;
import com.mycompany.restaurantehamburgueria.model.entity.Usuario;
import com.mycompany.restaurantehamburgueria.service.Emails;
import com.mycompany.restaurantehamburgueria.service.EnviadorDeEmail;
import com.mycompany.restaurantehamburgueria.service.Links;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Verificação de email do cliente.
 *
 *   GET  ?t=<token>          abre o link que chegou no email
 *   POST opcao=reenviar      manda outro link
 *
 * Fica liberado no AuthFilter: quem chega aqui, por definição, ainda não
 * conseguiu entrar.
 */
@WebServlet(WebConstante.BASE_PATH + "/VerificacaoControlador")
public class VerificacaoControlador extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(VerificacaoControlador.class.getName());

    /** Quantos links a mesma conta pode pedir por hora. */
    private static final int LIMITE_POR_HORA = 5;

    private final TokenDao tokens = new TokenDao();
    private final ClienteDao clientes = new ClienteDao();
    private final UsuarioDao usuarios = new UsuarioDao();

    // ---------------------------------------------------------------
    // Abrir o link do email
    // ---------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        TokenVerificacao token = tokens.buscarPorToken(req.getParameter("t"));

        if (token == null) {
            concluir(req, res, "invalido",
                     "Esse link não existe. Confira se você copiou o endereço inteiro.");
            return;
        }
        if (token.estaUsado()) {
            // Clicar duas vezes é comum e não é erro: diga que já está pronto.
            concluir(req, res, "jafeito",
                     "Esse email já foi confirmado. É só entrar.");
            return;
        }
        if (token.estaExpirado()) {
            concluir(req, res, "expirado",
                     "Esse link passou da validade. Peça um novo abaixo.");
            return;
        }

        clientes.marcarEmailVerificado(token.getCodCliente());
        tokens.marcarUsado(token.getCodToken());

        Cliente cliente = clientes.buscarPorId(token.getCodCliente());
        if (cliente != null) {
            req.getSession().setAttribute("flash",
                    "Email confirmado. Entre para completar seu cadastro.");
        }
        res.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    // ---------------------------------------------------------------
    // Pedir outro link
    // ---------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        Usuario usuario = usuarios.buscarPorEmail(email);

        // Resposta igual para email inexistente, de funcionário ou já
        // verificado: senão dá para descobrir quais contas existem.
        boolean vale = usuario != null && usuario.isCliente() && !usuario.isEmailVerificado();

        if (vale) {
            if (tokens.emitidosNaUltimaHora(usuario.getCodigo()) >= LIMITE_POR_HORA) {
                req.setAttribute("erro",
                        "Você já pediu vários links na última hora. Aguarde um pouco e tente de novo.");
                req.setAttribute("emailDigitado", email);
                req.getRequestDispatcher("/verificar-email.jsp").forward(req, res);
                return;
            }
            dispararEmail(req, usuario.getCodigo(), usuario.getNome(), usuario.getEmail());
        }

        req.setAttribute("aviso",
                "Se houver uma conta esperando confirmação para esse email, o link acabou de sair.");
        req.setAttribute("emailDigitado", email);
        req.getRequestDispatcher("/verificar-email.jsp").forward(req, res);
    }

    /**
     * Emite o token e manda o email. Usado também pelo CadastroControlador.
     *
     * @return true se o email saiu.
     */
    public static boolean dispararEmail(HttpServletRequest req, int codCliente,
                                        String nome, String email) {
        String token = new TokenDao().emitirPara(codCliente);
        if (token == null) {
            LOG.warning("Não consegui emitir token para o cliente " + codCliente);
            return false;
        }

        String link = Links.absoluto(req, WebConstante.BASE_PATH
                   + "/VerificacaoControlador?t=" + token);
        EnviadorDeEmail enviador = Emails.enviador();

        try {
            enviador.enviar(email,
                            Emails.assuntoVerificacao(),
                            Emails.htmlVerificacao(nome, link),
                            Emails.textoVerificacao(nome, link));
            return true;
        } catch (EnviadorDeEmail.EnvioFalhou e) {
            LOG.log(Level.SEVERE, "Falha ao enviar verificação para " + email, e);
            return false;
        }
    }


    private void concluir(HttpServletRequest req, HttpServletResponse res,
                          String situacao, String mensagem)
            throws ServletException, IOException {
        req.setAttribute("situacao", situacao);
        req.setAttribute("mensagem", mensagem);
        req.getRequestDispatcher("/verificar-email.jsp").forward(req, res);
    }
}
