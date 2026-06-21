package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Pedido;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class PedidoDao extends GenericoDAO<Pedido> {

    private static class PedidoRowMapper implements RowMapper<Pedido> {
        private final ClienteDao clienteDao = new ClienteDao();
        private final MesaDao mesaDao = new MesaDao();
        private final FuncionarioDao funcionarioDao = new FuncionarioDao();

        @Override
        public Pedido mapRow(ResultSet rs) throws SQLException {
            Pedido obj = new Pedido();
            obj.setCodpedido(rs.getInt("codpedido"));
            Timestamp ts = rs.getTimestamp("datahoraPedido");
            if (ts != null) {
                obj.setDatahoraPedido(ts.toLocalDateTime());
            }
            obj.setClientePedido(clienteDao.buscarPorId(rs.getInt("cliente_codCliente")));
            obj.setMesaPedido(mesaDao.buscarPorId(rs.getInt("mesa_codMesa")));
            obj.setFuncionarioPedido(funcionarioDao.buscarPorId(rs.getInt("funcionario_codFuncionario")));
            System.out.println("Mapeando: " + obj);
            return obj;
        }
    }

    public void salvar(Pedido obj) {
        String sql = "INSERT INTO pedido(cliente_codCliente, mesa_codMesa, funcionario_codFuncionario) VALUES(?,?,?)";
        save(sql,
            obj.getClientePedido().getCodCliente(),
            obj.getMesaPedido().getCodMesa(),
            obj.getFuncionarioPedido().getCodFuncionario()
        );
    }

    public void alterar(Pedido obj) {
        String sql = "UPDATE pedido SET cliente_codCliente=?, mesa_codMesa=?, funcionario_codFuncionario=? WHERE codpedido=?";
        save(sql,
            obj.getClientePedido().getCodCliente(),
            obj.getMesaPedido().getCodMesa(),
            obj.getFuncionarioPedido().getCodFuncionario(),
            obj.getCodpedido()
        );
    }

    public void excluir(Pedido obj) {
        String sql = "DELETE FROM pedido WHERE codpedido=?";
        save(sql, obj.getCodpedido());
    }

    public List<Pedido> buscarTodos() {
        return buscarTodos("SELECT * FROM pedido", new PedidoRowMapper());
    }

    public Pedido buscarPorId(int id) {
        return buscarPorId("SELECT * FROM pedido WHERE codpedido=?", new PedidoRowMapper(), id);
    }
}
