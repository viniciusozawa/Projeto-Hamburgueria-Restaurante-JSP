package com.mycompany.restaurantehamburgueria.model.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * O banco não deixou apagar o registro.
 *
 * Quase sempre é chave estrangeira com ON DELETE NO ACTION: uma categoria que
 * ainda tem pratos, um pedido que já tem pagamento. A mensagem diz em
 * português ONDE o registro ainda aparece, para a pessoa saber o que fazer.
 */
public class ExclusaoRecusada extends RuntimeException {

    /** Código do MySQL para "Cannot delete or update a parent row". */
    private static final int VINCULO = 1451;

    /** O MySQL cita a tabela que segura o registro: fails (`banco`.`tabela`, ... */
    private static final Pattern TABELA = Pattern.compile("fails \\(`[^`]+`\\.`([^`]+)`");

    /** Nome de cada tabela como quem usa o painel conhece. */
    private static final Map<String, String> NOMES = new HashMap<>();

    static {
        NOMES.put("pagamento", "pagamentos");
        NOMES.put("pedido", "pedidos");
        NOMES.put("pedido_por_cardapio", "itens de pedidos");
        NOMES.put("cardapio", "pratos do cardápio");
        NOMES.put("cardapio_por_ingrediente", "receitas do cardápio");
        NOMES.put("ingrediente", "ingredientes");
        NOMES.put("funcionario", "funcionários");
    }

    public ExclusaoRecusada(SQLException causa) {
        super(explicar(causa), causa);
    }

    private static String explicar(SQLException e) {
        if (e.getErrorCode() != VINCULO) {
            return "O banco não aceitou a exclusão. Tente de novo; se continuar, avise a gerência.";
        }
        String onde = "outros cadastros";
        Matcher m = TABELA.matcher(e.getMessage() == null ? "" : e.getMessage());
        if (m.find()) {
            onde = NOMES.getOrDefault(m.group(1), "outros cadastros");
        }
        return "Não dá para excluir: este registro ainda aparece em " + onde
             + ". Remova de lá primeiro.";
    }
}
