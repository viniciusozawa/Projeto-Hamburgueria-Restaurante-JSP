package com.mycompany.restaurantehamburgueria.relatorio;

import static com.mycompany.restaurantehamburgueria.relatorio.PlanilhaExcel.col;

import com.mycompany.restaurantehamburgueria.relatorio.PlanilhaExcel.Aba;
import com.mycompany.restaurantehamburgueria.relatorio.PlanilhaExcel.Formula;
import com.mycompany.restaurantehamburgueria.relatorio.PlanilhaExcel.Tipo;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Relatório 9 - Melhores clientes (Apache POI).
 *
 * Ranking dos clientes que fizeram pedido no período, por valor gasto.
 * Colunas em FÓRMULA:
 *   Valor médio     = Total gasto / Pedidos
 *   Dias sem voltar = HOJE() - último pedido
 *   Faixa           = Ouro (R$ 200 ou mais), Prata (R$ 100 ou mais), Bronze
 * A faixa é a sugestão de nível num programa de fidelidade; os limites
 * estão em LIMITE_OURO e LIMITE_PRATA.
 */
public class RelatorioMelhoresClientesExcel {

    private static final int LIMITE_OURO = 200;
    private static final int LIMITE_PRATA = 100;

    private final List<Map<String, Object>> clientes;
    private final String periodo;

    public RelatorioMelhoresClientesExcel(List<Map<String, Object>> clientes, String periodo) {
        this.clientes = clientes;
        this.periodo = periodo;
    }

    public byte[] gerar() throws IOException {
        PlanilhaExcel planilha = new PlanilhaExcel(periodo);
        Aba aba = planilha.novaAba("Clientes", "Melhores clientes",
                col("#", Tipo.CODIGO, 5),                      // A
                col("Cliente", Tipo.TEXTO, 24),                // B
                col("Telefone", Tipo.TEXTO, 15),               // C
                col("Pedidos", Tipo.INTEIRO, 9),               // D
                col("Itens", Tipo.INTEIRO, 8),                 // E
                col("Total gasto", Tipo.DINHEIRO, 14),         // F
                col("Valor médio por pedido", Tipo.DINHEIRO, 14), // G
                col("Primeiro pedido", Tipo.DATA, 13),         // H
                col("Último pedido", Tipo.DATA, 13),           // I
                col("Dias sem voltar", Tipo.INTEIRO, 10),      // J
                col("Faixa", Tipo.TEXTO, 10));                 // K

        int posicao = 1;
        for (Map<String, Object> c : clientes) {
            aba.linha(
                    posicao++,
                    c.get("nomeCliente"),
                    PlanilhaExcel.telefone(c.get("telefone")),
                    c.get("pedidos"),
                    c.get("itens"),
                    c.get("gasto"),
                    new Formula("IF(D{r}=0,0,F{r}/D{r})"),
                    c.get("primeiro"),
                    c.get("ultimo"),
                    new Formula("INT(TODAY()-I{r})"),
                    new Formula("IF(F{r}>=" + LIMITE_OURO + ",\"Ouro\",IF(F{r}>=" + LIMITE_PRATA + ",\"Prata\",\"Bronze\"))"));
        }

        if (clientes.isEmpty()) {
            aba.vazio("Nenhum cliente fez pedido no período.");
        } else {
            aba.total("TOTAL (" + clientes.size() + " clientes)", new int[]{3, 4, 5},
                    null, null, null, null, null, new Formula("IF(D{r}=0,0,F{r}/D{r})"));
            aba.nota("Faixa: Ouro a partir de R$ " + LIMITE_OURO + ", Prata a partir de R$ " + LIMITE_PRATA
                    + ", Bronze abaixo disso. Dias sem voltar: clientes bons que sumiram merecem um contato.");
        }

        planilha.sobre(Relatorio.CLIENTES,
                "Total gasto = soma do total dos pedidos do cliente no período (quantidade × preço).",
                "Entram só clientes com pelo menos um pedido no período; pedidos sem cliente ficam de fora.",
                "Ordem: quem gastou mais primeiro. Use o filtro do cabeçalho para ordenar por outra coluna.");
        return planilha.paraBytes();
    }
}
