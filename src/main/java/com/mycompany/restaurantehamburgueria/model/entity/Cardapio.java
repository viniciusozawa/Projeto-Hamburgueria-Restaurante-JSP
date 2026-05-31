package com.mycompany.restaurantehamburgueria.model.entity;

import java.math.BigDecimal;

public class Cardapio {
    private int codCardapio;
    private String nomeComida;
    private BigDecimal valorComida;
    private String descricaoComida;
    private int categoria_codCategoria;

    // Campo extra para exibição (join)
    private String nomeCategoria;

    public int getCodCardapio() { return codCardapio; }
    public void setCodCardapio(int codCardapio) { this.codCardapio = codCardapio; }

    public String getNomeComida() { return nomeComida; }
    public void setNomeComida(String nomeComida) { this.nomeComida = nomeComida; }

    public BigDecimal getValorComida() { return valorComida; }
    public void setValorComida(BigDecimal valorComida) { this.valorComida = valorComida; }

    public String getDescricaoComida() { return descricaoComida; }
    public void setDescricaoComida(String descricaoComida) { this.descricaoComida = descricaoComida; }

    public int getCategoria_codCategoria() { return categoria_codCategoria; }
    public void setCategoria_codCategoria(int categoria_codCategoria) { this.categoria_codCategoria = categoria_codCategoria; }

    public String getNomeCategoria() { return nomeCategoria; }
    public void setNomeCategoria(String nomeCategoria) { this.nomeCategoria = nomeCategoria; }
}
