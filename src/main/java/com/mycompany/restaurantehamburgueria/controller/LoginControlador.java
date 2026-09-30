package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.UsuarioDao;
import com.mycompany.restaurantehamburgueria.model.entity.Usuario;
import com.mycompany.restaurantehamburgueria.service.Senha;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Entrada e saída do sistema.
 *
 * POST entra, GET com opcao=sair encerra. Não existe tabela `usuario`: a
 * autenticação lê de `funcionario` e de `cliente` (ver UsuarioDao).
 */
@WebServlet(WebConstante.BASE_PATH + "/LoginControlador")
public class LoginControlador extends HttpServlet {

    private final UsuarioDao dao = new UsuarioDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String senha = req.getParameter("senha");

        if (vazio(email) || vazio(senha)) {
            recusar(req, res, "Informe o email e a senha para entrar.", email);
            return;
        }

        Usuario usuario = dao.buscarPorEmail(email);

        if (usuario == null || !senhaConfere(usuario, senha)) {
            // A mesma mensagem para email inexistente e senha errada: dizer
            // qual dos dois falhou entrega quais emails estão cadastrados.
            recusar(req, res, "Email ou senha não conferem. Confira e tente de novo.", email);
            return;
        }

        // Cliente sem email confirmado não entra. A sessão nem chega a abrir.
        if (usuario.isCliente() && !usuario.isEmailVerificado()) {
            req.getSession().setAttribute("emailPendente", usuario.getEmail());
            res.sendRedirect(req.getContextPath() + "/verificar-email.jsp?pendente=1");
            return;
        }

        // Funcionário cujo cargo ficou em OUTRO não tem o que fazer no sistema.
        if (usuario.isFuncionario() && !usuario.getPerfil().temPainel()) {
            recusar(req, res,
                    "Seu cargo ainda não tem acesso ao sistema. Fale com a gerência.", email);
            return;
        }

        abrirSessao(req, usuario);

        // PRG: redireciona em vez de encaminhar, para que atualizar a página
        // não reenvie o formulário de login.
        String destino;
        if (usuario.isFuncionario()) {
            destino = "/painel.jsp";
        } else if (!usuario.isCadastroCompleto()) {
            destino = "/completar-cadastro.jsp";   // falta telefone e CPF
        } else {
            destino = "/index.jsp";
        }
        res.sendRedirect(req.getContextPath() + destino);
    }

    /**
     * Confere a senha e converte o que ficou de antes da migração.
     *
     * Quem já estava no banco tem senha em texto puro. Acertando, a conta é
     * regravada em bcrypt na hora — cada usuário se converte sozinho no
     * primeiro login. Ver a nota em Senha.confereLegado.
     */
    private boolean senhaConfere(Usuario usuario, String digitada) {
        String guardada = usuario.getSenhaHash();

        if (Senha.ehHash(guardada)) {
            return Senha.confere(digitada, guardada);
        }

        if (Senha.confereLegado(digitada, guardada)) {
            dao.atualizarSenha(usuario, Senha.gerarHash(digitada));
            return true;
        }
        return false;
    }

    private void abrirSessao(HttpServletRequest req, Usuario usuario) {
        // Sessão nova a cada login: sem isso um id de sessão capturado antes
        // continuaria valendo depois que a pessoa entra (session fixation).
        HttpSession antiga = req.getSession(false);
        if (antiga != null) {
            antiga.invalidate();
        }

        HttpSession sessao = req.getSession(true);
        sessao.setAttribute("user", usuario.getPrimeiroNome()); // o AuthFilter olha este
        sessao.setAttribute("usuario", usuario);

        // O perfil fica na sessão para as JSPs decidirem o que mostrar.
        sessao.setAttribute("perfil", usuario.getPerfil().name());

        // O código que a comanda precisa, já pronto para o PedidoController.
        if (usuario.isFuncionario()) {
            sessao.setAttribute("codFuncionario", usuario.getCodigo());
        } else {
            sessao.setAttribute("codCliente", usuario.getCodigo());
        }
    }

    private void recusar(HttpServletRequest req, HttpServletResponse res, String motivo, String email)
            throws ServletException, IOException {
        req.setAttribute("erro", motivo);
        req.setAttribute("emailDigitado", email == null ? "" : email.trim());
        req.getRequestDispatcher("/login.jsp").forward(req, res);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if ("sair".equalsIgnoreCase(req.getParameter("opcao"))) {
            sair(req, res);
        } else {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    private void sair(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession sessao = req.getSession(false);
        if (sessao != null) {
            sessao.invalidate();
        }
        // A mensagem vai na URL porque a sessão que guardaria o flash acabou.
        res.sendRedirect(req.getContextPath() + "/login.jsp?saiu=1");
    }

    private boolean vazio(String s) {
        return s == null || s.trim().isEmpty();
    }
}
