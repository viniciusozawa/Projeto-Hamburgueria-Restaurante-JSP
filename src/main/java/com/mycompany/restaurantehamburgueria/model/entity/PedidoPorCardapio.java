package com.mycompany.restaurantehamburgueria.model.entity;

public class PedidoPorCardapio {

    private Integer codPedidoPorCardapio;
    private Pedido pedidoItem;
    private Cardapio cardapioItem;
    private Integer quantidade;

    public PedidoPorCardapio() {}

    public Integer getCodPedidoPorCardapio() { return codPedidoPorCardapio; }
    public void setCodPedidoPorCardapio(Integer codPedidoPorCardapio) { this.codPedidoPorCardapio = codPedidoPorCardapio; }

    public Pedido getPedidoItem() { return pedidoItem; }
    public void setPedidoItem(Pedido pedidoItem) { this.pedidoItem = pedidoItem; }

    public Cardapio getCardapioItem() { return cardapioItem; }
    public void setCardapioItem(Cardapio cardapioItem) { this.cardapioItem = cardapioItem; }

    public Integer getQuantidade() { return quantidade; }
    public void setQuantidade(Integer quantidade) { this.quantidade = quantidade; }

    public Double getSubtotal() {
        if (cardapioItem == null || cardapioItem.getValorComida() == null || quantidade == null) {
            return 0.0;
        }
        return cardapioItem.getValorComida() * quantidade;
    }

    @Override
    public String toString() {
        return "PedidoPorCardapio{codPedidoPorCardapio=" + codPedidoPorCardapio
                + ", quantidade=" + quantidade + "}";
    }
}
