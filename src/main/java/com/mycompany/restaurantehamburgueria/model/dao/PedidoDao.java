package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Pedido;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class PedidoDao extends GenericoDAO<Pedido> {

    private static class PedidoRowMapper implements RowMapper<Pedido> {
        @Override
        public Pedido mapRow(ResultSet rs) throws SQLException {
            Pedido obj = new Pedido();
            obj.setCodpedido(rs.getInt("codpedido"));
            obj.setCliente_codCliente(rs.getInt("cliente_codCliente"));
            obj.setMesa_codMesa(rs.getInt("mesa_codMesa"));
            obj.setFuncionario_codFuncionario(rs.getInt("funcionario_codFuncionario"));
            Timestamp ts = rs.getTimestamp("datahoraPedido");
            if (ts != null) obj.setDatahoraPedido(ts.toLocalDateTime());
            try { obj.setNomeCliente(rs.getString("nomeCliente")); } catch (SQLException ignored) {}
            try { obj.setNumeroMesa(rs.getInt("numeroMesa")); } catch (SQLException ignored) {}
            try { obj.setNomeFuncionario(rs.getString("nomeFuncionario")); } catch (SQLException ignored) {}
            return obj;
        }
    }

    public void salvar(Pedido obj) {
        String sql = "INSERT INTO pedido(cliente_codCliente, mesa_codMesa, funcionario_codFuncionario) VALUES(?,?,?)";
        save(sql, obj.getCliente_codCliente(), obj.getMesa_codMesa(), obj.getFuncionario_codFuncionario());
    }

    public void excluir(Pedido obj) {
        String sql = "DELETE FROM pedido WHERE codpedido=?";
        save(sql, obj.getCodpedido());
    }

    public List<Pedido> buscarTodos() {
        String sql = "SELECT p.*, cl.nomeCliente, m.numeroMesa, f.nomeFuncionario " +
                     "FROM pedido p " +
                     "LEFT JOIN cliente cl ON cl.codCliente = p.cliente_codCliente " +
                     "LEFT JOIN mesa m ON m.codMesa = p.mesa_codMesa " +
                     "LEFT JOIN funcionario f ON f.codFuncionario = p.funcionario_codFuncionario " +
                     "ORDER BY p.datahoraPedido DESC";
        return buscarTodos(sql, new PedidoRowMapper());
    }

    public Pedido buscarPorId(int id) {
        String sql = "SELECT p.*, cl.nomeCliente, m.numeroMesa, f.nomeFuncionario " +
                     "FROM pedido p " +
                     "LEFT JOIN cliente cl ON cl.codCliente = p.cliente_codCliente " +
                     "LEFT JOIN mesa m ON m.codMesa = p.mesa_codMesa " +
                     "LEFT JOIN funcionario f ON f.codFuncionario = p.funcionario_codFuncionario " +
                     "WHERE p.codpedido=?";
        return buscarPorId(sql, new PedidoRowMapper(), id);
    }
}
