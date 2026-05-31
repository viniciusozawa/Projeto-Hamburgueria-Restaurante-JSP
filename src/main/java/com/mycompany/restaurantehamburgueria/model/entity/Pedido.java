package com.mycompany.restaurantehamburgueria.model.entity;

import java.time.LocalDateTime;

public class Pedido {
    private int codpedido;
    private int cliente_codCliente;
    private int mesa_codMesa;
    private int funcionario_codFuncionario;
    private LocalDateTime datahoraPedido;

    // Campos extras para exibição (joins)
    private String nomeCliente;
    private int numeroMesa;
    private String nomeFuncionario;

    public int getCodpedido() { return codpedido; }
    public void setCodpedido(int codpedido) { this.codpedido = codpedido; }

    public int getCliente_codCliente() { return cliente_codCliente; }
    public void setCliente_codCliente(int cliente_codCliente) { this.cliente_codCliente = cliente_codCliente; }

    public int getMesa_codMesa() { return mesa_codMesa; }
    public void setMesa_codMesa(int mesa_codMesa) { this.mesa_codMesa = mesa_codMesa; }

    public int getFuncionario_codFuncionario() { return funcionario_codFuncionario; }
    public void setFuncionario_codFuncionario(int funcionario_codFuncionario) { this.funcionario_codFuncionario = funcionario_codFuncionario; }

    public LocalDateTime getDatahoraPedido() { return datahoraPedido; }
    public void setDatahoraPedido(LocalDateTime datahoraPedido) { this.datahoraPedido = datahoraPedido; }

    public String getNomeCliente() { return nomeCliente; }
    public void setNomeCliente(String nomeCliente) { this.nomeCliente = nomeCliente; }

    public int getNumeroMesa() { return numeroMesa; }
    public void setNumeroMesa(int numeroMesa) { this.numeroMesa = numeroMesa; }

    public String getNomeFuncionario() { return nomeFuncionario; }
    public void setNomeFuncionario(String nomeFuncionario) { this.nomeFuncionario = nomeFuncionario; }
}
