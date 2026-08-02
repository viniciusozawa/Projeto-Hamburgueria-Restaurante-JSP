package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Cardapio;
import com.mycompany.restaurantehamburgueria.model.entity.Pedido;
import com.mycompany.restaurantehamburgueria.model.entity.PedidoPorCardapio;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class PedidoPorCardapioDao extends GenericoDAO<PedidoPorCardapio> {

    private static class PedidoPorCardapioRowMapper implements RowMapper<PedidoPorCardapio> {
        private final CardapioDao cardapioDao = new CardapioDao();

        @Override
        public PedidoPorCardapio mapRow(ResultSet rs) throws SQLException {
            PedidoPorCardapio obj = new PedidoPorCardapio();
            obj.setCodPedidoPorCardapio(rs.getInt("codpedido_por_cardapio"));
            obj.setQuantidade(rs.getInt("quantidade"));

            Pedido pedido = new Pedido();
            pedido.setCodpedido(rs.getInt("pedido_idpedido"));
            obj.setPedidoItem(pedido);

            obj.setCardapioItem(cardapioDao.buscarPorId(rs.getInt("cardapio_codCardapio")));
            System.out.println("Mapeando: " + obj);
            return obj;
        }
    }

    public void salvar(PedidoPorCardapio obj) {
        String sql = "INSERT INTO pedido_por_cardapio(pedido_idpedido, cardapio_codCardapio, quantidade) VALUES(?,?,?)";
        save(sql,
            obj.getPedidoItem().getCodpedido(),
            obj.getCardapioItem().getCodCardapio(),
            obj.getQuantidade()
        );
    }

    public void excluir(PedidoPorCardapio obj) {
        String sql = "DELETE FROM pedido_por_cardapio WHERE codpedido_por_cardapio=?";
        save(sql, obj.getCodPedidoPorCardapio());
    }

    public List<PedidoPorCardapio> buscarPorPedido(int codpedido) {
        return buscarTodos(
            "SELECT * FROM pedido_por_cardapio WHERE pedido_idpedido=?",
            new PedidoPorCardapioRowMapper(),
            codpedido
        );
    }
}
