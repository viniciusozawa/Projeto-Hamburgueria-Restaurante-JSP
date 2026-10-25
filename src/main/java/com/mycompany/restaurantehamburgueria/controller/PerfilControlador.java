package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.ClienteDao;
import com.mycompany.restaurantehamburgueria.model.dao.PedidoDao;
import com.mycompany.restaurantehamburgueria.model.dao.PedidoPorCardapioDao;
import com.mycompany.restaurantehamburgueria.model.entity.Cliente;
import com.mycompany.restaurantehamburgueria.model.entity.Pedido;
import com.mycompany.restaurantehamburgueria.model.entity.PedidoPorCardapio;
import com.mycompany.restaurantehamburgueria.model.entity.Usuario;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * A área do cliente.
 *
 *   GET                    "Minha conta": os pedidos e os dados dele
 *   POST                   segunda tela do cadastro (telefone e CPF)
 *   POST opcao=atualizar   salva nome, telefone e CPF da "Minha conta"
 *
 * O cliente vem SEMPRE da sessão, nunca de um parâmetro: não existe URL que
 * mostre ou altere os dados de outra pessoa.
 *
 * Só chega na segunda tela quem já confirmou o email. Enquanto
 * `cadastroCompleto` for 0, o cliente entra mas não consegue chamar o garçom
 * nem abrir pedido.
 */
@WebServlet(WebConstante.BASE_PATH + "/PerfilControlador")
public class PerfilControlador extends HttpServlet {

    private final ClienteDao dao = new ClienteDao();
    private final PedidoDao pedidos = new PedidoDao();
    private final PedidoPorCardapioDao itens = new PedidoPorCardapioDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession sessao = req.getSession(false);
        Usuario usuario = sessao == null ? null : (Usuario) sessao.getAttribute("usuario");

        if (usuario == null || !usuario.isCliente()) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        if ("atualizar".equals(req.getParameter("opcao"))) {
            atualizar(req, res, sessao, usuario);
            return;
        }

        String telefone = apenasDigitos(req.getParameter("telefone"));
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

        // Vai para a "Minha conta", que mostra o recado. O index.jsp não
        // mostra flash: o recado se perdia e reaparecia fora de hora depois.
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/PerfilControlador");
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

    /** "Minha conta": os dados do cliente da sessão e os pedidos dele. */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession sessao = req.getSession(false);
        Usuario usuario = sessao == null ? null : (Usuario) sessao.getAttribute("usuario");

        if (usuario == null || !usuario.isCliente()) {
            // funcionário que caiu aqui tem o painel dele
            res.sendRedirect(req.getContextPath() + (usuario == null ? "/login.jsp" : "/painel.jsp"));
            return;
        }
        if (!usuario.isCadastroCompleto()) {
            res.sendRedirect(req.getContextPath() + "/completar-cadastro.jsp");
            return;
        }

        mostrarConta(req, res, dao.buscarPorId(usuario.getCodigo()));
    }

    private void mostrarConta(HttpServletRequest req, HttpServletResponse res, Cliente cliente)
            throws ServletException, IOException {

        List<Pedido> lista = pedidos.buscarPorCliente(cliente.getCodCliente());

        // Itens de cada pedido, para a comanda mostrar o que foi pedido.
        Map<Integer, List<PedidoPorCardapio>> itensPorPedido = new HashMap<>();
        for (Pedido p : lista) {
            itensPorPedido.put(p.getCodpedido(), itens.buscarPorPedido(p.getCodpedido()));
        }

        // Mesma baixa do painel: pago o total, o pedido sai de "Em aberto" e
        // vai para o histórico do cliente. Nada é apagado.
        List<Pedido> abertos = new ArrayList<>();
        List<Pedido> pagos = new ArrayList<>();
        for (Pedido p : lista) {
            (p.isFinalizado() ? pagos : abertos).add(p);
        }

        req.setAttribute("cliente", cliente);
        req.setAttribute("pedidos", lista);
        req.setAttribute("pedidosAbertos", abertos);
        req.setAttribute("pedidosPagos", pagos);
        req.setAttribute("itensPorPedido", itensPorPedido);
        req.getRequestDispatcher("/minha-conta.jsp").forward(req, res);
    }

    private void atualizar(HttpServletRequest req, HttpServletResponse res,
                           HttpSession sessao, Usuario usuario)
            throws ServletException, IOException {

        String nome     = texto(req.getParameter("nomeCliente"));
        String telefone = apenasDigitos(req.getParameter("telefone"));
        String cpf      = apenasDigitos(req.getParameter("cpfCliente"));

        String problema = nome.isEmpty() ? "Informe seu nome."
                        : nome.length() > 150 ? "O nome passa de 150 caracteres. Use uma versão mais curta."
                        : conferir(telefone, cpf, usuario.getCodigo());

        if (problema != null) {
            // Volta com o que a pessoa digitou, não com o que está no banco.
            Cliente digitado = dao.buscarPorId(usuario.getCodigo());
            digitado.setNomeCliente(nome);
            digitado.setTelefone(telefone);
            digitado.setCpfCliente(cpf);
            req.setAttribute("erro", problema);
            mostrarConta(req, res, digitado);
            return;
        }

        dao.atualizarDados(usuario.getCodigo(), nome, telefone, cpf);

        // A sessão guarda uma cópia: sem isto o "Oi, fulano" do topo ficaria
        // com o nome antigo até o próximo login.
        usuario.setNome(nome);
        sessao.setAttribute("usuario", usuario);
        sessao.setAttribute("user", usuario.getPrimeiroNome());
        sessao.setAttribute("flash", "Dados atualizados.");

        // PRG: atualizar a página depois de salvar não reenvia o formulário.
        res.sendRedirect(req.getContextPath() + WebConstante.BASE_PATH + "/PerfilControlador");
    }

    private String texto(String v) {
        return v == null ? "" : v.trim();
    }

    /** Guarda CPF e telefone só com dígitos: a máscara é assunto da tela (js/mascaras.js). */
    private String apenasDigitos(String v) {
        return v == null ? "" : v.replaceAll("[^0-9]", "");
    }
}
