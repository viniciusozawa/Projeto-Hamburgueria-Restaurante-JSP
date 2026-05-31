package com.mycompany.restaurantehamburgueria.model.entity;

import java.time.LocalDateTime;

public class Feedback {
    private int codFeedback;
    private int nota;
    private String descricao;
    private LocalDateTime dataFeedback;
    private int cliente_codCliente;

    // Campo extra para exibição (join)
    private String nomeCliente;

    public int getCodFeedback() { return codFeedback; }
    public void setCodFeedback(int codFeedback) { this.codFeedback = codFeedback; }

    public int getNota() { return nota; }
    public void setNota(int nota) { this.nota = nota; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public LocalDateTime getDataFeedback() { return dataFeedback; }
    public void setDataFeedback(LocalDateTime dataFeedback) { this.dataFeedback = dataFeedback; }

    public int getCliente_codCliente() { return cliente_codCliente; }
    public void setCliente_codCliente(int cliente_codCliente) { this.cliente_codCliente = cliente_codCliente; }

    public String getNomeCliente() { return nomeCliente; }
    public void setNomeCliente(String nomeCliente) { this.nomeCliente = nomeCliente; }
}
