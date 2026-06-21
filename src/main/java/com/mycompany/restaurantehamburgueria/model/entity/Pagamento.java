package com.mycompany.restaurantehamburgueria.model.entity;

import java.time.LocalDate;

public class Pagamento {

    private Integer codPagamento;
    private String formaPagamento;
    private Double valorPago;
    private LocalDate dataPagamento;
    private String statusPagamento;
    private Pedido pedidoPagamento;
    private Cliente clientePagamento;

    public Pagamento() {}

    public Integer getCodPagamento() { return codPagamento; }
    public void setCodPagamento(Integer codPagamento) { this.codPagamento = codPagamento; }

    public String getFormaPagamento() { return formaPagamento; }
    public void setFormaPagamento(String formaPagamento) { this.formaPagamento = formaPagamento; }

    public Double getValorPago() { return valorPago; }
    public void setValorPago(Double valorPago) { this.valorPago = valorPago; }

    public LocalDate getDataPagamento() { return dataPagamento; }
    public void setDataPagamento(LocalDate dataPagamento) { this.dataPagamento = dataPagamento; }

    public String getStatusPagamento() { return statusPagamento; }
    public void setStatusPagamento(String statusPagamento) { this.statusPagamento = statusPagamento; }

    public Pedido getPedidoPagamento() { return pedidoPagamento; }
    public void setPedidoPagamento(Pedido pedidoPagamento) { this.pedidoPagamento = pedidoPagamento; }

    public Cliente getClientePagamento() { return clientePagamento; }
    public void setClientePagamento(Cliente clientePagamento) { this.clientePagamento = clientePagamento; }

    @Override
    public String toString() {
        return "Pagamento{codPagamento=" + codPagamento + ", formaPagamento=" + formaPagamento + "}";
    }
}
