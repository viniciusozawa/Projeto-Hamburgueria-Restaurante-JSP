package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Feedback;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class FeedbackDao extends GenericoDAO<Feedback> {

    private static class FeedbackRowMapper implements RowMapper<Feedback> {
        @Override
        public Feedback mapRow(ResultSet rs) throws SQLException {
            Feedback obj = new Feedback();
            obj.setCodFeedback(rs.getInt("codFeedback"));
            obj.setNota(rs.getInt("nota"));
            obj.setDescricao(rs.getString("descricao"));
            Timestamp ts = rs.getTimestamp("dataFeedback");
            if (ts != null) obj.setDataFeedback(ts.toLocalDateTime());
            obj.setCliente_codCliente(rs.getInt("cliente_codCliente"));
            try { obj.setNomeCliente(rs.getString("nomeCliente")); } catch (SQLException ignored) {}
            return obj;
        }
    }

    public void salvar(Feedback obj) {
        String sql = "INSERT INTO feedback(nota, descricao, cliente_codCliente) VALUES(?,?,?)";
        save(sql, obj.getNota(), obj.getDescricao(), obj.getCliente_codCliente());
    }

    public void alterar(Feedback obj) {
        String sql = "UPDATE feedback SET nota=?, descricao=? WHERE codFeedback=?";
        save(sql, obj.getNota(), obj.getDescricao(), obj.getCodFeedback());
    }

    public void excluir(Feedback obj) {
        String sql = "DELETE FROM feedback WHERE codFeedback=?";
        save(sql, obj.getCodFeedback());
    }

    public List<Feedback> buscarTodos() {
        String sql = "SELECT f.*, c.nomeCliente FROM feedback f LEFT JOIN cliente c ON c.codCliente = f.cliente_codCliente ORDER BY f.dataFeedback DESC";
        return buscarTodos(sql, new FeedbackRowMapper());
    }

    public Feedback buscarPorId(int id) {
        String sql = "SELECT f.*, c.nomeCliente FROM feedback f LEFT JOIN cliente c ON c.codCliente = f.cliente_codCliente WHERE f.codFeedback=?";
        return buscarPorId(sql, new FeedbackRowMapper(), id);
    }
}
