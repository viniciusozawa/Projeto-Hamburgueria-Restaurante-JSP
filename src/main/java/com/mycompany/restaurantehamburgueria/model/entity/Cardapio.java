package com.mycompany.restaurantehamburgueria.model.entity;

public class Cardapio {

    private Integer codCardapio;
    private String nomeComida;
    private Double valorComida;
    private String descricaoComida;
    private Categoria categoriaCardapio;

    public Cardapio() {}

    public Integer getCodCardapio() { return codCardapio; }
    public void setCodCardapio(Integer codCardapio) { this.codCardapio = codCardapio; }

    public String getNomeComida() { return nomeComida; }
    public void setNomeComida(String nomeComida) { this.nomeComida = nomeComida; }

    public Double getValorComida() { return valorComida; }
    public void setValorComida(Double valorComida) { this.valorComida = valorComida; }

    public String getDescricaoComida() { return descricaoComida; }
    public void setDescricaoComida(String descricaoComida) { this.descricaoComida = descricaoComida; }

    public Categoria getCategoriaCardapio() { return categoriaCardapio; }
    public void setCategoriaCardapio(Categoria categoriaCardapio) { this.categoriaCardapio = categoriaCardapio; }

    @Override
    public String toString() {
        return "Cardapio{codCardapio=" + codCardapio + ", nomeComida=" + nomeComida + "}";
    }
}
