package com.mycompany.restaurantehamburgueria.model.entity;

import java.time.LocalDate;

public class Funcionario {

    private Integer codFuncionario;
    private String nomeFuncionario;
    private LocalDate dataNascimento;
    private String senhaFuncionario;
    private String cpfFuncionario;
    private Double salarioFuncionario;
    private Turnos turnosFuncionario;
    private Cargo cargoFuncionario;

    public Funcionario() {}

    public Integer getCodFuncionario() { return codFuncionario; }
    public void setCodFuncionario(Integer codFuncionario) { this.codFuncionario = codFuncionario; }

    public String getNomeFuncionario() { return nomeFuncionario; }
    public void setNomeFuncionario(String nomeFuncionario) { this.nomeFuncionario = nomeFuncionario; }

    public LocalDate getDataNascimento() { return dataNascimento; }
    public void setDataNascimento(LocalDate dataNascimento) { this.dataNascimento = dataNascimento; }

    public String getSenhaFuncionario() { return senhaFuncionario; }
    public void setSenhaFuncionario(String senhaFuncionario) { this.senhaFuncionario = senhaFuncionario; }

    public String getCpfFuncionario() { return cpfFuncionario; }
    public void setCpfFuncionario(String cpfFuncionario) { this.cpfFuncionario = cpfFuncionario; }

    public Double getSalarioFuncionario() { return salarioFuncionario; }
    public void setSalarioFuncionario(Double salarioFuncionario) { this.salarioFuncionario = salarioFuncionario; }

    public Turnos getTurnosFuncionario() { return turnosFuncionario; }
    public void setTurnosFuncionario(Turnos turnosFuncionario) { this.turnosFuncionario = turnosFuncionario; }

    public Cargo getCargoFuncionario() { return cargoFuncionario; }
    public void setCargoFuncionario(Cargo cargoFuncionario) { this.cargoFuncionario = cargoFuncionario; }

    @Override
    public String toString() {
        return "Funcionario{codFuncionario=" + codFuncionario + ", nomeFuncionario=" + nomeFuncionario + "}";
    }
}
