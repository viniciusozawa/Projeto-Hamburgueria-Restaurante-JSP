<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session.getAttribute("gerente") == null) {
        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }
    String nomeGerente = (String) session.getAttribute("gerente");
    String URL_BASE = "/com/mycompany/restaurantehamburgueria/controller";
    String paginaAtiva = "ingrediente";
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ingredientes - Painel do Gerente</title>
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
                    <div class="topbar-title">Ingredientes</div>
                    <div class="topbar-breadcrumb">
                        <i class="fa-solid fa-house fa-xs"></i>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <a href="${pageContext.request.contextPath}/gerente/dashboard.jsp">Dashboard</a>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <span>Ingredientes</span>
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
            <c:if test="${not empty mensagem}">
                <div class="admin-mensagem">
                    <i class="fa-solid fa-circle-check"></i> ${mensagem}
                </div>
            </c:if>

            <div class="admin-card mb-4">
                <div class="admin-card-header">
                    <h5><i class="fa-solid fa-seedling"></i>
                        ${empty opcao || opcao == 'cadastrar' ? 'Novo Ingrediente' : 'Editar Ingrediente'}
                    </h5>
                </div>
                <div class="admin-card-body admin-form">
                    <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/IngredienteController">
                        <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}" />
                        <input type="hidden" name="codIngrediente" value="${empty codIngrediente ? 0 : codIngrediente}" />
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Nome</label>
                                <input type="text" class="form-control" name="nomeIngredientes" value="${nomeIngredientes}" required />
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Quantidade</label>
                                <input type="number" step="0.01" class="form-control" name="quantiIngredientes" value="${quantiIngredientes}" required />
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Valor (R$)</label>
                                <input type="number" step="0.01" class="form-control" name="valorIngrediente" value="${valorIngrediente}" required />
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Data Produção</label>
                                <input type="date" class="form-control" name="dataProducao" value="${dataProducao}" required />
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Data Vencimento</label>
                                <input type="date" class="form-control" name="dataVencimento" value="${dataVencimento}" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Fornecedor</label>
                                <select class="form-select" name="fornecedores_codFornecedor" required>
                                    <option value="">Selecione...</option>
                                    <c:forEach var="f" items="${fornecedores}">
                                        <option value="${f.codFornecedor}">${f.nomeFornecedor}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Descrição</label>
                                <input type="text" class="form-control" name="descricaoIngrediente" value="${descricaoIngrediente}" />
                            </div>
                            <div class="col-auto d-flex gap-2 align-items-end">
                                <button type="submit" class="btn-admin-salvar">
                                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                                </button>
                                <a href="${pageContext.request.contextPath}<%= URL_BASE %>/IngredienteController?opcao=cancelar"
                                   class="btn-admin-cancelar text-decoration-none">
                                    <i class="fa-solid fa-xmark"></i> Cancelar
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <c:if test="${not empty ingredientes}">
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h5><i class="fa-solid fa-list"></i> Estoque de Ingredientes</h5>
                    </div>
                    <div class="admin-card-body p-0">
                        <div class="table-responsive">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Nome</th>
                                        <th>Qtd</th>
                                        <th>Valor</th>
                                        <th>Vencimento</th>
                                        <th>Fornecedor</th>
                                        <th class="text-end">Ações</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${ingredientes}">
                                        <tr>
                                            <td class="text-muted">${item.codIngrediente}</td>
                                            <td><strong>${item.nomeIngredientes}</strong></td>
                                            <td>${item.quantiIngredientes}</td>
                                            <td>R$ ${item.valorIngrediente}</td>
                                            <td>${item.dataVencimento}</td>
                                            <td>${item.nomeFornecedor}</td>
                                            <td class="text-end actions-cell">
                                                <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/IngredienteController" style="display:inline">
                                                    <input type="hidden" name="opcao" value="enviarAlterar" />
                                                    <input type="hidden" name="codIngrediente" value="${item.codIngrediente}" />
                                                    <input type="hidden" name="nomeIngredientes" value="${item.nomeIngredientes}" />
                                                    <input type="hidden" name="quantiIngredientes" value="${item.quantiIngredientes}" />
                                                    <input type="hidden" name="valorIngrediente" value="${item.valorIngrediente}" />
                                                    <input type="hidden" name="dataProducao" value="${item.dataProducao}" />
                                                    <input type="hidden" name="dataVencimento" value="${item.dataVencimento}" />
                                                    <input type="hidden" name="descricaoIngrediente" value="${item.descricaoIngrediente}" />
                                                    <input type="hidden" name="fornecedores_codFornecedor" value="${item.fornecedores_codFornecedor}" />
                                                    <button type="submit" class="btn-admin-alterar">
                                                        <i class="fa-solid fa-pen"></i> Alterar
                                                    </button>
                                                </form>
                                                <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/IngredienteController" style="display:inline">
                                                    <input type="hidden" name="opcao" value="enviarExcluir" />
                                                    <input type="hidden" name="codIngrediente" value="${item.codIngrediente}" />
                                                    <button type="submit" class="btn-admin-excluir">
                                                        <i class="fa-solid fa-trash"></i> Excluir
                                                    </button>
                                                </form>
                                            </td>
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
