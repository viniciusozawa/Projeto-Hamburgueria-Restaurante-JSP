package com.mycompany.restaurantehamburgueria.model.entity;

public class Mesa {

    private Integer codMesa;
    private Integer numeroMesa;
    private String localMesa;

    public Mesa() {}

    public Integer getCodMesa() { return codMesa; }
    public void setCodMesa(Integer codMesa) { this.codMesa = codMesa; }

    public Integer getNumeroMesa() { return numeroMesa; }
    public void setNumeroMesa(Integer numeroMesa) { this.numeroMesa = numeroMesa; }

    public String getLocalMesa() { return localMesa; }
    public void setLocalMesa(String localMesa) { this.localMesa = localMesa; }

    @Override
    public String toString() {
        return "Mesa{codMesa=" + codMesa + ", numeroMesa=" + numeroMesa + ", localMesa=" + localMesa + "}";
    }
}
