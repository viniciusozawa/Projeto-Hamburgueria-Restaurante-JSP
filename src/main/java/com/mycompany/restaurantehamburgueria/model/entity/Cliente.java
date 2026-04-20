package com.mycompany.restaurantehamburgueria.model.entity;

import java.time.LocalDateTime;

public class Cliente {

    private Integer codCliente;
    private String nomeCliente;
    private String cpfCliente;
    private String senhaCliente;
    private String telefone;
    private LocalDateTime dataCadastro;

    public Cliente() {}

    public Integer getCodCliente() { return codCliente; }
    public void setCodCliente(Integer codCliente) { this.codCliente = codCliente; }

    public String getNomeCliente() { return nomeCliente; }
    public void setNomeCliente(String nomeCliente) { this.nomeCliente = nomeCliente; }

    public String getCpfCliente() { return cpfCliente; }
    public void setCpfCliente(String cpfCliente) { this.cpfCliente = cpfCliente; }

    public String getSenhaCliente() { return senhaCliente; }
    public void setSenhaCliente(String senhaCliente) { this.senhaCliente = senhaCliente; }

    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }

    public LocalDateTime getDataCadastro() { return dataCadastro; }
    public void setDataCadastro(LocalDateTime dataCadastro) { this.dataCadastro = dataCadastro; }

    @Override
    public String toString() {
        return "Cliente{codCliente=" + codCliente + ", nomeCliente=" + nomeCliente + "}";
    }
}
