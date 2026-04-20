package com.mycompany.restaurantehamburgueria.model.entity;

import java.time.LocalTime;

public class Turnos {

    private Integer codTurnos;
    private LocalTime horarioInicio;
    private LocalTime horarioFinal;

    public Turnos() {}

    public Integer getCodTurnos() { return codTurnos; }
    public void setCodTurnos(Integer codTurnos) { this.codTurnos = codTurnos; }

    public LocalTime getHorarioInicio() { return horarioInicio; }
    public void setHorarioInicio(LocalTime horarioInicio) { this.horarioInicio = horarioInicio; }

    public LocalTime getHorarioFinal() { return horarioFinal; }
    public void setHorarioFinal(LocalTime horarioFinal) { this.horarioFinal = horarioFinal; }

    @Override
    public String toString() {
        return "Turnos{codTurnos=" + codTurnos + ", horarioInicio=" + horarioInicio + ", horarioFinal=" + horarioFinal + "}";
    }
}
