package com.mycompany.restaurantehamburgueria.relatorio;

import static com.mycompany.restaurantehamburgueria.relatorio.PlanilhaExcel.PRIMEIRA_LINHA_DADOS;
import static com.mycompany.restaurantehamburgueria.relatorio.PlanilhaExcel.col;

import com.mycompany.restaurantehamburgueria.relatorio.PlanilhaExcel.Aba;
import com.mycompany.restaurantehamburgueria.relatorio.PlanilhaExcel.Formula;
import com.mycompany.restaurantehamburgueria.relatorio.PlanilhaExcel.Tipo;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Relatório 10 - Folha por cargo e turno (Apache POI).
 *
 * Três abas, do resumo para o detalhe:
 *   "Por cargo"     funcionários, total e média de salário de cada cargo,
 *                   % da folha e um gráfico de pizza;
 *   "Por turno"     o mesmo, agrupado pelo horário de trabalho;
 *   "Funcionários"  uma linha por pessoa.
 *
 * O agrupamento é feito aqui em Java, a partir da lista de funcionários,
 * para mostrar que o POI recebe os dados já prontos de qualquer lugar.
 * Não usa período: é a folha de hoje.
 */
public class RelatorioFolhaExcel {

    private final List<Map<String, Object>> funcionarios;
    private final String situacao;

    public RelatorioFolhaExcel(List<Map<String, Object>> funcionarios, String situacao) {
        this.funcionarios = funcionarios;
        this.situacao = situacao;
    }

    /** Um grupo (cargo ou turno): quantas pessoas e quanto somam os salários. */
    private static final class Grupo {
        String rotulo;
        String perfil;
        int pessoas;
        BigDecimal salarios = BigDecimal.ZERO;
    }

    public byte[] gerar() throws IOException {
        Map<String, Grupo> porCargo = new LinkedHashMap<>();
        Map<String, Grupo> porTurno = new LinkedHashMap<>();
        for (Map<String, Object> f : funcionarios) {
            BigDecimal salario = PlanilhaExcel.zeroSeNulo((BigDecimal) f.get("salarioFuncionario"));
            somar(porCargo, (String) f.get("cargo"), (String) f.get("perfil"), salario);
            somar(porTurno, (String) f.get("turno"), null, salario);
        }

        PlanilhaExcel planilha = new PlanilhaExcel(situacao);

        Aba cargos = planilha.novaAba("Por cargo", "Folha por cargo",
                col("Cargo", Tipo.TEXTO, 20),              // A
                col("Perfil no sistema", Tipo.TEXTO, 14),  // B
                col("Funcionários", Tipo.INTEIRO, 13),     // C
                col("Total de salários", Tipo.DINHEIRO, 17), // D
                col("Salário médio", Tipo.DINHEIRO, 15),   // E
                col("% da folha", Tipo.PERCENTUAL, 11));   // F
        resumo(cargos, porCargo, true);
        cargos.graficoPizza("Folha por cargo", 0, 3, porCargo.size(), 7);

        Aba turnos = planilha.novaAba("Por turno", "Folha por turno",
                col("Turno", Tipo.TEXTO, 20),              // A
                col("", Tipo.TEXTO, 2),                    // B (vazia: mantém as mesmas letras da aba anterior)
                col("Funcionários", Tipo.INTEIRO, 13),     // C
                col("Total de salários", Tipo.DINHEIRO, 17), // D
                col("Salário médio", Tipo.DINHEIRO, 15),   // E
                col("% da folha", Tipo.PERCENTUAL, 11));   // F
        resumo(turnos, porTurno, false);

        Aba pessoas = planilha.novaAba("Funcionários", "Funcionários e salários",
                col("Nome", Tipo.TEXTO, 24),               // A
                col("Cargo", Tipo.TEXTO, 18),              // B
                col("Perfil", Tipo.TEXTO, 12),             // C
                col("Turno", Tipo.TEXTO, 16),              // D
                col("Salário", Tipo.DINHEIRO, 14));        // E
        for (Map<String, Object> f : funcionarios) {
            pessoas.linha(f.get("nomeFuncionario"), f.get("cargo"), f.get("perfil"), f.get("turno"),
                    f.get("salarioFuncionario"));
        }
        if (funcionarios.isEmpty()) {
            pessoas.vazio("Nenhum funcionário cadastrado.");
        } else {
            pessoas.total("TOTAL (" + funcionarios.size() + " funcionários)", new int[]{4});
        }

        planilha.sobre(Relatorio.FOLHA,
                "Salário = valor mensal do cadastro do funcionário. Encargos e benefícios não entram.",
                "Perfil no sistema = o que o cargo pode fazer no painel (ADMIN, GARCOM, COZINHA, OUTRO).",
                "Salários muito baixos (ex.: R$ 1,00) indicam cadastro de teste ou erro de digitação: confira na aba Funcionários.");
        return planilha.paraBytes();
    }

    private static void somar(Map<String, Grupo> grupos, String rotulo, String perfil, BigDecimal salario) {
        String chave = rotulo == null || rotulo.isBlank() ? "Sem informação" : rotulo;
        Grupo g = grupos.computeIfAbsent(chave, k -> new Grupo());
        g.rotulo = chave;
        g.perfil = perfil;
        g.pessoas++;
        g.salarios = g.salarios.add(salario);
    }

    /** Escreve as linhas do resumo: Total e % em fórmulas sobre a coluna D. */
    private static void resumo(Aba aba, Map<String, Grupo> grupos, boolean comPerfil) {
        int ini = PRIMEIRA_LINHA_DADOS;
        int fim = ini + grupos.size() - 1;
        String soma = "SUM(D$" + ini + ":D$" + fim + ")";
        for (Grupo g : grupos.values()) {
            aba.linha(
                    g.rotulo,
                    comPerfil ? g.perfil : null,
                    g.pessoas,
                    g.salarios,
                    new Formula("IF(C{r}=0,0,D{r}/C{r})"),
                    new Formula("IF(" + soma + "=0,0,D{r}/" + soma + ")"));
        }
        if (grupos.isEmpty()) {
            aba.vazio("Nenhum funcionário cadastrado.");
        } else {
            aba.total("TOTAL", new int[]{2, 3, 5}, null, null, null, new Formula("IF(C{r}=0,0,D{r}/C{r})"));
        }
    }
}
