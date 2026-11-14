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
 * Relatório 11 - Uso das mesas (Apache POI).
 *
 * Uma linha por mesa do salão, inclusive as que não tiveram pedido no
 * período (aparecem com zero). Valor médio e % dos pedidos são fórmulas.
 */
public class RelatorioUsoMesasExcel {

    private final List<Map<String, Object>> mesas;
    private final String periodo;

    public RelatorioUsoMesasExcel(List<Map<String, Object>> mesas, String periodo) {
        this.mesas = mesas;
        this.periodo = periodo;
    }

    public byte[] gerar() throws IOException {
        PlanilhaExcel planilha = new PlanilhaExcel(periodo);
        Aba aba = planilha.novaAba("Mesas", "Uso das mesas",
                col("Mesa", Tipo.CODIGO, 8),                      // A
                col("Local", Tipo.TEXTO, 22),                     // B
                col("Pedidos", Tipo.INTEIRO, 10),                 // C
                col("Itens", Tipo.INTEIRO, 8),                    // D
                col("Faturamento", Tipo.DINHEIRO, 15),            // E
                col("Valor médio por pedido", Tipo.DINHEIRO, 14), // F
                col("% dos pedidos", Tipo.PERCENTUAL, 11),        // G
                col("Último pedido", Tipo.DATA_HORA, 17));        // H

        int ini = PRIMEIRA_LINHA_DADOS;
        int fim = ini + mesas.size() - 1;
        String somaPedidos = "SUM(C$" + ini + ":C$" + fim + ")";
        int paradas = 0;
        for (Map<String, Object> m : mesas) {
            if (((Number) m.get("pedidos")).longValue() == 0) paradas++;
            aba.linha(
                    m.get("numeroMesa"),
                    m.get("localMesa"),
                    m.get("pedidos"),
                    m.get("itens"),
                    m.get("faturamento"),
                    new Formula("IF(C{r}=0,0,E{r}/C{r})"),
                    new Formula("IF(" + somaPedidos + "=0,0,C{r}/" + somaPedidos + ")"),
                    m.get("ultimo"));
        }

        if (mesas.isEmpty()) {
            aba.vazio("Nenhuma mesa cadastrada.");
        } else {
            aba.total("TOTAL (" + mesas.size() + " mesas)", new int[]{2, 3, 4, 6},
                    null, null, null, null, new Formula("IF(C{r}=0,0,E{r}/C{r})"));
            aba.nota(paradas == 0
                    ? "Todas as mesas tiveram pedido no período."
                    : paradas == 1
                      ? "1 mesa ficou parada no período (0 pedidos): candidata a mudar de lugar ou sair do salão."
                      : paradas + " mesas ficaram paradas no período (0 pedidos): candidatas a mudar de lugar ou sair do salão.");
        }

        planilha.sobre(Relatorio.MESAS,
                "Faturamento = soma do total dos pedidos da mesa (quantidade × preço do cardápio).",
                "O período filtra pela data em que o pedido foi aberto. Mesas sem pedido aparecem com zero.",
                "Duas mesas com o mesmo número são lugares diferentes: confira a coluna Local.");
        return planilha.paraBytes();
    }
}
