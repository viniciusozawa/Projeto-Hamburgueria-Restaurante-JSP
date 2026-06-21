package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Pagamento;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class PagamentoDao extends GenericoDAO<Pagamento> {

    private static class PagamentoRowMapper implements RowMapper<Pagamento> {
        private final PedidoDao pedidoDao = new PedidoDao();
        private final ClienteDao clienteDao = new ClienteDao();

        @Override
        public Pagamento mapRow(ResultSet rs) throws SQLException {
            Pagamento obj = new Pagamento();
            obj.setCodPagamento(rs.getInt("codPagamento"));
            obj.setFormaPagamento(rs.getString("formaPagamento"));
            obj.setValorPago(rs.getDouble("valorPago"));
            if (rs.getDate("dataPagamento") != null) {
                obj.setDataPagamento(rs.getDate("dataPagamento").toLocalDate());
            }
            obj.setStatusPagamento(rs.getString("statusPagamento"));
            obj.setPedidoPagamento(pedidoDao.buscarPorId(rs.getInt("pedido_codpedido")));
            obj.setClientePagamento(clienteDao.buscarPorId(rs.getInt("cliente_codCliente")));
            System.out.println("Mapeando: " + obj);
            return obj;
        }
    }

    public void salvar(Pagamento obj) {
        String sql = "INSERT INTO pagamento(formaPagamento, valorPago, dataPagamento, statusPagamento, pedido_codpedido, cliente_codCliente) VALUES(?,?,?,?,?,?)";
        save(sql,
            obj.getFormaPagamento(),
            obj.getValorPago(),
            obj.getDataPagamento(),
            obj.getStatusPagamento(),
            obj.getPedidoPagamento().getCodpedido(),
            obj.getClientePagamento().getCodCliente()
        );
    }

    public void alterar(Pagamento obj) {
        String sql = "UPDATE pagamento SET formaPagamento=?, valorPago=?, dataPagamento=?, statusPagamento=?, pedido_codpedido=?, cliente_codCliente=? WHERE codPagamento=?";
        save(sql,
            obj.getFormaPagamento(),
            obj.getValorPago(),
            obj.getDataPagamento(),
            obj.getStatusPagamento(),
            obj.getPedidoPagamento().getCodpedido(),
            obj.getClientePagamento().getCodCliente(),
            obj.getCodPagamento()
        );
    }

    public void excluir(Pagamento obj) {
        String sql = "DELETE FROM pagamento WHERE codPagamento=?";
        save(sql, obj.getCodPagamento());
    }

    public List<Pagamento> buscarTodos() {
        return buscarTodos("SELECT * FROM pagamento", new PagamentoRowMapper());
    }

    public Pagamento buscarPorId(int id) {
        return buscarPorId("SELECT * FROM pagamento WHERE codPagamento=?", new PagamentoRowMapper(), id);
    }
}
