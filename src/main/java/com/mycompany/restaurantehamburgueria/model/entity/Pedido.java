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

    public String getDatahoraFormatada() {
        if (datahoraPedido == null) return "";
        return datahoraPedido.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    @Override
    public String toString() {
        return "Pedido{codpedido=" + codpedido + ", datahoraPedido=" + datahoraPedido + "}";
    }
}
