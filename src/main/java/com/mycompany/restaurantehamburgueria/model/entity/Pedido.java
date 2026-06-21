package com.mycompany.restaurantehamburgueria.model.entity;

import java.time.LocalDateTime;

public class Pedido {

    private Integer codpedido;
    private Cliente clientePedido;
    private Mesa mesaPedido;
    private Funcionario funcionarioPedido;
    private LocalDateTime datahoraPedido;

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

    @Override
    public String toString() {
        return "Pedido{codpedido=" + codpedido + ", datahoraPedido=" + datahoraPedido + "}";
    }
}
