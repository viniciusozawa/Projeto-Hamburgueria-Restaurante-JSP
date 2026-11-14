package com.mycompany.restaurantehamburgueria.relatorio;

/**
 * Catálogo dos relatórios: a ÚNICA lista deles no sistema.
 *
 * A tela Relatorios.jsp desenha um cartão por item, e o RelatorioController
 * usa o mesmo item para saber qual .jrxml (ou qual planilha POI) gerar.
 * Acrescentar um relatório = acrescentar uma linha aqui (e o arquivo dele).
 *
 * "pergunta" e "decisao" vão para a tela e para a apresentação: a atividade
 * pede que cada relatório mostre que decisão ele ajuda a tomar.
 *
 * "pronto" marca o que já foi implementado; o resto aparece como "em breve".
 */
public enum Relatorio {

    // ===== Abordagem 1: JasperReports (PDF, e Excel pelo exportador do Jasper) =====
    FATURAMENTO("faturamento", "Faturamento por dia", "fa-chart-column", Abordagem.JASPER, Filtro.PERIODO,
            "faturamento_diario", true,
            "Quanto vendemos e recebemos em cada dia?",
            "Em que dias reforçar equipe e estoque, e quanto ainda falta receber."),
    PRATOS("pratos", "Pratos mais vendidos", "fa-burger", Abordagem.JASPER, Filtro.PERIODO,
            "pratos_mais_vendidos", true,
            "Quais pratos vendem mais e quais quase não saem?",
            "O que promover, reajustar ou tirar do cardápio."),
    CATEGORIAS("categorias", "Vendas por categoria", "fa-chart-pie", Abordagem.JASPER, Filtro.PERIODO,
            "vendas_por_categoria", true,
            "Quanto cada categoria pesa no faturamento?",
            "Em que parte do cardápio investir em pratos novos."),
    FUNCIONARIOS("funcionarios", "Desempenho por funcionário", "fa-user-tie", Abordagem.JASPER, Filtro.PERIODO,
            "desempenho_funcionarios", true,
            "Quantos pedidos e quanto em vendas cada funcionário atendeu?",
            "Montar a escala dos turnos e definir bonificações."),
    ESTOQUE("estoque", "Estoque a vencer", "fa-carrot", Abordagem.JASPER, Filtro.NENHUM,
            "estoque_a_vencer", true,
            "Quais ingredientes vencem logo ou estão acabando?",
            "O que comprar e o que usar primeiro para não desperdiçar."),
    COMANDA("comanda", "Comanda do pedido", "fa-receipt", Abordagem.JASPER, Filtro.PEDIDO,
            "comanda_pedido", true,
            "O que foi pedido, quanto custou e quanto já foi pago?",
            "Entregar o comprovante ao cliente e conferir o caixa."),

    // ===== Abordagem 3: Apache POI (planilha .xlsx montada célula por célula) =====
    RECEBER("receber", "Contas a receber", "fa-hand-holding-dollar", Abordagem.POI, Filtro.PERIODO,
            null, true,
            "Quais pedidos ainda não foram pagos por completo?",
            "Quem cobrar e quanto dinheiro ainda vai entrar no caixa."),
    FORMAS("formas", "Recebimentos por forma de pagamento", "fa-credit-card", Abordagem.POI, Filtro.PERIODO,
            null, true,
            "Como os clientes preferem pagar?",
            "Negociar taxas da maquininha e planejar o troco do caixa."),
    CLIENTES("clientes", "Melhores clientes", "fa-users", Abordagem.POI, Filtro.PERIODO,
            null, true,
            "Quem compra mais e com que frequência?",
            "Quem recompensar num programa de fidelidade."),
    FOLHA("folha", "Folha por cargo e turno", "fa-id-badge", Abordagem.POI, Filtro.NENHUM,
            null, true,
            "Quanto custa a equipe em cada cargo e turno?",
            "Contratar, remanejar pessoas ou ajustar as escalas."),
    MESAS("mesas", "Uso das mesas", "fa-chair", Abordagem.POI, Filtro.PERIODO,
            null, true,
            "Quais mesas recebem mais pedidos e quanto rendem?",
            "Arrumar o salão e decidir onde posicionar os garçons.");

    /** Como o relatório é feito. */
    public enum Abordagem {
        JASPER("JasperReports"), POI("Apache POI");

        private final String rotulo;

        Abordagem(String rotulo) {
            this.rotulo = rotulo;
        }

        public String getRotulo() {
            return rotulo;
        }
    }

    /** Que filtro o cartão mostra na tela. */
    public enum Filtro {
        PERIODO, PEDIDO, NENHUM
    }

    private final String chave;
    private final String titulo;
    private final String icone;
    private final Abordagem abordagem;
    private final Filtro filtro;
    private final String jrxml;
    private final boolean pronto;
    private final String pergunta;
    private final String decisao;

    Relatorio(String chave, String titulo, String icone, Abordagem abordagem, Filtro filtro,
            String jrxml, boolean pronto, String pergunta, String decisao) {
        this.chave = chave;
        this.titulo = titulo;
        this.icone = icone;
        this.abordagem = abordagem;
        this.filtro = filtro;
        this.jrxml = jrxml;
        this.pronto = pronto;
        this.pergunta = pergunta;
        this.decisao = decisao;
    }

    /** Procura pela chave da URL (?opcao=...). Devolve null se não existir. */
    public static Relatorio pelaChave(String chave) {
        for (Relatorio r : values()) {
            if (r.chave.equals(chave)) {
                return r;
            }
        }
        return null;
    }

    /** Número de 1 a 11, na ordem da lista (para a tela e a apresentação). */
    public int getNumero() {
        return ordinal() + 1;
    }

    public String getChave() { return chave; }
    public String getTitulo() { return titulo; }
    public String getIcone() { return icone; }
    public Abordagem getAbordagem() { return abordagem; }
    public Filtro getFiltro() { return filtro; }
    public String getJrxml() { return jrxml; }
    public boolean isPronto() { return pronto; }
    public String getPergunta() { return pergunta; }
    public String getDecisao() { return decisao; }

    /** O Jasper exporta PDF e Excel; o POI só gera Excel. */
    public boolean isTemPdf() {
        return abordagem == Abordagem.JASPER;
    }

    /** Nome do arquivo baixado, ex.: "faturamento-por-dia". */
    public String getArquivo() {
        return java.text.Normalizer.normalize(titulo.toLowerCase(), java.text.Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")          // tira acentos
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("(^-|-$)", "");
    }
}
