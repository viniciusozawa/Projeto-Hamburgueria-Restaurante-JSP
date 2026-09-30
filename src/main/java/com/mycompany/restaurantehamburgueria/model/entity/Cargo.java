package com.mycompany.restaurantehamburgueria.model.entity;

public class Cargo {

    private Integer codCargo;
    private String nomeCargo;

    /** Define o acesso de quem tem este cargo. Novo cargo nasce em OUTRO. */
    private Perfil perfil = Perfil.OUTRO;

    public Cargo() {}

    public Integer getCodCargo() { return codCargo; }
    public void setCodCargo(Integer codCargo) { this.codCargo = codCargo; }

    public String getNomeCargo() { return nomeCargo; }
    public void setNomeCargo(String nomeCargo) { this.nomeCargo = nomeCargo; }

    public Perfil getPerfil() { return perfil; }
    public void setPerfil(Perfil perfil) { this.perfil = perfil == null ? Perfil.OUTRO : perfil; }

    @Override
    public String toString() {
        return "Cargo{codCargo=" + codCargo + ", nomeCargo=" + nomeCargo + ", perfil=" + perfil + "}";
    }
}
