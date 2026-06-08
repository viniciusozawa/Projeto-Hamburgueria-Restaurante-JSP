package com.mycompany.restaurantehamburgueria.model.entity;

import java.time.LocalDate;

public class Ingrediente {

    private Integer codIngrediente;
    private String nomeIngredientes;
    private Double quantiIngredientes;
    private LocalDate dataProducao;
    private LocalDate dataVencimento;
    private Double valorIngrediente;
    private String descricaoIngrediente;
    private Fornecedor fornecedorIngrediente;

    public Ingrediente() {}

    public Integer getCodIngrediente() { return codIngrediente; }
    public void setCodIngrediente(Integer codIngrediente) { this.codIngrediente = codIngrediente; }

    public String getNomeIngredientes() { return nomeIngredientes; }
    public void setNomeIngredientes(String nomeIngredientes) { this.nomeIngredientes = nomeIngredientes; }

    public Double getQuantiIngredientes() { return quantiIngredientes; }
    public void setQuantiIngredientes(Double quantiIngredientes) { this.quantiIngredientes = quantiIngredientes; }

    public LocalDate getDataProducao() { return dataProducao; }
    public void setDataProducao(LocalDate dataProducao) { this.dataProducao = dataProducao; }

    public LocalDate getDataVencimento() { return dataVencimento; }
    public void setDataVencimento(LocalDate dataVencimento) { this.dataVencimento = dataVencimento; }

    public Double getValorIngrediente() { return valorIngrediente; }
    public void setValorIngrediente(Double valorIngrediente) { this.valorIngrediente = valorIngrediente; }

    public String getDescricaoIngrediente() { return descricaoIngrediente; }
    public void setDescricaoIngrediente(String descricaoIngrediente) { this.descricaoIngrediente = descricaoIngrediente; }

    public Fornecedor getFornecedorIngrediente() { return fornecedorIngrediente; }
    public void setFornecedorIngrediente(Fornecedor fornecedorIngrediente) { this.fornecedorIngrediente = fornecedorIngrediente; }

    @Override
    public String toString() {
        return "Ingrediente{codIngrediente=" + codIngrediente + ", nomeIngredientes=" + nomeIngredientes + "}";
    }
}
