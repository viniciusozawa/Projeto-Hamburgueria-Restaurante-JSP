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
 * Relatório 8 - Recebimentos por forma de pagamento (Apache POI).
 *
 * Duas abas:
 *   "Resumo"       uma linha por forma (Pix, Dinheiro...), com % e valor
 *                  médio em fórmulas, e um gráfico de pizza nativo do Excel;
 *   "Lançamentos"  cada pagamento do período, para conferir o resumo.
 *
 * O período filtra pela data do PAGAMENTO (o dia em que o dinheiro entrou).
 */
public class RelatorioFormasPagamentoExcel {

    private final List<Map<String, Object>> porForma;
    private final List<Map<String, Object>> lancamentos;
    private final String periodo;

    public RelatorioFormasPagamentoExcel(List<Map<String, Object>> porForma,
            List<Map<String, Object>> lancamentos, String periodo) {
        this.porForma = porForma;
        this.lancamentos = lancamentos;
        this.periodo = periodo;
    }

    public byte[] gerar() throws IOException {
        PlanilhaExcel planilha = new PlanilhaExcel(periodo);

        // ----- aba 1: resumo por forma -----
        Aba resumo = planilha.novaAba("Resumo", "Recebimentos por forma de pagamento",
                col("Forma de pagamento", Tipo.TEXTO, 20), // A
                col("Pagamentos", Tipo.INTEIRO, 12),       // B
                col("Valor recebido", Tipo.DINHEIRO, 16),  // C
                col("% do valor", Tipo.PERCENTUAL, 11),    // D
                col("Valor médio", Tipo.DINHEIRO, 14));    // E

        int ini = PRIMEIRA_LINHA_DADOS;
        int fim = ini + porForma.size() - 1;
        String somaValor = "SUM(C$" + ini + ":C$" + fim + ")";
        for (Map<String, Object> f : porForma) {
            resumo.linha(
                    PlanilhaExcel.primeiraMaiuscula((String) f.get("forma")),
                    f.get("pagamentos"),
                    f.get("valor"),
                    new Formula("IF(" + somaValor + "=0,0,C{r}/" + somaValor + ")"),
                    new Formula("IF(B{r}=0,0,C{r}/B{r})"));
        }
        if (porForma.isEmpty()) {
            resumo.vazio("Nenhum pagamento no período.");
        } else {
            resumo.total("TOTAL", new int[]{1, 2, 3}, null, null, null, new Formula("IF(B{r}=0,0,C{r}/B{r})"));
            resumo.nota("Formas escritas de jeitos diferentes no cadastro (\"pix\", \"Pix\") foram somadas juntas. "
                    + "% do valor e Valor médio são fórmulas: mudam se um valor da tabela for editado.");
            resumo.graficoPizza("Valor recebido por forma", 0, 2, porForma.size(), 6);
        }

        // ----- aba 2: cada pagamento -----
        Aba lista = planilha.novaAba("Lançamentos", "Pagamentos do período",
                col("Data", Tipo.DATA, 12),              // A
                col("Pedido nº", Tipo.CODIGO, 10),       // B
                col("Cliente", Tipo.TEXTO, 24),          // C
                col("Forma", Tipo.TEXTO, 16),            // D
                col("Valor", Tipo.DINHEIRO, 14));        // E
        for (Map<String, Object> p : lancamentos) {
            lista.linha(
                    p.get("dataPagamento"),
                    p.get("pedido_codpedido"),
                    p.get("nomeCliente"),
                    PlanilhaExcel.primeiraMaiuscula((String) p.get("forma")),
                    p.get("valorPago"));
        }
        if (lancamentos.isEmpty()) {
            lista.vazio("Nenhum pagamento no período.");
        } else {
            lista.total("TOTAL (" + lancamentos.size() + " pagamentos)", new int[]{4});
        }

        planilha.sobre(Relatorio.FORMAS,
                "Valor recebido = soma de valorPago dos pagamentos da forma.",
                "O período filtra pela data do pagamento, não pela data do pedido.",
                "A aba Lançamentos lista cada pagamento: o total dela é igual ao total do Resumo.");
        return planilha.paraBytes();
    }
}
