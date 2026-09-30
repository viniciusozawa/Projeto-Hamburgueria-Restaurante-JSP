package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.TokenVerificacao;
import com.mycompany.restaurantehamburgueria.service.Tokens;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class TokenDao extends GenericoDAO<TokenVerificacao> {

    private final ConnectionFactory fabrica = ConnectionFactory.getInstance();

    /**
     * Cria um token para o cliente e devolve o valor EM CLARO, que só existe
     * aqui e dentro do email. No banco fica apenas o hash.
     *
     * Os tokens anteriores do mesmo cliente são marcados como usados: pedir um
     * link novo deve invalidar o antigo, senão um link vazado continua servindo.
     */
    public String emitirPara(int codCliente) {
        invalidarPendentes(codCliente);

        String token = Tokens.gerar();
        LocalDateTime expira = LocalDateTime.now().plusHours(Tokens.HORAS_DE_VALIDADE);

        String sql = "INSERT INTO token_verificacao (cliente_codCliente, tokenHash, expiraEm) "
                   + "VALUES (?, ?, ?)";
        save(sql, codCliente, Tokens.hashDe(token), Timestamp.valueOf(expira));

        return getLastId() > 0 ? token : null;
    }

    /** Fecha os links pendentes do cliente. */
    public void invalidarPendentes(int codCliente) {
        String sql = "UPDATE token_verificacao SET usadoEm = NOW() "
                   + " WHERE cliente_codCliente = ? AND usadoEm IS NULL";
        save(sql, codCliente);
    }

    /**
     * Procura pelo token em claro que chegou na URL.
     *
     * A busca é pelo hash: é o índice único da tabela, e o valor em claro
     * nunca precisou ser guardado.
     */
    public TokenVerificacao buscarPorToken(String tokenEmClaro) {
        if (tokenEmClaro == null || tokenEmClaro.trim().isEmpty()) {
            return null;
        }

        String sql = "SELECT codToken, cliente_codCliente, tokenHash, criadoEm, expiraEm, usadoEm "
                   + "  FROM token_verificacao WHERE tokenHash = ?";

        try (Connection con = fabrica.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setString(1, Tokens.hashDe(tokenEmClaro.trim()));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Marca o token como usado. Um link só vale uma vez. */
    public void marcarUsado(int codToken) {
        save("UPDATE token_verificacao SET usadoEm = NOW() WHERE codToken = ?", codToken);
    }

    /** Quantos links o cliente pediu na última hora — trava de reenvio. */
    public int emitidosNaUltimaHora(int codCliente) {
        String sql = "SELECT COUNT(*) FROM token_verificacao "
                   + " WHERE cliente_codCliente = ? AND criadoEm > (NOW() - INTERVAL 1 HOUR)";

        try (Connection con = fabrica.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setInt(1, codCliente);
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

    private TokenVerificacao mapear(ResultSet rs) throws SQLException {
        TokenVerificacao t = new TokenVerificacao();
        t.setCodToken(rs.getInt("codToken"));
        t.setCodCliente(rs.getInt("cliente_codCliente"));
        t.setTokenHash(rs.getString("tokenHash"));
        t.setCriadoEm(paraData(rs.getTimestamp("criadoEm")));
        t.setExpiraEm(paraData(rs.getTimestamp("expiraEm")));
        t.setUsadoEm(paraData(rs.getTimestamp("usadoEm")));
        return t;
    }

    private LocalDateTime paraData(Timestamp ts) {
        return ts == null ? null : ts.toLocalDateTime();
    }
}
