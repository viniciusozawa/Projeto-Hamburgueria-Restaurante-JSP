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
            obj.setQtdItens(rs.getInt("qtdItens"));
            obj.setTotal(rs.getDouble("totalPedido"));
            System.out.println("Mapeando: " + obj + " | itens=" + obj.getQtdItens() + " | total=" + obj.getTotal());
            return obj;
        }
    }

    /** Traz o pedido junto com a quantidade de itens e o valor total da comanda. */
    private static final String SQL_BASE =
        "SELECT p.codpedido, p.cliente_codCliente, p.mesa_codMesa, p.funcionario_codFuncionario, p.datahoraPedido, "
      + "       COALESCE(SUM(pc.quantidade), 0) AS qtdItens, "
      + "       COALESCE(SUM(pc.quantidade * c.valorComida), 0) AS totalPedido "
      + "  FROM pedido p "
      + "  LEFT JOIN pedido_por_cardapio pc ON pc.pedido_idpedido = p.codpedido "
      + "  LEFT JOIN cardapio c            ON c.codCardapio = pc.cardapio_codCardapio ";

    private static final String SQL_GROUP =
        " GROUP BY p.codpedido, p.cliente_codCliente, p.mesa_codMesa, p.funcionario_codFuncionario, p.datahoraPedido ";

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
        return buscarTodos(SQL_BASE + SQL_GROUP + " ORDER BY p.codpedido", new PedidoRowMapper());
    }

    public Pedido buscarPorId(int id) {
        return buscarPorId(SQL_BASE + " WHERE p.codpedido=? " + SQL_GROUP, new PedidoRowMapper(), id);
    }
}
