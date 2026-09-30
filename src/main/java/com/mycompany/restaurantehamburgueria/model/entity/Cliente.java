package com.mycompany.restaurantehamburgueria.model.entity;

import java.time.LocalDateTime;

public class Cliente {

    private Integer codCliente;
    private String nomeCliente;
    private String email;
    private String cpfCliente;
    private String senhaCliente;
    private String telefone;
    private LocalDateTime dataCadastro;

    /** Clicou no link que chegou por email. */
    private boolean emailVerificado;

    /** Já informou telefone e CPF na segunda tela do cadastro. */
    private boolean cadastroCompleto;

    public Cliente() {}

    public Integer getCodCliente() { return codCliente; }
    public void setCodCliente(Integer codCliente) { this.codCliente = codCliente; }

    public String getNomeCliente() { return nomeCliente; }
    public void setNomeCliente(String nomeCliente) { this.nomeCliente = nomeCliente; }

    /** É por aqui que o cliente entra no sistema. Único na tabela. */
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getCpfCliente() { return cpfCliente; }
    public void setCpfCliente(String cpfCliente) { this.cpfCliente = cpfCliente; }

    public String getSenhaCliente() { return senhaCliente; }
    public void setSenhaCliente(String senhaCliente) { this.senhaCliente = senhaCliente; }

    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }

    public LocalDateTime getDataCadastro() { return dataCadastro; }
    public void setDataCadastro(LocalDateTime dataCadastro) { this.dataCadastro = dataCadastro; }

    public boolean isEmailVerificado() { return emailVerificado; }
    public void setEmailVerificado(boolean emailVerificado) { this.emailVerificado = emailVerificado; }

    public boolean isCadastroCompleto() { return cadastroCompleto; }
    public void setCadastroCompleto(boolean cadastroCompleto) { this.cadastroCompleto = cadastroCompleto; }

    @Override
    public String toString() {
        return "Cliente{codCliente=" + codCliente + ", nomeCliente=" + nomeCliente + "}";
    }
}
