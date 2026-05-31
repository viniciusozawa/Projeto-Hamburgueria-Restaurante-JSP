<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session.getAttribute("gerente") == null) {
        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }
    String nomeGerente = (String) session.getAttribute("gerente");
    String URL_BASE = "/com/mycompany/restaurantehamburgueria/controller";
    String paginaAtiva = "feedback";
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedbacks - Painel do Gerente</title>
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
                    <div class="topbar-title">Feedbacks</div>
                    <div class="topbar-breadcrumb">
                        <i class="fa-solid fa-house fa-xs"></i>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <a href="${pageContext.request.contextPath}/gerente/dashboard.jsp">Dashboard</a>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <span>Feedbacks</span>
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
                    <h5><i class="fa-solid fa-star"></i>
                        ${opcao == 'confirmarAlterar' ? 'Alterar Feedback' : 'Novo Feedback'}
                    </h5>
                </div>
                <div class="admin-card-body admin-form">
                    <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/FeedbackController">
                        <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}" />
                        <input type="hidden" name="codFeedback" value="${empty codFeedback ? 0 : codFeedback}" />
                        <div class="row g-3 align-items-end">
                            <div class="col-md-3">
                                <label class="form-label">Cliente</label>
                                <select class="form-select" name="cliente_codCliente" required>
                                    <option value="">Selecione...</option>
                                    <c:forEach var="c" items="${clientes}">
                                        <option value="${c.codCliente}">${c.nomeCliente}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Nota (1-10)</label>
                                <input type="number" min="1" max="10" class="form-control" name="nota" value="${nota}" required />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Descrição</label>
                                <input type="text" class="form-control" name="descricao" value="${descricao}" />
                            </div>
                            <div class="col-auto d-flex gap-2">
                                <button type="submit" class="btn-admin-salvar">
                                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                                </button>
                                <a href="${pageContext.request.contextPath}<%= URL_BASE %>/FeedbackController?opcao=cancelar"
                                   class="btn-admin-cancelar text-decoration-none">
                                    <i class="fa-solid fa-xmark"></i> Cancelar
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <c:if test="${not empty feedbacks}">
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h5><i class="fa-solid fa-list"></i> Feedbacks Recebidos</h5>
                    </div>
                    <div class="admin-card-body p-0">
                        <div class="table-responsive">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Cliente</th>
                                        <th>Nota</th>
                                        <th>Descrição</th>
                                        <th>Data</th>
                                        <th class="text-end">Ações</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${feedbacks}">
                                        <tr>
                                            <td class="text-muted">${item.codFeedback}</td>
                                            <td><strong>${item.nomeCliente}</strong></td>
                                            <td>
                                                <span class="fw-bold" style="color:${item.nota >= 7 ? '#2ecc71' : item.nota >= 5 ? '#f39c12' : '#e74c3c'}">
                                                    ${item.nota}/10
                                                </span>
                                            </td>
                                            <td>${item.descricao}</td>
                                            <td>${item.dataFeedback}</td>
                                            <td class="text-end actions-cell">
                                                <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/FeedbackController" style="display:inline">
                                                    <input type="hidden" name="opcao" value="enviarAlterar" />
                                                    <input type="hidden" name="codFeedback" value="${item.codFeedback}" />
                                                    <input type="hidden" name="nota" value="${item.nota}" />
                                                    <input type="hidden" name="descricao" value="${item.descricao}" />
                                                    <input type="hidden" name="cliente_codCliente" value="${item.cliente_codCliente}" />
                                                    <button type="submit" class="btn-admin-alterar">
                                                        <i class="fa-solid fa-pen"></i> Alterar
                                                    </button>
                                                </form>
                                                <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/FeedbackController" style="display:inline">
                                                    <input type="hidden" name="opcao" value="enviarExcluir" />
                                                    <input type="hidden" name="codFeedback" value="${item.codFeedback}" />
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
