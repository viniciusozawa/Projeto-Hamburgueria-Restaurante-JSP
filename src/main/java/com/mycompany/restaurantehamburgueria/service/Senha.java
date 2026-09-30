package com.mycompany.restaurantehamburgueria.service;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Único lugar do projeto que sabe como uma senha é guardada.
 *
 * Todo hash bcrypt começa com "$2" e tem exatamente 60 caracteres — é isso
 * que permite distinguir uma senha já convertida de uma ainda em texto puro.
 */
public final class Senha {

    private Senha() {
    }

    /** Converte uma senha digitada no hash que vai para o banco. */
    public static String gerarHash(String senhaDigitada) {
        return BCrypt.hashpw(senhaDigitada, BCrypt.gensalt(12));
    }

    /** Diz se o valor guardado já está em bcrypt. */
    public static boolean ehHash(String guardado) {
        return guardado != null && guardado.length() == 60 && guardado.startsWith("$2");
    }

    /**
     * Valor pronto para gravar.
     *
     * As telas de administração carregam a senha atual num campo escondido e
     * a reenviam ao salvar. Sem esta checagem o hash seria hasheado de novo a
     * cada edição e a conta ficaria inacessível.
     */
    public static String paraGravar(String valorDoFormulario) {
        if (valorDoFormulario == null || valorDoFormulario.isEmpty()) {
            return valorDoFormulario;
        }
        return ehHash(valorDoFormulario) ? valorDoFormulario : gerarHash(valorDoFormulario);
    }

    /** Confere uma senha digitada contra o hash guardado. */
    public static boolean confere(String senhaDigitada, String hashGuardado) {
        if (senhaDigitada == null || !ehHash(hashGuardado)) {
            return false;
        }
        try {
            return BCrypt.checkpw(senhaDigitada, hashGuardado);
        } catch (IllegalArgumentException e) {
            return false; // hash corrompido no banco
        }
    }

    /**
     * Compara com uma senha que ficou em texto puro de antes da migração.
     *
     * TEMPORÁRIO: existe só para as contas que já estavam no banco. Quando a
     * última linha tiver sido convertida (a consulta no fim de
     * migracao_login.sql mostra quantas faltam), apague este método e a
     * chamada dele no LoginControlador.
     */
    public static boolean confereLegado(String senhaDigitada, String guardado) {
        return senhaDigitada != null && senhaDigitada.equals(guardado);
    }
}
