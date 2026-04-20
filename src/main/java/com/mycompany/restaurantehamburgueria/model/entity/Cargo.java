package com.mycompany.restaurantehamburgueria.model.entity;

public class Cargo {

    private Integer codCargo;
    private String nomeCargo;

    public Cargo() {}

    public Integer getCodCargo() { return codCargo; }
    public void setCodCargo(Integer codCargo) { this.codCargo = codCargo; }

    public String getNomeCargo() { return nomeCargo; }
    public void setNomeCargo(String nomeCargo) { this.nomeCargo = nomeCargo; }

    @Override
    public String toString() {
        return "Cargo{codCargo=" + codCargo + ", nomeCargo=" + nomeCargo + "}";
    }
}
