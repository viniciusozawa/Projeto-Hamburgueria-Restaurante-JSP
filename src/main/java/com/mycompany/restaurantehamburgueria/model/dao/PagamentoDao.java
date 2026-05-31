package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Pagamento;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class PagamentoDao extends GenericoDAO<Pagamento> {

    private static class PagamentoRowMapper implements RowMapper<Pagamento> {
        @Override
        public Pagamento mapRow(ResultSet rs) throws SQLException {
            Pagamento obj = new Pagamento();
            obj.setCodPagamento(rs.getInt("codPagamento"));
            obj.setFormaPagamento(rs.getString("formaPagamento"));
            obj.setValorPago(rs.getBigDecimal("valorPago"));
            Date d = rs.getDate("dataPagamento");
            if (d != null) obj.setDataPagamento(d.toLocalDate());
            obj.setStatusPagamento(rs.getString("statusPagamento"));
            obj.setPedido_codpedido(rs.getInt("pedido_codpedido"));
            obj.setCliente_codCliente(rs.getInt("cliente_codCliente"));
            try { obj.setNomeCliente(rs.getString("nomeCliente")); } catch (SQLException ignored) {}
            return obj;
        }
    }

    public void salvar(Pagamento obj) {
        // valorPago and cliente_codCliente are set by the trigger tri_valorTotalPagamento
        String sql = "INSERT INTO pagamento(formaPagamento, valorPago, dataPagamento, statusPagamento, pedido_codpedido, cliente_codCliente) VALUES(?,0,?,?,?,0)";
        save(sql,
            obj.getFormaPagamento(),
            obj.getDataPagamento() != null ? Date.valueOf(obj.getDataPagamento()) : Date.valueOf(java.time.LocalDate.now()),
            obj.getStatusPagamento(),
            obj.getPedido_codpedido()
        );
    }

    public void alterar(Pagamento obj) {
        String sql = "UPDATE pagamento SET formaPagamento=?, statusPagamento=? WHERE codPagamento=?";
        save(sql, obj.getFormaPagamento(), obj.getStatusPagamento(), obj.getCodPagamento());
    }

    public void excluir(Pagamento obj) {
        String sql = "DELETE FROM pagamento WHERE codPagamento=?";
        save(sql, obj.getCodPagamento());
    }

    public List<Pagamento> buscarTodos() {
        String sql = "SELECT pg.*, cl.nomeCliente FROM pagamento pg LEFT JOIN cliente cl ON cl.codCliente = pg.cliente_codCliente ORDER BY pg.dataPagamento DESC";
        return buscarTodos(sql, new PagamentoRowMapper());
    }

    public Pagamento buscarPorId(int id) {
        String sql = "SELECT pg.*, cl.nomeCliente FROM pagamento pg LEFT JOIN cliente cl ON cl.codCliente = pg.cliente_codCliente WHERE pg.codPagamento=?";
        return buscarPorId(sql, new PagamentoRowMapper(), id);
    }
}
