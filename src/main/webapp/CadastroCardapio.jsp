<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session.getAttribute("gerente") == null) {
        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }
    String nomeGerente = (String) session.getAttribute("gerente");
    String URL_BASE = "/com/mycompany/restaurantehamburgueria/controller";
    String paginaAtiva = "cardapio";
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cardápio - Painel do Gerente</title>
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
                    <div class="topbar-title">Cardápio</div>
                    <div class="topbar-breadcrumb">
                        <i class="fa-solid fa-house fa-xs"></i>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <a href="${pageContext.request.contextPath}/gerente/dashboard.jsp">Dashboard</a>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <span>Cardápio</span>
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
                    <h5><i class="fa-solid fa-utensils"></i>
                        ${empty opcao || opcao == 'cadastrar' ? 'Novo Item' : 'Editar Item'}
                    </h5>
                </div>
                <div class="admin-card-body admin-form">
                    <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/CardapioController">
                        <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}" />
                        <input type="hidden" name="codCardapio" value="${empty codCardapio ? 0 : codCardapio}" />
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Nome do Prato</label>
                                <input type="text" class="form-control" name="nomeComida" value="${nomeComida}" required />
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Valor (R$)</label>
                                <input type="number" step="0.01" class="form-control" name="valorComida" value="${valorComida}" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Categoria</label>
                                <select class="form-select" name="categoria_codCategoria" required>
                                    <option value="">Selecione...</option>
                                    <c:forEach var="cat" items="${categorias}">
                                        <option value="${cat.codCategoria}">${cat.nomeCategoria}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Descrição</label>
                                <input type="text" class="form-control" name="descricaoComida" value="${descricaoComida}" />
                            </div>
                            <div class="col-auto d-flex gap-2 align-items-end">
                                <button type="submit" class="btn-admin-salvar">
                                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                                </button>
                                <a href="${pageContext.request.contextPath}<%= URL_BASE %>/CardapioController?opcao=cancelar"
                                   class="btn-admin-cancelar text-decoration-none">
                                    <i class="fa-solid fa-xmark"></i> Cancelar
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <c:if test="${not empty cardapios}">
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h5><i class="fa-solid fa-list"></i> Itens do Cardápio</h5>
                    </div>
                    <div class="admin-card-body p-0">
                        <div class="table-responsive">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Nome</th>
                                        <th>Categoria</th>
                                        <th>Valor</th>
                                        <th>Descrição</th>
                                        <th class="text-end">Ações</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${cardapios}">
                                        <tr>
                                            <td class="text-muted">${item.codCardapio}</td>
                                            <td><strong>${item.nomeComida}</strong></td>
                                            <td>${item.nomeCategoria}</td>
                                            <td>R$ ${item.valorComida}</td>
                                            <td class="text-muted" style="max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">${item.descricaoComida}</td>
                                            <td class="text-end actions-cell">
                                                <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/CardapioController" style="display:inline">
                                                    <input type="hidden" name="opcao" value="enviarAlterar" />
                                                    <input type="hidden" name="codCardapio" value="${item.codCardapio}" />
                                                    <input type="hidden" name="nomeComida" value="${item.nomeComida}" />
                                                    <input type="hidden" name="valorComida" value="${item.valorComida}" />
                                                    <input type="hidden" name="descricaoComida" value="${item.descricaoComida}" />
                                                    <input type="hidden" name="categoria_codCategoria" value="${item.categoria_codCategoria}" />
                                                    <button type="submit" class="btn-admin-alterar">
                                                        <i class="fa-solid fa-pen"></i> Alterar
                                                    </button>
                                                </form>
                                                <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/CardapioController" style="display:inline">
                                                    <input type="hidden" name="opcao" value="enviarExcluir" />
                                                    <input type="hidden" name="codCardapio" value="${item.codCardapio}" />
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
