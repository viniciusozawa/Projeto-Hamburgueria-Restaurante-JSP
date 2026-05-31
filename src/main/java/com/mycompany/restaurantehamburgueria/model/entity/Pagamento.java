package com.mycompany.restaurantehamburgueria.model.entity;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Pagamento {
    private int codPagamento;
    private String formaPagamento;
    private BigDecimal valorPago;
    private LocalDate dataPagamento;
    private String statusPagamento;
    private int pedido_codpedido;
    private int cliente_codCliente;

    // Campos extras para exibição (joins)
    private String nomeCliente;

    public int getCodPagamento() { return codPagamento; }
    public void setCodPagamento(int codPagamento) { this.codPagamento = codPagamento; }

    public String getFormaPagamento() { return formaPagamento; }
    public void setFormaPagamento(String formaPagamento) { this.formaPagamento = formaPagamento; }

    public BigDecimal getValorPago() { return valorPago; }
    public void setValorPago(BigDecimal valorPago) { this.valorPago = valorPago; }

    public LocalDate getDataPagamento() { return dataPagamento; }
    public void setDataPagamento(LocalDate dataPagamento) { this.dataPagamento = dataPagamento; }

    public String getStatusPagamento() { return statusPagamento; }
    public void setStatusPagamento(String statusPagamento) { this.statusPagamento = statusPagamento; }

    public int getPedido_codpedido() { return pedido_codpedido; }
    public void setPedido_codpedido(int pedido_codpedido) { this.pedido_codpedido = pedido_codpedido; }

    public int getCliente_codCliente() { return cliente_codCliente; }
    public void setCliente_codCliente(int cliente_codCliente) { this.cliente_codCliente = cliente_codCliente; }

    public String getNomeCliente() { return nomeCliente; }
    public void setNomeCliente(String nomeCliente) { this.nomeCliente = nomeCliente; }
}
