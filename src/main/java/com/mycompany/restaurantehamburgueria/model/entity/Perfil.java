package com.mycompany.restaurantehamburgueria.model.entity;

/**
 * O que cada pessoa pode fazer no sistema.
 *
 * Vem da coluna `cargo.perfil`, e não do nome do cargo: renomear "Garçom"
 * para "Atendente de salão" não pode mudar permissão nenhuma.
 *
 * CLIENTE não existe na coluna do banco — é o perfil de quem entra pela
 * tabela `cliente`, que não tem cargo.
 */
public enum Perfil {

    /** Dono e gerente: tudo, inclusive fornecedores e dados de cliente. */
    ADMIN,

    /** Salão: mesas, chamados e lançamento de pedido. */
    GARCOM,

    /** Preparo: acompanha os pedidos, não mexe em cadastro. */
    COZINHA,

    /** Cargo sem acesso ao sistema. É o padrão de um cargo novo. */
    OUTRO,

    /** Quem entra pela tabela cliente. */
    CLIENTE;

    /** Converte o texto do banco. Valor desconhecido ou nulo cai em OUTRO. */
    public static Perfil de(String texto) {
        if (texto == null) {
            return OUTRO;
        }
        try {
            return valueOf(texto.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return OUTRO;
        }
    }

    /** Abre o painel de gerenciamento. */
    public boolean temPainel() {
        return this == ADMIN || this == GARCOM || this == COZINHA;
    }

    /** Mexe em fornecedor, funcionário, cargo, turno e dados de cliente. */
    public boolean podeAdministrar() {
        return this == ADMIN;
    }

    /** Atende mesa: chamados e lançamento de pedido. */
    public boolean podeAtenderSalao() {
        return this == ADMIN || this == GARCOM;
    }

    /** Vê a fila de pedidos e o cardápio do ponto de vista do preparo. */
    public boolean podeVerPreparo() {
        return this == ADMIN || this == GARCOM || this == COZINHA;
    }

    /** Rótulo para mostrar na tela. */
    public String getRotulo() {
        switch (this) {
            case ADMIN:   return "Gerência";
            case GARCOM:  return "Salão";
            case COZINHA: return "Cozinha";
            case CLIENTE: return "Cliente";
            default:      return "Sem acesso";
        }
    }
}
