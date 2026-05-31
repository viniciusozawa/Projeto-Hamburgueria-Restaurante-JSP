<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session.getAttribute("gerente") == null) {
        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }
    String nomeGerente = (String) session.getAttribute("gerente");
    String URL_BASE = "/com/mycompany/restaurantehamburgueria/controller";
    String paginaAtiva = "relatorio";
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Relatórios - Painel do Gerente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/gerente.css">
</head>
<body>
<div class="d-flex">

    <%@ include file="gerente/sidebar.jsp" %>

    <div class="admin-content">
        <div class="admin-topbar">
            <div class="topbar-left">
                <button id="sidebarToggle" onclick="toggleSidebar()"><i class="fa-solid fa-bars"></i></button>
                <div>
                    <div class="topbar-title">Relatórios</div>
                    <div class="topbar-breadcrumb">
                        <i class="fa-solid fa-house fa-xs"></i>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <a href="${pageContext.request.contextPath}/gerente/dashboard.jsp">Dashboard</a>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <span>Relatórios</span>
                    </div>
                </div>
            </div>
            <div class="topbar-right">
                <div class="d-flex align-items-center gap-2">
                    <div class="rounded-circle bg-warning d-flex align-items-center justify-content-center"
                         style="width:34px;height:34px;color:#fff;font-size:0.85rem;">
                        <i class="fa-solid fa-user-tie"></i>
                    </div>
                    <span class="fw-semibold small d-none d-md-inline"><%= nomeGerente %></span>
                </div>
            </div>
        </div>

        <div class="admin-page">

            <!-- Seleção do Relatório -->
            <div class="admin-card mb-4">
                <div class="admin-card-header">
                    <h5><i class="fa-solid fa-chart-bar"></i> Selecionar Relatório</h5>
                </div>
                <div class="admin-card-body">
                    <div class="row g-3">

                        <!-- Cardápio -->
                        <div class="col-md-4">
                            <div class="p-3 border rounded-3" style="border-color:#edf0f2!important;">
                                <div class="fw-semibold mb-2"><i class="fa-solid fa-utensils text-warning me-2"></i>Relatório Cardápio</div>
                                <div class="d-flex flex-column gap-2">
                                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/RelatorioController?tipo=cardapio&opcao=1"
                                       class="btn-relatorio ${tipoAtivo == 'cardapio' && opcaoAtiva == 1 ? 'ativo' : ''}">
                                        <i class="fa-solid fa-sort-alpha-down fa-xs"></i> Ordem Alfabética
                                    </a>
                                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/RelatorioController?tipo=cardapio&opcao=2"
                                       class="btn-relatorio ${tipoAtivo == 'cardapio' && opcaoAtiva == 2 ? 'ativo' : ''}">
                                        <i class="fa-solid fa-tag fa-xs"></i> Por Faixa de Preço
                                    </a>
                                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/RelatorioController?tipo=cardapio&opcao=3"
                                       class="btn-relatorio ${tipoAtivo == 'cardapio' && opcaoAtiva == 3 ? 'ativo' : ''}">
                                        <i class="fa-solid fa-arrow-trend-up fa-xs"></i> Mais Vendidos
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Clientes -->
                        <div class="col-md-4">
                            <div class="p-3 border rounded-3" style="border-color:#edf0f2!important;">
                                <div class="fw-semibold mb-2"><i class="fa-solid fa-users text-warning me-2"></i>Relatório Clientes</div>
                                <div class="d-flex flex-column gap-2">
                                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/RelatorioController?tipo=clientes&opcao=1"
                                       class="btn-relatorio ${tipoAtivo == 'clientes' && opcaoAtiva == 1 ? 'ativo' : ''}">
                                        <i class="fa-solid fa-sort-alpha-down fa-xs"></i> A-Z
                                    </a>
                                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/RelatorioController?tipo=clientes&opcao=2"
                                       class="btn-relatorio ${tipoAtivo == 'clientes' && opcaoAtiva == 2 ? 'ativo' : ''}">
                                        <i class="fa-solid fa-sort-alpha-down-alt fa-xs"></i> Z-A
                                    </a>
                                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/RelatorioController?tipo=clientes&opcao=3"
                                       class="btn-relatorio ${tipoAtivo == 'clientes' && opcaoAtiva == 3 ? 'ativo' : ''}">
                                        <i class="fa-solid fa-calendar fa-xs"></i> Por Data Cadastro (ASC)
                                    </a>
                                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/RelatorioController?tipo=clientes&opcao=4"
                                       class="btn-relatorio ${tipoAtivo == 'clientes' && opcaoAtiva == 4 ? 'ativo' : ''}">
                                        <i class="fa-solid fa-calendar fa-xs"></i> Por Data Cadastro (DESC)
                                    </a>
                                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/RelatorioController?tipo=clientes&opcao=5"
                                       class="btn-relatorio ${tipoAtivo == 'clientes' && opcaoAtiva == 5 ? 'ativo' : ''}">
                                        <i class="fa-solid fa-receipt fa-xs"></i> Com Pedidos
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Funcionários -->
                        <div class="col-md-4">
                            <div class="p-3 border rounded-3" style="border-color:#edf0f2!important;">
                                <div class="fw-semibold mb-2"><i class="fa-solid fa-user-gear text-warning me-2"></i>Relatório Funcionários</div>
                                <div class="d-flex flex-column gap-2">
                                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/RelatorioController?tipo=funcionario&opcao=1"
                                       class="btn-relatorio ${tipoAtivo == 'funcionario' && opcaoAtiva == 1 ? 'ativo' : ''}">
                                        <i class="fa-solid fa-list fa-xs"></i> Completo (Cargo + Turno)
                                    </a>
                                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/RelatorioController?tipo=funcionario&opcao=2"
                                       class="btn-relatorio ${tipoAtivo == 'funcionario' && opcaoAtiva == 2 ? 'ativo' : ''}">
                                        <i class="fa-solid fa-money-bill fa-xs"></i> Por Faixa Salarial
                                    </a>
                                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/RelatorioController?tipo=funcionario&opcao=3"
                                       class="btn-relatorio ${tipoAtivo == 'funcionario' && opcaoAtiva == 3 ? 'ativo' : ''}">
                                        <i class="fa-solid fa-star fa-xs"></i> Por Qtd de Pedidos
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Resultado do Relatório -->
            <c:if test="${not empty erro}">
                <div class="admin-mensagem" style="border-left-color:#e74c3c;color:#e74c3c;background:rgba(231,76,60,0.08)">
                    <i class="fa-solid fa-circle-exclamation"></i> ${erro}
                </div>
            </c:if>

            <c:if test="${not empty colunas}">
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h5><i class="fa-solid fa-table"></i> ${titulo}</h5>
                        <span class="badge" style="background:rgba(243,156,18,0.15);color:#f39c12;font-size:0.8rem;padding:0.4rem 0.8rem;border-radius:20px;">
                            ${linhas.size()} registros
                        </span>
                    </div>
                    <div class="admin-card-body p-0">
                        <div class="table-responsive">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <c:forEach var="col" items="${colunas}">
                                            <th>${col}</th>
                                        </c:forEach>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="linha" items="${linhas}">
                                        <tr>
                                            <c:forEach var="col" items="${colunas}">
                                                <td>${linha[col]}</td>
                                            </c:forEach>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>

        </div>
    </div>
</div>

<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"
     style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:999;"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleSidebar() {
        const sidebar = document.getElementById('adminSidebar');
        const overlay = document.getElementById('sidebarOverlay');
        const isOpen  = sidebar.classList.contains('show');
        sidebar.classList.toggle('show', !isOpen);
        overlay.style.display = isOpen ? 'none' : 'block';
    }
</script>
</body>
</html>
