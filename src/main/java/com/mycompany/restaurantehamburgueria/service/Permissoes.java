package com.mycompany.restaurantehamburgueria.service;

import com.mycompany.restaurantehamburgueria.model.entity.Perfil;
import java.util.Arrays;
import java.util.Collections;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * O que cada perfil pode fazer, controlador por controlador e AÇÃO por ação.
 *
 * Liberar só o controlador não basta: o garçom precisa listar o cardápio, mas
 * não pode trocar o preço nem apagar um prato.
 *
 * Esta tabela é a única fonte da regra. O AuthFilter a usa para barrar a
 * requisição, e as JSPs a usam (via Usuario.pode) para esconder o botão que
 * daria 403 — mudar uma permissão aqui muda os dois juntos.
 *
 * ADMIN não aparece porque abre tudo. O que não está na tabela é negado: um
 * controlador ou uma ação nova nasce fechada.
 */
public final class Permissoes {

    /**
     * Ação que os controladores executam quando a URL não traz "opcao".
     * Quase todos caem em listar; o PerfilControlador mostra a "Minha conta".
     */
    public static final String ACAO_PADRAO = "listar";

    private static final Map<Perfil, Map<String, Set<String>>> ACOES = new EnumMap<>(Perfil.class);

    static {
        Map<String, Set<String>> salao = new HashMap<>();
        salao.put("PedidoController",    acoes("listar", "cadastrar", "abrirItens", "adicionarItem", "removerItem"));
        salao.put("PagamentoController", acoes("listar", "cadastrar"));
        salao.put("MesaController",      acoes("listar"));
        salao.put("CardapioController",  acoes("listar"));
        ACOES.put(Perfil.GARCOM, salao);

        Map<String, Set<String>> cozinha = new HashMap<>();
        cozinha.put("PedidoController",      acoes("listar", "abrirItens"));
        cozinha.put("CardapioController",    acoes("listar"));
        // estoque: a cozinha atualiza a quantidade do que acabou
        cozinha.put("IngredienteController", acoes("listar", "enviarAlterar", "confirmarAlterar"));
        ACOES.put(Perfil.COZINHA, cozinha);

        // O PerfilControlador só enxerga o cliente da sessão: ver os próprios
        // pedidos e alterar o próprio cadastro, nunca os de outra pessoa.
        Map<String, Set<String>> cliente = new HashMap<>();
        cliente.put("PerfilControlador", acoes("listar", "atualizar"));
        ACOES.put(Perfil.CLIENTE, cliente);
    }

    private Permissoes() {
    }

    private static Set<String> acoes(String... nomes) {
        return Collections.unmodifiableSet(new HashSet<>(Arrays.asList(nomes)));
    }

    /**
     * @param controlador nome simples do servlet, ex.: "MesaController"
     * @param opcao       valor do parâmetro opcao; vazio ou nulo vale a ação padrão
     */
    public static boolean permite(Perfil perfil, String controlador, String opcao) {
        if (perfil == null) {
            return false;
        }
        if (perfil == Perfil.ADMIN) {
            return true;
        }

        Map<String, Set<String>> doPerfil = ACOES.get(perfil);
        if (doPerfil == null) {
            return false;
        }
        Set<String> liberadas = doPerfil.get(controlador);
        if (liberadas == null) {
            return false;
        }

        String acao = (opcao == null || opcao.isEmpty()) ? ACAO_PADRAO : opcao;
        return liberadas.contains(acao);
    }
}
