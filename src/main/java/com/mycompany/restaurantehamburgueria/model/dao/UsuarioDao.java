package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Perfil;
import com.mycompany.restaurantehamburgueria.model.entity.Usuario;
import com.mycompany.restaurantehamburgueria.service.Senha;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Autenticação. Não tem tabela própria: lê de `funcionario` e de `cliente`.
 *
 * A ordem importa — funcionário é procurado primeiro. Se a mesma pessoa
 * estiver nas duas tabelas com o mesmo email, ela entra com o acesso maior.
 */
public class UsuarioDao extends GenericoDAO<Usuario> {

    private final ConnectionFactory fabrica = ConnectionFactory.getInstance();

    /**
     * Procura quem tem esse email. Devolve null se ninguém tiver.
     *
     * Quem confere a senha é o controlador, não este método — aqui só
     * trazemos o hash guardado.
     */
    public Usuario buscarPorEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        String alvo = email.trim().toLowerCase();

        Usuario funcionario = buscarFuncionario(alvo);
        return funcionario != null ? funcionario : buscarCliente(alvo);
    }

    /*
     * NÃO filtre por `f.disponivel` aqui.
     *
     * Essa coluna não quer dizer "conta ativa": o evento agendado
     * event_disponibilidadeTrabalho a reescreve a cada minuto conforme o
     * horário atual esteja ou não dentro do turno do funcionário. Usá-la no
     * login faz a conta parar de entrar assim que o turno acaba — inclusive a
     * do gerente. Foi exatamente o que aconteceu aqui às 20h31.
     *
     * Se um dia for preciso desligar o acesso de alguém, isso pede uma coluna
     * própria (ex.: `ativo`), decidida por gente e não por relógio.
     */
    private Usuario buscarFuncionario(String email) {
        String sql =
            "SELECT f.codFuncionario, f.nomeFuncionario, f.email, f.senhaFuncionario, "
          + "       f.cargo_codCargo, c.nomeCargo, c.perfil "
          + "  FROM funcionario f "
          + "  LEFT JOIN cargo c ON c.codCargo = f.cargo_codCargo "
          + " WHERE LOWER(f.email) = ?";

        try (Connection con = fabrica.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return Usuario.deFuncionario(
                            rs.getInt("codFuncionario"),
                            rs.getString("nomeFuncionario"),
                            rs.getString("email"),
                            rs.getString("senhaFuncionario"),
                            rs.getInt("cargo_codCargo"),
                            rs.getString("nomeCargo"),
                            Perfil.de(rs.getString("perfil")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Usuario buscarCliente(String email) {
        String sql = "SELECT codCliente, nomeCliente, email, senhaCliente, "
                   + "       emailVerificado, cadastroCompleto "
                   + "  FROM cliente WHERE LOWER(email) = ?";

        try (Connection con = fabrica.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Usuario u = Usuario.deCliente(
                            rs.getInt("codCliente"),
                            rs.getString("nomeCliente"),
                            rs.getString("email"),
                            rs.getString("senhaCliente"));
                    u.setEmailVerificado(rs.getBoolean("emailVerificado"));
                    u.setCadastroCompleto(rs.getBoolean("cadastroCompleto"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Email já cadastrado em qualquer uma das duas tabelas. */
    public boolean emailJaUsado(String email) {
        return buscarPorEmail(email) != null;
    }

    /**
     * Cria a conta de um cliente pelo site.
     *
     * O CPF fica nulo de propósito: quem se cadastra pela vitrine informa
     * nome, email e senha. O CPF é coletado no balcão, quando houver nota.
     *
     * @return o codCliente gerado, ou -1 se não gravou.
     */
    public int cadastrarCliente(String nome, String email, String senhaDigitada, String telefone) {
        String sql = "INSERT INTO cliente (nomeCliente, email, cpfCliente, senhaCliente, telefone, "
                   + "                      emailVerificado, cadastroCompleto) "
                   + "VALUES (?, ?, NULL, ?, ?, 0, 0)";
        save(sql, nome.trim(), email.trim().toLowerCase(),
             Senha.gerarHash(senhaDigitada), telefone);
        return getLastId();
    }

    /**
     * Regrava a senha já em bcrypt.
     *
     * Serve à conversão preguiçosa: contas que ficaram em texto puro da época
     * anterior se convertem sozinhas no primeiro login que dá certo.
     */
    public void atualizarSenha(Usuario usuario, String novoHash) {
        String sql = usuario.isFuncionario()
                ? "UPDATE funcionario SET senhaFuncionario = ? WHERE codFuncionario = ?"
                : "UPDATE cliente SET senhaCliente = ? WHERE codCliente = ?";
        save(sql, novoHash, usuario.getCodigo());
        usuario.setSenhaHash(novoHash);
    }
}
