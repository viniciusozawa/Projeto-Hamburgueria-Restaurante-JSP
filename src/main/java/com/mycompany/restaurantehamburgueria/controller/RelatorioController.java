package com.mycompany.restaurantehamburgueria.controller;

import com.mycompany.restaurantehamburgueria.model.dao.PedidoDao;
import com.mycompany.restaurantehamburgueria.model.dao.RelatorioDao;
import com.mycompany.restaurantehamburgueria.relatorio.Relatorio;
import com.mycompany.restaurantehamburgueria.relatorio.RelatorioContasReceberExcel;
import com.mycompany.restaurantehamburgueria.relatorio.RelatorioFolhaExcel;
import com.mycompany.restaurantehamburgueria.relatorio.RelatorioFormasPagamentoExcel;
import com.mycompany.restaurantehamburgueria.relatorio.RelatorioJasper;
import com.mycompany.restaurantehamburgueria.relatorio.RelatorioMelhoresClientesExcel;
import com.mycompany.restaurantehamburgueria.relatorio.RelatorioUsoMesasExcel;
import com.mycompany.restaurantehamburgueria.service.WebConstante;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.sf.jasperreports.engine.JasperPrint;

/**
 * Tela e download dos relatórios.
 *
 *   .../RelatorioController                       -> tela Relatorios.jsp (a lista)
 *   .../RelatorioController?opcao=faturamento&formato=pdf&dataInicio=2025-11-01&dataFim=2025-11-30
 *
 * opcao   = chave do relatório (ver relatorio/Relatorio.java);
 * formato = pdf (abre no navegador) ou xlsx (baixa a planilha);
 * datas   = opcionais, no formato do <input type="date"> (aaaa-mm-dd).
 *
 * Só o ADMIN acessa por enquanto: o controlador não está na tabela de
 * Permissoes para os outros perfis, e o que não está lá é negado.
 */
@WebServlet(WebConstante.BASE_PATH + "/RelatorioController")
public class RelatorioController extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(RelatorioController.class.getName());
    private static final DateTimeFormatter BR = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private final PedidoDao pedidoDao = new PedidoDao();
    private final RelatorioDao relatorioDao = new RelatorioDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao = request.getParameter("opcao");

        if (opcao == null || opcao.isEmpty() || "listar".equals(opcao)) {
            request.setAttribute("relatorios", Relatorio.values());
            request.getRequestDispatcher("/Relatorios.jsp").forward(request, response);
            return;
        }

        Relatorio relatorio = Relatorio.pelaChave(opcao);
        if (relatorio == null) {
            erro(response, HttpServletResponse.SC_NOT_FOUND, "Relatório desconhecido: " + opcao);
            return;
        }
        if (!relatorio.isPronto()) {
            erro(response, HttpServletResponse.SC_NOT_FOUND, "O relatório \"" + relatorio.getTitulo() + "\" ainda não foi feito.");
            return;
        }

        // o POI só gera Excel; o Jasper gera os dois (PDF é o padrão)
        boolean querExcel = "xlsx".equalsIgnoreCase(request.getParameter("formato")) || !relatorio.isTemPdf();
        String formato = querExcel ? "xlsx" : "pdf";

        try {
            LocalDate inicio = data(request.getParameter("dataInicio"));
            LocalDate fim = data(request.getParameter("dataFim"));
            if (inicio != null && fim != null && inicio.isAfter(fim)) {
                erro(response, HttpServletResponse.SC_BAD_REQUEST, "A data inicial é depois da data final.");
                return;
            }

            Map<String, Object> parametros = new HashMap<>();
            parametros.put("DATA_INICIO", inicio == null ? null : Date.valueOf(inicio));
            parametros.put("DATA_FIM", fim == null ? null : Date.valueOf(fim));
            parametros.put("PERIODO", periodo(inicio, fim));
            String arquivo = relatorio.getArquivo();

            if (relatorio.getFiltro() == Relatorio.Filtro.PEDIDO) {
                String codIn = request.getParameter("codPedido");
                if (codIn == null || !codIn.trim().matches("\\d{1,9}")) {
                    erro(response, HttpServletResponse.SC_BAD_REQUEST, "Informe o número do pedido.");
                    return;
                }
                int codPedido = Integer.parseInt(codIn.trim());
                // confere antes: sem isso o Jasper devolveria um cupom em branco
                if (pedidoDao.buscarPorId(codPedido) == null) {
                    erro(response, HttpServletResponse.SC_NOT_FOUND, "O pedido nº " + codPedido + " não existe.");
                    return;
                }
                parametros.put("COD_PEDIDO", codPedido);
                arquivo += "-" + codPedido;
            }

            byte[] conteudo;
            if (relatorio.getAbordagem() == Relatorio.Abordagem.JASPER) {
                JasperPrint pronto = RelatorioJasper.preencher(relatorio.getJrxml(), parametros);
                // Gera tudo na memória antes de responder: se der erro no meio,
                // o navegador recebe a mensagem, não um PDF pela metade.
                conteudo = querExcel ? RelatorioJasper.xlsx(pronto) : RelatorioJasper.pdf(pronto);
            } else {
                conteudo = planilha(relatorio, inicio, fim, periodo(inicio, fim));
            }
            enviar(response, conteudo, arquivo, formato);

        } catch (DateTimeParseException e) {
            erro(response, HttpServletResponse.SC_BAD_REQUEST, "Data inválida: use o calendário do formulário.");
        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Falha ao gerar o relatório " + opcao, e);
            erro(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Não foi possível gerar o relatório: " + e.getMessage());
        }
    }

    /**
     * Abordagem 3 (Apache POI): busca os dados no RelatorioDao e entrega à
     * classe do relatório, que monta a planilha célula por célula.
     */
    private byte[] planilha(Relatorio relatorio, LocalDate inicio, LocalDate fim, String periodo)
            throws java.sql.SQLException, IOException {
        switch (relatorio) {
            case RECEBER:
                return new RelatorioContasReceberExcel(relatorioDao.contasAReceber(inicio, fim), periodo).gerar();
            case FORMAS:
                return new RelatorioFormasPagamentoExcel(relatorioDao.recebimentosPorForma(inicio, fim),
                        relatorioDao.pagamentos(inicio, fim), periodo).gerar();
            case CLIENTES:
                return new RelatorioMelhoresClientesExcel(relatorioDao.melhoresClientes(inicio, fim), periodo).gerar();
            case FOLHA:
                return new RelatorioFolhaExcel(relatorioDao.folha(),
                        "Situação em " + LocalDate.now().format(BR)).gerar();
            case MESAS:
                return new RelatorioUsoMesasExcel(relatorioDao.usoDasMesas(inicio, fim), periodo).gerar();
            default:
                throw new IllegalStateException("Sem planilha para " + relatorio);
        }
    }

    private static LocalDate data(String valor) {
        return (valor == null || valor.isBlank()) ? null : LocalDate.parse(valor);
    }

    /** O período por extenso, para o cabeçalho do relatório. */
    static String periodo(LocalDate inicio, LocalDate fim) {
        if (inicio == null && fim == null) return "Todo o período";
        if (inicio == null) return "Até " + fim.format(BR);
        if (fim == null) return "A partir de " + inicio.format(BR);
        return "De " + inicio.format(BR) + " a " + fim.format(BR);
    }

    private static void enviar(HttpServletResponse response, byte[] conteudo, String arquivo, String formato) throws IOException {
        if ("xlsx".equals(formato)) {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + arquivo + ".xlsx\"");
        } else {
            response.setContentType("application/pdf");
            // inline: abre no próprio navegador, que já tem botão de baixar e imprimir
            response.setHeader("Content-Disposition", "inline; filename=\"" + arquivo + ".pdf\"");
        }
        response.setContentLength(conteudo.length);
        response.getOutputStream().write(conteudo);
    }

    private static void erro(HttpServletResponse response, int status, String mensagem) throws IOException {
        response.setStatus(status);
        // sem o charset, o acento da mensagem quebra
        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().println(mensagem);
    }
}
