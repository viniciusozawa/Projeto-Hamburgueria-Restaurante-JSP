package com.mycompany.restaurantehamburgueria.relatorio;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.EnumMap;
import java.util.Map;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xddf.usermodel.XDDFColor;
import org.apache.poi.xddf.usermodel.XDDFSolidFillProperties;
import org.apache.poi.xddf.usermodel.chart.ChartTypes;
import org.apache.poi.xddf.usermodel.chart.LegendPosition;
import org.apache.poi.xddf.usermodel.chart.XDDFChartData;
import org.apache.poi.xddf.usermodel.chart.XDDFDataSource;
import org.apache.poi.xddf.usermodel.chart.XDDFDataSourcesFactory;
import org.apache.poi.xddf.usermodel.chart.XDDFNumericalDataSource;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFChart;
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFDrawing;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * Abordagem 3 (Apache POI): a base comum das planilhas .xlsx.
 *
 * No exemplo do professor, cada relatório monta o Workbook na mão. Aqui
 * essa parte repetida (cores, formatos de dinheiro e data, cabeçalho,
 * linha de total) fica numa classe só, e cada relatório (RelatorioXxxExcel)
 * só diz quais colunas tem e o que vai em cada linha.
 *
 * Como uma aba fica:
 *   linha 1  BIG TITES · HAMBURGUERIA
 *   linha 2  título do relatório
 *   linha 3  período e data em que foi gerado
 *   linha 5  cabeçalho das colunas (verde, com filtro e congelado)
 *   linha 6+ os dados
 *   fim      linha de TOTAL com fórmulas =SOMA(), que o Excel recalcula
 *            se alguém editar um valor.
 *
 * Fórmulas: um valor do tipo {@link Formula} vira fórmula de verdade na
 * célula. "{r}" no texto é trocado pelo número da linha atual, ex.:
 * new Formula("G{r}-H{r}") na linha 7 vira =G7-H7.
 */
public class PlanilhaExcel {

    /** Como o valor de uma coluna é mostrado. */
    public enum Tipo { TEXTO, CODIGO, INTEIRO, DECIMAL, DINHEIRO, PERCENTUAL, DATA, DATA_HORA }

    /** Uma coluna: título, tipo e largura (em caracteres). */
    public static final class Coluna {
        final String titulo;
        final Tipo tipo;
        final int largura;

        Coluna(String titulo, Tipo tipo, int largura) {
            this.titulo = titulo;
            this.tipo = tipo;
            this.largura = largura;
        }
    }

    public static Coluna col(String titulo, Tipo tipo, int largura) {
        return new Coluna(titulo, tipo, largura);
    }

    /** Valor que vira fórmula do Excel. "{r}" = número da linha atual. */
    public static final class Formula {
        final String expressao;

        public Formula(String expressao) {
            this.expressao = expressao;
        }
    }

    /** Linha (1, 2, 3...) do Excel onde começam os dados de toda aba. */
    public static final int PRIMEIRA_LINHA_DADOS = 6;

    // Paleta "Esmalte" do site
    private static final XSSFColor ESMALTE = cor(0x12, 0x3B, 0x2E);
    private static final XSSFColor MOSTARDA = cor(0xE8, 0xA3, 0x17);
    private static final XSSFColor PAPEL = cor(0xF3, 0xEE, 0xE2);
    private static final XSSFColor PAPEL_CLARO = cor(0xFB, 0xF9, 0xF4);
    private static final XSSFColor CINZA = cor(0x6B, 0x7A, 0x70);

    /** Fatias do gráfico: esmalte, mostarda, pimenta, gordura, mostarda-tinta, esmalte-claro. */
    private static final byte[][] CORES_GRAFICO = {
        {(byte) 0x12, (byte) 0x3B, (byte) 0x2E},
        {(byte) 0xE8, (byte) 0xA3, (byte) 0x17},
        {(byte) 0xC4, (byte) 0x34, (byte) 0x1F},
        {(byte) 0x93, (byte) 0xAA, (byte) 0x9C},
        {(byte) 0x8A, (byte) 0x5E, (byte) 0x05},
        {(byte) 0x1C, (byte) 0x53, (byte) 0x40},
    };

    private final XSSFWorkbook livro = new XSSFWorkbook();
    private final String periodo;
    private final String geradoEm = new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date());

    private final Map<Tipo, XSSFCellStyle> estiloNormal = new EnumMap<>(Tipo.class);
    private final Map<Tipo, XSSFCellStyle> estiloZebra = new EnumMap<>(Tipo.class);
    private final Map<Tipo, XSSFCellStyle> estiloTotal = new EnumMap<>(Tipo.class);
    private final XSSFCellStyle estiloMarca;
    private final XSSFCellStyle estiloTitulo;
    private final XSSFCellStyle estiloSubtitulo;
    private final XSSFCellStyle estiloCabecalho;
    private final XSSFCellStyle estiloNota;

    /** @param periodo texto do período ("Todo o período", "De ... a ...") ou a data da foto */
    public PlanilhaExcel(String periodo) {
        this.periodo = periodo;

        estiloMarca = estilo(fonte(10, true, MOSTARDA));
        estiloTitulo = estilo(fonte(16, true, ESMALTE));
        estiloSubtitulo = estilo(fonte(9, false, CINZA));
        estiloNota = estilo(fonte(9, false, CINZA));
        estiloNota.setWrapText(true);
        estiloNota.setVerticalAlignment(VerticalAlignment.TOP);

        estiloCabecalho = estilo(fonte(10, true, cor(0xFF, 0xFF, 0xFF)));
        estiloCabecalho.setFillForegroundColor(ESMALTE);
        estiloCabecalho.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        estiloCabecalho.setVerticalAlignment(VerticalAlignment.CENTER);
        estiloCabecalho.setWrapText(true);
        estiloCabecalho.setIndention((short) 1);

        XSSFFont normal = fonte(10, false, cor(0x1E, 0x2A, 0x24));
        XSSFFont negrito = fonte(10, true, ESMALTE);
        for (Tipo tipo : Tipo.values()) {
            estiloNormal.put(tipo, estiloDado(tipo, normal, null));
            estiloZebra.put(tipo, estiloDado(tipo, normal, PAPEL_CLARO));
            XSSFCellStyle total = estiloDado(tipo, negrito, PAPEL);
            total.setBorderTop(BorderStyle.MEDIUM);
            total.setTopBorderColor(ESMALTE);
            estiloTotal.put(tipo, total);
        }
    }

    // ------------------------------------------------------------------ abas

    /** Cria uma aba com o bloco de título e o cabeçalho das colunas. */
    public Aba novaAba(String nome, String titulo, Coluna... colunas) {
        XSSFSheet aba = livro.createSheet(nome);
        celula(aba, 0, 0, "BIG TITES · HAMBURGUERIA", estiloMarca);
        celula(aba, 1, 0, titulo, estiloTitulo);
        celula(aba, 2, 0, periodo + "  ·  gerado em " + geradoEm, estiloSubtitulo);
        aba.getRow(1).setHeightInPoints(24);

        Row cabecalho = aba.createRow(PRIMEIRA_LINHA_DADOS - 2);
        cabecalho.setHeightInPoints(30);
        for (int i = 0; i < colunas.length; i++) {
            Cell c = cabecalho.createCell(i);
            c.setCellValue(colunas[i].titulo);
            XSSFCellStyle s = estiloCabecalho;
            if (colunas[i].tipo != Tipo.TEXTO) {
                s = livro.createCellStyle();
                s.cloneStyleFrom(estiloCabecalho);
                s.setAlignment(colunas[i].tipo == Tipo.CODIGO ? HorizontalAlignment.CENTER : HorizontalAlignment.RIGHT);
            }
            c.setCellStyle(s);
            aba.setColumnWidth(i, colunas[i].largura * 256);
        }
        // cabeçalho sempre visível ao rolar
        aba.createFreezePane(0, PRIMEIRA_LINHA_DADOS - 1);
        ajustarImpressao(aba);
        return new Aba(aba, colunas);
    }

    /** Aba "Sobre": a pergunta, a decisão e as regras de cálculo, para quem abrir o arquivo. */
    public void sobre(Relatorio relatorio, String... regras) {
        XSSFSheet aba = livro.createSheet("Sobre");
        ajustarImpressao(aba);
        aba.setColumnWidth(0, 18 * 256);
        aba.setColumnWidth(1, 90 * 256);
        celula(aba, 0, 0, "BIG TITES · HAMBURGUERIA", estiloMarca);
        celula(aba, 1, 0, relatorio.getTitulo(), estiloTitulo);
        celula(aba, 2, 0, periodo + "  ·  gerado em " + geradoEm, estiloSubtitulo);
        int r = 4;
        r = par(aba, r, "Pergunta", relatorio.getPergunta());
        r = par(aba, r, "Decisão", relatorio.getDecisao());
        r = par(aba, r, "Abordagem", "3 · Apache POI (planilha montada célula por célula)");
        for (String regra : regras) {
            r = par(aba, r, "Regra", regra);
        }
    }

    private int par(XSSFSheet aba, int r, String rotulo, String texto) {
        XSSFCellStyle negrito = estilo(fonte(10, true, ESMALTE));
        negrito.setVerticalAlignment(VerticalAlignment.TOP);
        celula(aba, r, 0, rotulo, negrito);
        celula(aba, r, 1, texto, estiloNota);
        aba.getRow(r).setHeightInPoints(texto.length() > 95 ? 30 : 16);
        return r + 1;
    }

    /** Gera o arquivo .xlsx. */
    public byte[] paraBytes() throws IOException {
        try (XSSFWorkbook l = livro; ByteArrayOutputStream saida = new ByteArrayOutputStream()) {
            l.write(saida);
            return saida.toByteArray();
        }
    }

    // ------------------------------------------------------------------ Aba

    /** Uma aba já com cabeçalho: acrescenta linhas, total, nota e gráfico. */
    public final class Aba {
        private final XSSFSheet folha;
        private final Coluna[] colunas;
        private int proxima = PRIMEIRA_LINHA_DADOS - 1; // índice 0-based da próxima linha

        Aba(XSSFSheet folha, Coluna[] colunas) {
            this.folha = folha;
            this.colunas = colunas;
        }

        /** Número (do Excel, 1-based) da linha que a próxima chamada de linha() vai escrever. */
        public int linhaAtual() {
            return proxima + 1;
        }

        /** Acrescenta uma linha de dados, um valor por coluna (null = célula vazia). */
        public void linha(Object... valores) {
            boolean zebra = (proxima - (PRIMEIRA_LINHA_DADOS - 1)) % 2 == 1;
            escrever(valores, zebra ? estiloZebra : estiloNormal);
        }

        /**
         * Linha de TOTAL. Nas colunas indicadas entra =SOMA() de todas as linhas
         * de dados; nas outras, o valor passado em "outros" (pode ser Formula).
         */
        public void total(String rotulo, int[] somar, Object... outros) {
            int ini = PRIMEIRA_LINHA_DADOS;
            int fim = proxima; // última linha escrita (1-based)
            Object[] valores = new Object[colunas.length];
            valores[0] = rotulo;
            for (int i = 0; i < outros.length && i + 1 < valores.length; i++) {
                valores[i + 1] = outros[i];
            }
            for (int c : somar) {
                String letra = letra(c);
                valores[c] = fim < ini ? (Object) 0 : new Formula("SUM(" + letra + ini + ":" + letra + fim + ")");
            }
            escrever(valores, estiloTotal);
            // filtro nas setas do cabeçalho, só sobre os dados (sem o total)
            if (fim >= ini) {
                folha.setAutoFilter(new CellRangeAddress(PRIMEIRA_LINHA_DADOS - 2, fim - 1, 0, colunas.length - 1));
            }
        }

        /** Texto explicativo abaixo da tabela, ocupando a largura das colunas. */
        public void nota(String texto) {
            proxima++;
            Row r = folha.createRow(proxima);
            Cell c = r.createCell(0);
            c.setCellValue(texto);
            c.setCellStyle(estiloNota);
            folha.addMergedRegion(new CellRangeAddress(proxima, proxima, 0, colunas.length - 1));
            r.setHeightInPoints(30);
            proxima++;
        }

        /** Mensagem quando não há nenhuma linha (ex.: período sem vendas). */
        public void vazio(String texto) {
            Row r = folha.createRow(proxima++);
            Cell c = r.createCell(0);
            c.setCellValue(texto);
            c.setCellStyle(estiloSubtitulo);
        }

        /**
         * Gráfico de pizza nativo do Excel, ligado às células: se alguém
         * mudar um valor na planilha, o gráfico muda junto.
         *
         * @param colRotulo coluna com os nomes das fatias
         * @param colValor  coluna com os valores
         * @param linhas    quantas linhas de dados usar
         */
        public void graficoPizza(String titulo, int colRotulo, int colValor, int linhas, int colunaDoGrafico) {
            if (linhas == 0) return;
            int ini = PRIMEIRA_LINHA_DADOS - 1;
            int fim = ini + linhas - 1;
            XSSFDrawing desenho = folha.createDrawingPatriarch();
            XSSFClientAnchor ancora = desenho.createAnchor(0, 0, 0, 0,
                    colunaDoGrafico, PRIMEIRA_LINHA_DADOS - 2, colunaDoGrafico + 7, PRIMEIRA_LINHA_DADOS + 16);
            XSSFChart grafico = desenho.createChart(ancora);
            grafico.setTitleText(titulo);
            grafico.setTitleOverlay(false);
            grafico.getOrAddLegend().setPosition(LegendPosition.RIGHT);

            // Os dados vão de dois jeitos: a referência às células (o Excel
            // redesenha se alguém mudar um valor) e uma cópia dos valores
            // (sem ela, o LibreOffice mostra a pizza vazia).
            String[] rotulos = new String[linhas];
            Double[] numeros = new Double[linhas];
            for (int i = 0; i < linhas; i++) {
                Row r = folha.getRow(ini + i);
                rotulos[i] = r.getCell(colRotulo).getStringCellValue();
                numeros[i] = r.getCell(colValor).getNumericCellValue();
            }
            String aba = "'" + folha.getSheetName() + "'!";
            XDDFDataSource<String> nomes = XDDFDataSourcesFactory.fromArray(rotulos,
                    aba + faixa(colRotulo, ini, fim));
            XDDFNumericalDataSource<Double> valores = XDDFDataSourcesFactory.fromArray(numeros,
                    aba + faixa(colValor, ini, fim));
            XDDFChartData dados = grafico.createData(ChartTypes.PIE, null, null);
            dados.setVaryColors(true);
            XDDFChartData.Series serie = dados.addSeries(nomes, valores);
            serie.setTitle(titulo, null);
            // Cor de cada fatia, explícita: a planilha do POI não tem "tema",
            // e sem tema o LibreOffice desenha as fatias transparentes.
            for (int i = 0; i < linhas; i++) {
                byte[] rgb = CORES_GRAFICO[i % CORES_GRAFICO.length];
                serie.getDataPoint(i).setFillProperties(
                        new XDDFSolidFillProperties(XDDFColor.from(rgb)));
            }
            grafico.plot(dados);
        }

        private void escrever(Object[] valores, Map<Tipo, XSSFCellStyle> estilos) {
            int numero = proxima + 1; // número da linha no Excel
            Row r = folha.createRow(proxima++);
            for (int i = 0; i < colunas.length; i++) {
                Cell c = r.createCell(i);
                Tipo tipo = colunas[i].tipo;
                Object v = i < valores.length ? valores[i] : null;
                if (v instanceof Formula) {
                    c.setCellFormula(((Formula) v).expressao.replace("{r}", String.valueOf(numero)));
                } else if (v instanceof Number) {
                    c.setCellValue(((Number) v).doubleValue());
                } else if (v instanceof LocalDateTime) {
                    c.setCellValue((LocalDateTime) v);
                } else if (v instanceof LocalDate) {
                    c.setCellValue((LocalDate) v);
                } else if (v instanceof Date) {
                    c.setCellValue((Date) v);
                } else if (v != null) {
                    c.setCellValue(v.toString());
                }
                // o rótulo do total ("TOTAL") fica na 1ª coluna mesmo que ela seja numérica
                c.setCellStyle(estilos.get(v instanceof String && tipo != Tipo.TEXTO ? Tipo.TEXTO : tipo));
            }
        }
    }

    // ------------------------------------------------------------- utilidades

    /** Letra da coluna (0 = A, 1 = B, ...). Basta até a Z. */
    public static String letra(int coluna) {
        return String.valueOf((char) ('A' + coluna));
    }

    /** Faixa absoluta de uma coluna, com linhas 0-based: (2, 5, 7) -> "$C$6:$C$8". */
    private static String faixa(int coluna, int linhaIni, int linhaFim) {
        String l = letra(coluna);
        return "$" + l + "$" + (linhaIni + 1) + ":$" + l + "$" + (linhaFim + 1);
    }

    /** Impressão: paisagem e tudo na largura de uma folha (a altura segue em quantas páginas precisar). */
    private static void ajustarImpressao(XSSFSheet aba) {
        aba.getPrintSetup().setLandscape(true);
        aba.getPrintSetup().setPaperSize(org.apache.poi.ss.usermodel.PrintSetup.A4_PAPERSIZE);
        aba.setFitToPage(true);
        aba.getPrintSetup().setFitWidth((short) 1);
        aba.getPrintSetup().setFitHeight((short) 0);
    }

    /** Converte BigDecimal nulo em zero, para somar sem NullPointerException. */
    public static BigDecimal zeroSeNulo(BigDecimal v) {
        return v == null ? BigDecimal.ZERO : v;
    }

    /**
     * O banco guarda só os dígitos do telefone (a máscara é assunto da tela,
     * ver js/mascaras.js). Aqui volta o formato da tela: "35 99999-9999".
     */
    public static String telefone(Object valor) {
        if (valor == null) return "";
        String d = valor.toString().replaceAll("\\D", "");
        if (d.length() == 11) return d.substring(0, 2) + " " + d.substring(2, 7) + "-" + d.substring(7);
        if (d.length() == 10) return d.substring(0, 2) + " " + d.substring(2, 6) + "-" + d.substring(6);
        return valor.toString();
    }

    /** "pix" -> "Pix", "não informada" -> "Não informada". */
    public static String primeiraMaiuscula(String texto) {
        if (texto == null || texto.isEmpty()) return "";
        return Character.toUpperCase(texto.charAt(0)) + texto.substring(1);
    }

    private XSSFCellStyle estiloDado(Tipo tipo, XSSFFont fonte, XSSFColor fundo) {
        XSSFCellStyle s = estilo(fonte);
        XSSFDataFormat formato = livro.createDataFormat();
        switch (tipo) {
            case CODIGO:     s.setDataFormat(formato.getFormat("0")); break;
            case INTEIRO:    s.setDataFormat(formato.getFormat("#,##0")); break;
            case DECIMAL:    s.setDataFormat(formato.getFormat("#,##0.00")); break;
            case DINHEIRO:   s.setDataFormat(formato.getFormat("\"R$\" #,##0.00")); break;
            case PERCENTUAL: s.setDataFormat(formato.getFormat("0.0%")); break;
            case DATA:       s.setDataFormat(formato.getFormat("dd/mm/yyyy")); break;
            case DATA_HORA:  s.setDataFormat(formato.getFormat("dd/mm/yyyy hh:mm")); break;
            default: break;
        }
        if (tipo == Tipo.CODIGO) {
            s.setAlignment(HorizontalAlignment.CENTER); // nº de pedido/mesa: é um código, não uma quantidade
        } else if (tipo != Tipo.TEXTO) {
            s.setAlignment(HorizontalAlignment.RIGHT);
        }
        if (fundo != null) {
            s.setFillForegroundColor(fundo);
            s.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        }
        // recuo de 1: texto à esquerda não encosta no número à direita da coluna vizinha
        s.setIndention((short) 1);
        s.setBorderBottom(BorderStyle.THIN);
        s.setBottomBorderColor(cor(0xEC, 0xE7, 0xDB));
        s.setVerticalAlignment(VerticalAlignment.CENTER);
        return s;
    }

    private XSSFCellStyle estilo(XSSFFont fonte) {
        XSSFCellStyle s = livro.createCellStyle();
        s.setFont(fonte);
        return s;
    }

    private XSSFFont fonte(int tamanho, boolean negrito, XSSFColor cor) {
        XSSFFont f = livro.createFont();
        f.setFontName("Calibri");
        f.setFontHeightInPoints((short) tamanho);
        f.setBold(negrito);
        f.setColor(cor);
        return f;
    }

    private static void celula(XSSFSheet aba, int linha, int coluna, String texto, XSSFCellStyle estilo) {
        Row r = aba.getRow(linha);
        if (r == null) r = aba.createRow(linha);
        Cell c = r.createCell(coluna);
        c.setCellValue(texto);
        c.setCellStyle(estilo);
    }

    private static XSSFColor cor(int r, int g, int b) {
        return new XSSFColor(new byte[]{(byte) r, (byte) g, (byte) b}, null);
    }
}
