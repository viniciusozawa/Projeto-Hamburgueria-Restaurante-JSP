package com.mycompany.restaurantehamburgueria.model.entity;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Ingrediente {
    private int codIngrediente;
    private String nomeIngredientes;
    private BigDecimal quantiIngredientes;
    private LocalDate dataProducao;
    private LocalDate dataVencimento;
    private BigDecimal valorIngrediente;
    private String descricaoIngrediente;
    private int fornecedores_codFornecedor;

    // Campo extra para exibição (join)
    private String nomeFornecedor;

    public int getCodIngrediente() { return codIngrediente; }
    public void setCodIngrediente(int codIngrediente) { this.codIngrediente = codIngrediente; }

    public String getNomeIngredientes() { return nomeIngredientes; }
    public void setNomeIngredientes(String nomeIngredientes) { this.nomeIngredientes = nomeIngredientes; }

    public BigDecimal getQuantiIngredientes() { return quantiIngredientes; }
    public void setQuantiIngredientes(BigDecimal quantiIngredientes) { this.quantiIngredientes = quantiIngredientes; }

    public LocalDate getDataProducao() { return dataProducao; }
    public void setDataProducao(LocalDate dataProducao) { this.dataProducao = dataProducao; }

    public LocalDate getDataVencimento() { return dataVencimento; }
    public void setDataVencimento(LocalDate dataVencimento) { this.dataVencimento = dataVencimento; }

    public BigDecimal getValorIngrediente() { return valorIngrediente; }
    public void setValorIngrediente(BigDecimal valorIngrediente) { this.valorIngrediente = valorIngrediente; }

    public String getDescricaoIngrediente() { return descricaoIngrediente; }
    public void setDescricaoIngrediente(String descricaoIngrediente) { this.descricaoIngrediente = descricaoIngrediente; }

    public int getFornecedores_codFornecedor() { return fornecedores_codFornecedor; }
    public void setFornecedores_codFornecedor(int fornecedores_codFornecedor) { this.fornecedores_codFornecedor = fornecedores_codFornecedor; }

    public String getNomeFornecedor() { return nomeFornecedor; }
    public void setNomeFornecedor(String nomeFornecedor) { this.nomeFornecedor = nomeFornecedor; }
}
