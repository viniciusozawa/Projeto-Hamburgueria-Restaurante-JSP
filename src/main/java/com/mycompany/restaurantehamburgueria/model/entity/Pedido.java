package com.mycompany.restaurantehamburgueria.model.entity;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Pedido {

    private Integer codpedido;
    private Cliente clientePedido;
    private Mesa mesaPedido;
    private Funcionario funcionarioPedido;
    private LocalDateTime datahoraPedido;

    /** Campos calculados pela consulta (nao existem na tabela pedido) */
    private Integer qtdItens = 0;
    private Double total = 0.0;
    private Double valorRecebido = 0.0;
    private String resumoItens;

    public Pedido() {}

    public Integer getCodpedido() { return codpedido; }
    public void setCodpedido(Integer codpedido) { this.codpedido = codpedido; }

    public Cliente getClientePedido() { return clientePedido; }
    public void setClientePedido(Cliente clientePedido) { this.clientePedido = clientePedido; }

    public Mesa getMesaPedido() { return mesaPedido; }
    public void setMesaPedido(Mesa mesaPedido) { this.mesaPedido = mesaPedido; }

    public Funcionario getFuncionarioPedido() { return funcionarioPedido; }
    public void setFuncionarioPedido(Funcionario funcionarioPedido) { this.funcionarioPedido = funcionarioPedido; }

    public LocalDateTime getDatahoraPedido() { return datahoraPedido; }
    public void setDatahoraPedido(LocalDateTime datahoraPedido) { this.datahoraPedido = datahoraPedido; }

    public Integer getQtdItens() { return qtdItens == null ? 0 : qtdItens; }
    public void setQtdItens(Integer qtdItens) { this.qtdItens = qtdItens; }

    public Double getTotal() { return total == null ? 0.0 : total; }
    public void setTotal(Double total) { this.total = total; }

    /** Soma dos pagamentos lançados para este pedido. */
    public Double getValorRecebido() { return valorRecebido == null ? 0.0 : valorRecebido; }
    public void setValorRecebido(Double valorRecebido) { this.valorRecebido = valorRecebido; }

    /** O que foi comprado, em uma linha: "2x X-Bacon, 1x Coca". */
    public String getResumoItens() { return resumoItens == null ? "" : resumoItens; }
    public void setResumoItens(String resumoItens) { this.resumoItens = resumoItens; }

    /**
     * Pedido "baixado": o que foi pago cobre o total. Não usa o campo
     * statusPagamento porque ele é texto livre ("andamento", "pago", vazio...)
     * e não dá para confiar. Pedido sem item nunca está finalizado.
     * Meio centavo de folga por causa do arredondamento do double.
     */
    public boolean isFinalizado() {
        return getTotal() > 0 && getValorRecebido() >= getTotal() - 0.005;
    }

    /** Quanto ainda falta pagar (zero se já foi pago). */
    public double getFalta() {
        return Math.max(0, getTotal() - getValorRecebido());
    }

    public String getDatahoraFormatada() {
        if (datahoraPedido == null) return "";
        return datahoraPedido.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    /** Só a hora, para a comanda do trilho do painel (o dia é sempre hoje). */
    public String getHoraPedido() {
        if (datahoraPedido == null) return "";
        return datahoraPedido.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    @Override
    public String toString() {
        return "Pedido{codpedido=" + codpedido + ", datahoraPedido=" + datahoraPedido + "}";
    }
}
