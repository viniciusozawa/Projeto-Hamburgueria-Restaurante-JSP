package com.mycompany.restaurantehamburgueria.model.entity;

public class Categoria {

    private Integer codCategoria;
    private String nomeCategoria;

    public Categoria() {}

    public Integer getCodCategoria() { return codCategoria; }
    public void setCodCategoria(Integer codCategoria) { this.codCategoria = codCategoria; }

    public String getNomeCategoria() { return nomeCategoria; }
    public void setNomeCategoria(String nomeCategoria) { this.nomeCategoria = nomeCategoria; }

    @Override
    public String toString() {
        return "Categoria{codCategoria=" + codCategoria + ", nomeCategoria=" + nomeCategoria + "}";
    }
}
