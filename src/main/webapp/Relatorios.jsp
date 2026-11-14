<%-- Central de relatórios. Chega por forward do RelatorioController (opcao
     vazia ou "listar"), que entrega ${relatorios}: o catálogo de
     relatorio/Relatorio.java. Um cartão por relatório, separados pela
     abordagem que o professor pediu (1 = JasperReports, 3 = Apache POI).

     Cada cartão é um <form> próprio que abre o arquivo em outra aba
     (target="_blank"), para esta tela continuar aberta. O período do topo
     vale para todos: o js/relatorios.js copia as datas para o cartão no
     momento do envio. Sem JavaScript o relatório sai com todo o período. --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<c:set var="acao" value="${pageContext.request.contextPath}${URL_BASE}/RelatorioController"/>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Relatórios — Big Tites</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&family=Rubik:wght@400;500;600;700&family=Courier+Prime:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css?v=${VERSAO}">
</head>
<body>

<%@ include file="menu.jsp" %>

<div class="page-wrapper">

    <%-- ===== Período: vale para todos os cartões com "Período" ===== --%>
    <div class="card shadow-sm mb-4">
        <div class="card-header">
            <i class="fa-solid fa-chart-line"></i>
            <h4>Relatórios</h4>
            <span class="header-hint">PDF abre em outra aba · Excel baixa a planilha</span>
        </div>
        <div class="card-body">
            <p class="rel-intro">
                Cada relatório responde a uma pergunta do dia a dia da hamburgueria e ajuda a tomar uma decisão.
                Escolha o período uma vez aqui: ele vale para todos os relatórios marcados com
                <span class="rel-filtro"><i class="fa-regular fa-calendar"></i> período</span>.
            </p>

            <div class="row g-3 align-items-end" id="periodo">
                <div class="col-sm-6 col-md-3">
                    <label class="form-label" for="dataInicio">De</label>
                    <input type="date" class="form-control" id="dataInicio">
                </div>
                <div class="col-sm-6 col-md-3">
                    <label class="form-label" for="dataFim">Até</label>
                    <input type="date" class="form-control" id="dataFim">
                </div>
                <div class="col-md-6">
                    <div class="rel-atalhos" role="group" aria-label="Atalhos de período">
                        <button type="button" class="btn-alterar" data-periodo="tudo">Todo o período</button>
                        <button type="button" class="btn-alterar" data-periodo="mes">Este mês</button>
                        <button type="button" class="btn-alterar" data-periodo="mes-passado">Mês passado</button>
                        <button type="button" class="btn-alterar" data-periodo="30">Últimos 30 dias</button>
                    </div>
                </div>
            </div>
            <p class="rel-aviso" id="avisoPeriodo" role="alert" hidden></p>
        </div>
    </div>

    <%-- ===== Os cartões, um bloco por abordagem ===== --%>
    <c:forEach var="bloco" items="${['JASPER', 'POI']}">
    <section class="bloco mb-4">
        <h2 class="bloco-nome">
            <c:choose>
                <c:when test="${bloco eq 'JASPER'}">Abordagem 1 · JasperReports</c:when>
                <c:otherwise>Abordagem 3 · Apache POI (Excel)</c:otherwise>
            </c:choose>
        </h2>
        <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-3">
        <c:forEach var="r" items="${relatorios}">
        <c:if test="${r.abordagem eq bloco}">
            <div class="col">
            <article class="rel-card ${r.pronto ? '' : 'rel-em-breve'}">
                <header class="rel-topo">
                    <span class="rel-num">Nº <c:if test="${r.numero lt 10}">0</c:if>${r.numero}</span>
                    <i class="fa-solid ${r.icone} rel-icone" aria-hidden="true"></i>
                </header>
                <h3 class="rel-titulo">${r.titulo}</h3>
                <p class="rel-pergunta">${r.pergunta}</p>
                <p class="rel-decisao"><b>Decisão:</b> ${r.decisao}</p>

                <c:choose>
                <c:when test="${r.pronto}">
                <form class="rel-form" method="get" action="${acao}" target="_blank" data-filtro="${r.filtro}">
                    <input type="hidden" name="opcao" value="${r.chave}">
                    <c:choose>
                        <c:when test="${r.filtro eq 'PERIODO'}">
                            <input type="hidden" name="dataInicio">
                            <input type="hidden" name="dataFim">
                            <span class="rel-filtro"><i class="fa-regular fa-calendar"></i> período</span>
                        </c:when>
                        <c:when test="${r.filtro eq 'PEDIDO'}">
                            <label class="rel-pedido">
                                <span>Pedido nº</span>
                                <input type="number" name="codPedido" min="1" class="form-control form-control-sm" required>
                            </label>
                        </c:when>
                        <c:otherwise>
                            <span class="rel-filtro"><i class="fa-regular fa-clock"></i> situação de agora</span>
                        </c:otherwise>
                    </c:choose>

                    <div class="rel-botoes">
                        <c:if test="${r.temPdf}">
                            <button type="submit" name="formato" value="pdf" class="btn-salvar btn-sm-rel">
                                <i class="fa-solid fa-file-pdf"></i> PDF
                            </button>
                        </c:if>
                        <button type="submit" name="formato" value="xlsx" class="btn-cancelar btn-sm-rel">
                            <i class="fa-solid fa-file-excel"></i> Excel
                        </button>
                    </div>
                </form>
                </c:when>
                <c:otherwise>
                    <p class="rel-breve"><i class="fa-solid fa-hourglass-half"></i> Em breve</p>
                </c:otherwise>
                </c:choose>
            </article>
            </div>
        </c:if>
        </c:forEach>
        </div>
    </section>
    </c:forEach>

</div>

<footer>
    <i class="fa-solid fa-burger me-1"></i>
    <span class="brand">Big Tites</span> &mdash; painel de gerenciamento
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/relatorios.js?v=${VERSAO}"></script>
</body>
</html>
