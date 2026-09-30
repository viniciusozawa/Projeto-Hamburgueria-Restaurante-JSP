package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Usuario;
import com.mycompany.restaurantehamburgueria.service.Tokens;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 * Tokens de recuperação de senha.
 *
 * Separado do TokenDao (verificação de email) de propósito: um token emitido
 * para confirmar email não pode servir para trocar senha. E aqui o dono pode
 * ser cliente OU funcionário — os dois entram no sistema.
 */
public class TokenSenhaDao extends GenericoDAO<Object> {

    /** Uma hora. Link que troca senha vale menos tempo do que o de confirmação. */
    public static final int MINUTOS_DE_VALIDADE = 60;

    /** Quantos pedidos a mesma conta pode fazer por hora. */
    public static final int LIMITE_POR_HORA = 5;

    private final ConnectionFactory fabrica = ConnectionFactory.getInstance();

    /** O que um token válido aponta. */
    public static class Dono {
        public final Usuario.Tipo tipo;
        public final int codigo;
        public final int codToken;

        Dono(Usuario.Tipo tipo, int codigo, int codToken) {
            this.tipo = tipo;
            this.codigo = codigo;
            this.codToken = codToken;
        }
    }

    /**
     * Emite um token e devolve o valor EM CLARO, que só existe aqui e dentro
     * do email. No banco fica apenas o hash.
     *
     * Os pendentes do mesmo dono são fechados: pedir um link novo tem que
     * invalidar o anterior, senão um link antigo continua abrindo a porta.
     */
    public String emitirPara(Usuario usuario) {
        invalidarPendentes(usuario);

        String token = Tokens.gerar();
        LocalDateTime expira = LocalDateTime.now().plusMinutes(MINUTOS_DE_VALIDADE);

        String sql = "INSERT INTO token_senha (tipoDono, codDono, tokenHash, expiraEm) "
                   + "VALUES (?, ?, ?, ?)";
        save(sql, usuario.getTipo().name(), usuario.getCodigo(),
             Tokens.hashDe(token), Timestamp.valueOf(expira));

        return getLastId() > 0 ? token : null;
    }

    public void invalidarPendentes(Usuario usuario) {
        String sql = "UPDATE token_senha SET usadoEm = NOW() "
                   + " WHERE tipoDono = ? AND codDono = ? AND usadoEm IS NULL";
        save(sql, usuario.getTipo().name(), usuario.getCodigo());
    }

    /**
     * Procura o token que chegou na URL e devolve o dono, se ele ainda valer.
     *
     * Devolve null tanto para token inexistente quanto para usado ou vencido:
     * quem chama não tem o que fazer de diferente em cada caso, e responder
     * igual evita dizer a um curioso qual token existiu um dia.
     */
    public Dono donoDoTokenValido(String tokenEmClaro) {
        if (tokenEmClaro == null || tokenEmClaro.trim().isEmpty()) {
            return null;
        }

        String sql = "SELECT codToken, tipoDono, codDono "
                   + "  FROM token_senha "
                   + " WHERE tokenHash = ? AND usadoEm IS NULL AND expiraEm > NOW()";

        try (Connection con = fabrica.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setString(1, Tokens.hashDe(tokenEmClaro.trim()));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Dono(
                            Usuario.Tipo.valueOf(rs.getString("tipoDono")),
                            rs.getInt("codDono"),
                            rs.getInt("codToken"));
                }
            }
        } catch (SQLException | IllegalArgumentException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Fecha o token. Um link só troca senha uma vez. */
    public void marcarUsado(int codToken) {
        save("UPDATE token_senha SET usadoEm = NOW() WHERE codToken = ?", codToken);
    }

    /** Quantos pedidos a conta fez na última hora — trava de reenvio. */
    public int pedidosNaUltimaHora(Usuario usuario) {
        String sql = "SELECT COUNT(*) FROM token_senha "
                   + " WHERE tipoDono = ? AND codDono = ? "
                   + "   AND criadoEm > (NOW() - INTERVAL 1 HOUR)";

        try (Connection con = fabrica.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setString(1, usuario.getTipo().name());
            pstmt.setInt(2, usuario.getCodigo());
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
