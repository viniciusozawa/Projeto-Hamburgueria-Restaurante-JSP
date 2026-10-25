package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Pedido;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
            obj.setValorRecebido(rs.getDouble("valorRecebido"));
            obj.setResumoItens(juntarRepetidos(rs.getString("resumoItens")));
            System.out.println("Mapeando: " + obj + " | itens=" + obj.getQtdItens() + " | total=" + obj.getTotal());
            return obj;
        }
    }

    /**
     * "2x BIGTITES, 2x BIGTITES, 1x Sorvete" vira "4x BIGTITES, 1x Sorvete".
     * O mesmo prato lançado duas vezes no pedido vem em duas linhas do banco.
     * Usa ", " como separador; o GROUP_CONCAT abaixo monta nesse formato.
     */
    static String juntarRepetidos(String resumo) {
        if (resumo == null || resumo.isEmpty()) {
            return resumo;
        }
        Map<String, Integer> porPrato = new LinkedHashMap<>();
        for (String parte : resumo.split(", ")) {
            int x = parte.indexOf("x ");
            try {
                int qtd = Integer.parseInt(parte.substring(0, x));
                porPrato.merge(parte.substring(x + 2), qtd, Integer::sum);
            } catch (RuntimeException e) {
                porPrato.merge(parte, 0, Integer::sum); // fora do formato: mostra como veio
            }
        }
        StringBuilder sb = new StringBuilder();
        for (Map.Entry<String, Integer> e : porPrato.entrySet()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(e.getValue() > 0 ? e.getValue() + "x " + e.getKey() : e.getKey());
        }
        return sb.toString();
    }

    /**
     * Traz o pedido junto com a quantidade de itens, o valor total da comanda,
     * o que já foi pago por ele (soma dos pagamentos) e o que foi comprado,
     * em texto ("2x X-Bacon, 1x Coca"). Pago >= total = pedido finalizado.
     */
    private static final String SQL_BASE =
        "SELECT p.codpedido, p.cliente_codCliente, p.mesa_codMesa, p.funcionario_codFuncionario, p.datahoraPedido, "
      + "       COALESCE(SUM(pc.quantidade), 0) AS qtdItens, "
      + "       COALESCE(SUM(pc.quantidade * c.valorComida), 0) AS totalPedido, "
      + "       (SELECT COALESCE(SUM(pg.valorPago), 0) FROM pagamento pg "
      + "         WHERE pg.pedido_codpedido = p.codpedido) AS valorRecebido, "
      + "       GROUP_CONCAT(CONCAT(pc.quantidade, 'x ', c.nomeComida) "
      + "                    ORDER BY c.nomeComida SEPARATOR ', ') AS resumoItens "
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
        remover(sql, obj.getCodpedido());
    }

    public List<Pedido> buscarTodos() {
        return buscarTodos(SQL_BASE + SQL_GROUP + " ORDER BY p.codpedido", new PedidoRowMapper());
    }

    /** Todos, o mais novo primeiro: a tela de pedidos separa abertos e finalizados. */
    public List<Pedido> buscarRecentesPrimeiro() {
        return buscarTodos(SQL_BASE + SQL_GROUP + " ORDER BY p.datahoraPedido DESC, p.codpedido DESC",
                new PedidoRowMapper());
    }

    /** Pedidos abertos hoje, o mais novo primeiro: o trilho de comandas do painel. */
    public List<Pedido> buscarDoDia() {
        return buscarTodos(SQL_BASE + " WHERE DATE(p.datahoraPedido) = CURDATE() " + SQL_GROUP
                + " ORDER BY p.datahoraPedido DESC, p.codpedido DESC", new PedidoRowMapper());
    }

    /** Pedidos de um cliente, do mais recente para o mais antigo ("Minha conta"). */
    public List<Pedido> buscarPorCliente(int codCliente) {
        return buscarTodos(SQL_BASE + " WHERE p.cliente_codCliente=? " + SQL_GROUP
                + " ORDER BY p.datahoraPedido DESC, p.codpedido DESC", new PedidoRowMapper(), codCliente);
    }

    public Pedido buscarPorId(int id) {
        return buscarPorId(SQL_BASE + " WHERE p.codpedido=? " + SQL_GROUP, new PedidoRowMapper(), id);
    }
}
