package com.mycompany.restaurantehamburgueria.relatorio;

import static com.mycompany.restaurantehamburgueria.relatorio.PlanilhaExcel.PRIMEIRA_LINHA_DADOS;
import static com.mycompany.restaurantehamburgueria.relatorio.PlanilhaExcel.col;

import com.mycompany.restaurantehamburgueria.relatorio.PlanilhaExcel.Aba;
import com.mycompany.restaurantehamburgueria.relatorio.PlanilhaExcel.Formula;
import com.mycompany.restaurantehamburgueria.relatorio.PlanilhaExcel.Tipo;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Relatório 7 - Contas a receber (Apache POI).
 *
 * Um pedido por linha: os que têm itens e ainda não foram pagos por
 * completo, do mais antigo para o mais novo (quem está devendo há mais
 * tempo aparece primeiro).
 *
 * Duas colunas são FÓRMULAS do Excel, não valores calculados em Java:
 *   Falta          = Total - Pago
 *   Dias em aberto = HOJE() - data do pedido (muda sozinha a cada dia)
 */
public class RelatorioContasReceberExcel {

    private final List<Map<String, Object>> pedidos;
    private final String periodo;

    public RelatorioContasReceberExcel(List<Map<String, Object>> pedidos, String periodo) {
        this.pedidos = pedidos;
        this.periodo = periodo;
    }

    public byte[] gerar() throws IOException {
        PlanilhaExcel planilha = new PlanilhaExcel(periodo);
        Aba aba = planilha.novaAba("A receber", "Contas a receber",
                col("Pedido nº", Tipo.CODIGO, 10),        // A
                col("Aberto em", Tipo.DATA_HORA, 17),     // B
                col("Cliente", Tipo.TEXTO, 24),           // C
                col("Telefone", Tipo.TEXTO, 15),          // D
                col("Mesa", Tipo.CODIGO, 7),              // E
                col("Atendente", Tipo.TEXTO, 18),         // F
                col("Itens", Tipo.INTEIRO, 7),            // G
                col("Total", Tipo.DINHEIRO, 13),          // H
                col("Pago", Tipo.DINHEIRO, 13),           // I
                col("Falta", Tipo.DINHEIRO, 13),          // J
                col("Dias em aberto", Tipo.INTEIRO, 10)); // K

        for (Map<String, Object> p : pedidos) {
            aba.linha(
                    p.get("codpedido"),
                    p.get("datahoraPedido"),
                    p.get("nomeCliente") == null ? "não informado" : p.get("nomeCliente"),
                    PlanilhaExcel.telefone(p.get("telefone")),
                    p.get("numeroMesa"),
                    p.get("nomeFuncionario"),
                    p.get("itens"),
                    p.get("total"),
                    p.get("recebido"),
                    new Formula("H{r}-I{r}"),
                    new Formula("INT(TODAY()-B{r})"));
        }

        if (pedidos.isEmpty()) {
            aba.vazio("Nenhum pedido em aberto no período: tudo recebido.");
        } else {
            int fim = PRIMEIRA_LINHA_DADOS + pedidos.size() - 1;
            Object[] outros = new Object[10];
            outros[9] = new Formula("MAX(K" + PRIMEIRA_LINHA_DADOS + ":K" + fim + ")"); // coluna K: o mais antigo
            aba.total("TOTAL (" + pedidos.size() + " pedidos)", new int[]{6, 7, 8, 9}, outros);
            aba.nota("Falta = Total - Pago. Dias em aberto = hoje - data do pedido: a planilha recalcula sozinha "
                    + "quando é aberta em outro dia. No total, Dias em aberto mostra o pedido mais antigo.");
        }

        planilha.sobre(Relatorio.RECEBER,
                "Total do pedido = soma de quantidade × preço do cardápio.",
                "Pago = soma dos pagamentos lançados no pedido. Entra na lista o pedido com itens e Pago menor que o Total "
                        + "(a mesma regra que tira o pedido da lista \"Em aberto\" do painel).",
                "O período filtra pela data em que o pedido foi aberto.");
        return planilha.paraBytes();
    }
}
