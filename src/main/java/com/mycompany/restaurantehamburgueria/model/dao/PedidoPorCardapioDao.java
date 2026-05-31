package com.mycompany.restaurantehamburgueria.model.dao;

public class PedidoPorCardapioDao extends GenericoDAO<Object> {

    /**
     * Insere um item no pedido.
     * O trigger tri_atualizarIngredientesInsert dispara automaticamente
     * e decrementa os ingredientes do estoque.
     */
    public void salvar(int pedidoId, int cardapioId, int quantidade) {
        String sql = "INSERT INTO pedido_por_cardapio(pedido_idpedido, cardapio_codCardapio, quantidade) VALUES(?,?,?)";
        save(sql, pedidoId, cardapioId, quantidade);
    }
}
