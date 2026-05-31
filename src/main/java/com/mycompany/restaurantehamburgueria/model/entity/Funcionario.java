package com.mycompany.restaurantehamburgueria.model.entity;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Funcionario {
    private int codFuncionario;
    private String nomeFuncionario;
    private LocalDate dataNascimento;
    private String senhaFuncionario;
    private String cpfFuncionario;
    private BigDecimal salarioFuncionario;
    private int turnos_codTurnos;
    private int cargo_codCargo;
    private int disponivel;

    // Campos extras para exibição (join)
    private String nomeCargo;
    private String horarioTurno;

    public int getCodFuncionario() { return codFuncionario; }
    public void setCodFuncionario(int codFuncionario) { this.codFuncionario = codFuncionario; }

    public String getNomeFuncionario() { return nomeFuncionario; }
    public void setNomeFuncionario(String nomeFuncionario) { this.nomeFuncionario = nomeFuncionario; }

    public LocalDate getDataNascimento() { return dataNascimento; }
    public void setDataNascimento(LocalDate dataNascimento) { this.dataNascimento = dataNascimento; }

    public String getSenhaFuncionario() { return senhaFuncionario; }
    public void setSenhaFuncionario(String senhaFuncionario) { this.senhaFuncionario = senhaFuncionario; }

    public String getCpfFuncionario() { return cpfFuncionario; }
    public void setCpfFuncionario(String cpfFuncionario) { this.cpfFuncionario = cpfFuncionario; }

    public BigDecimal getSalarioFuncionario() { return salarioFuncionario; }
    public void setSalarioFuncionario(BigDecimal salarioFuncionario) { this.salarioFuncionario = salarioFuncionario; }

    public int getTurnos_codTurnos() { return turnos_codTurnos; }
    public void setTurnos_codTurnos(int turnos_codTurnos) { this.turnos_codTurnos = turnos_codTurnos; }

    public int getCargo_codCargo() { return cargo_codCargo; }
    public void setCargo_codCargo(int cargo_codCargo) { this.cargo_codCargo = cargo_codCargo; }

    public int getDisponivel() { return disponivel; }
    public void setDisponivel(int disponivel) { this.disponivel = disponivel; }

    public String getNomeCargo() { return nomeCargo; }
    public void setNomeCargo(String nomeCargo) { this.nomeCargo = nomeCargo; }

    public String getHorarioTurno() { return horarioTurno; }
    public void setHorarioTurno(String horarioTurno) { this.horarioTurno = horarioTurno; }
}
