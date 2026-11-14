package com.mycompany.restaurantehamburgueria.relatorio;

import com.mycompany.restaurantehamburgueria.model.dao.ConnectionFactory;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRParameter;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter;
import net.sf.jasperreports.export.SimpleExporterInput;
import net.sf.jasperreports.export.SimpleOutputStreamExporterOutput;
import net.sf.jasperreports.export.SimpleXlsxReportConfiguration;

/**
 * Abordagem 1 (JasperReports): as três etapas de todo relatório Jasper.
 *
 *   1. COMPILAR  o .jrxml (o desenho, em XML) vira um JasperReport;
 *   2. PREENCHER o Jasper roda o SQL que está dentro do .jrxml, usando a
 *                conexão e os parâmetros que passamos, e gera um JasperPrint
 *                (o relatório pronto, ainda sem formato);
 *   3. EXPORTAR  o JasperPrint vira PDF ou Excel.
 *
 * Os .jrxml ficam em src/main/resources/relatorios/. Compilar demora (gera e
 * compila uma classe Java), então cada relatório é compilado só na primeira
 * vez e guardado no CACHE até o próximo deploy.
 *
 * Os .jrxml estão no formato da versão 6. Não salve pelo Jaspersoft Studio 7:
 * ele converte para o formato 7, que a biblioteca 6.21 não lê.
 */
public final class RelatorioJasper {

    private static final String PASTA = "/relatorios/";
    private static final Locale PT_BR = new Locale("pt", "BR");

    private static final Map<String, JasperReport> CACHE = new ConcurrentHashMap<>();

    private RelatorioJasper() {
    }

    /** Etapa 1: compila o .jrxml (só na primeira vez). */
    static JasperReport carregar(String nome) throws JRException {
        JasperReport pronto = CACHE.get(nome);
        if (pronto != null) {
            return pronto;
        }
        try (InputStream jrxml = RelatorioJasper.class.getResourceAsStream(PASTA + nome + ".jrxml")) {
            if (jrxml == null) {
                throw new JRException("Relatório não encontrado: " + PASTA + nome + ".jrxml");
            }
            JasperReport compilado = JasperCompileManager.compileReport(jrxml);
            CACHE.put(nome, compilado);
            return compilado;
        } catch (IOException e) {
            throw new JRException("Não deu para ler " + nome + ".jrxml", e);
        }
    }

    /**
     * Etapa 2: roda o SQL do relatório com estes parâmetros.
     * A conexão é aberta e fechada aqui: o Jasper só precisa dela enquanto preenche.
     */
    public static JasperPrint preencher(String nome, Map<String, Object> parametros) throws JRException, SQLException {
        Map<String, Object> todos = new HashMap<>(parametros);
        // pt_BR: "R$ 1.234,56" e "13/11/2026" nos padrões de formato do .jrxml
        todos.put(JRParameter.REPORT_LOCALE, PT_BR);
        try (Connection conexao = ConnectionFactory.getInstance().getConnection()) {
            return JasperFillManager.fillReport(carregar(nome), todos, conexao);
        }
    }

    /** Etapa 3a: PDF. */
    public static byte[] pdf(JasperPrint relatorio) throws JRException {
        return JasperExportManager.exportReportToPdf(relatorio);
    }

    /** Etapa 3b: Excel (.xlsx), uma aba por página, com números como números. */
    public static byte[] xlsx(JasperPrint relatorio) throws JRException {
        ByteArrayOutputStream saida = new ByteArrayOutputStream();
        JRXlsxExporter exportador = new JRXlsxExporter();
        exportador.setExporterInput(new SimpleExporterInput(relatorio));
        exportador.setExporterOutput(new SimpleOutputStreamExporterOutput(saida));

        SimpleXlsxReportConfiguration config = new SimpleXlsxReportConfiguration();
        config.setOnePagePerSheet(false);        // tudo numa aba só
        config.setDetectCellType(true);           // "12,50" vira número, não texto
        config.setRemoveEmptySpaceBetweenRows(true);
        config.setWhitePageBackground(false);
        exportador.setConfiguration(config);

        exportador.exportReport();
        return saida.toByteArray();
    }
}
