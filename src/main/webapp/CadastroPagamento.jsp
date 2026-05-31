<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session.getAttribute("gerente") == null) {
        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }
    String nomeGerente = (String) session.getAttribute("gerente");
    String URL_BASE = "/com/mycompany/restaurantehamburgueria/controller";
    String paginaAtiva = "pagamento";
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pagamentos - Painel do Gerente</title>
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
                    <div class="topbar-title">Pagamentos</div>
                    <div class="topbar-breadcrumb">
                        <i class="fa-solid fa-house fa-xs"></i>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <a href="${pageContext.request.contextPath}/gerente/dashboard.jsp">Dashboard</a>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <span>Pagamentos</span>
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
                    <h5><i class="fa-solid fa-money-bill-wave"></i>
                        ${opcao == 'confirmarAlterar' ? 'Alterar Pagamento' : 'Registrar Pagamento'}
                    </h5>
                </div>
                <div class="admin-card-body admin-form">
                    <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/PagamentoController">
                        <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}" />
                        <input type="hidden" name="codPagamento" value="${empty codPagamento ? 0 : codPagamento}" />
                        <div class="row g-3 align-items-end">
                            <div class="col-md-3">
                                <label class="form-label">Pedido</label>
                                <select class="form-select" name="pedido_codpedido" required>
                                    <option value="">Selecione...</option>
                                    <c:forEach var="p" items="${pedidos}">
                                        <option value="${p.codpedido}">#${p.codpedido} - ${p.nomeCliente}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Forma de Pagamento</label>
                                <select class="form-select" name="formaPagamento" required>
                                    <option value="dinheiro" ${formaPagamento == 'dinheiro' ? 'selected' : ''}>Dinheiro</option>
                                    <option value="pix" ${formaPagamento == 'pix' ? 'selected' : ''}>PIX</option>
                                    <option value="cartao_credito" ${formaPagamento == 'cartao_credito' ? 'selected' : ''}>Cartão Crédito</option>
                                    <option value="cartao_debito" ${formaPagamento == 'cartao_debito' ? 'selected' : ''}>Cartão Débito</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Status</label>
                                <select class="form-select" name="statusPagamento">
                                    <option value="andamento" ${statusPagamento == 'andamento' ? 'selected' : ''}>Em andamento</option>
                                    <option value="pago" ${statusPagamento == 'pago' ? 'selected' : ''}>Pago</option>
                                    <option value="cancelado" ${statusPagamento == 'cancelado' ? 'selected' : ''}>Cancelado</option>
                                </select>
                            </div>
                            <div class="col-auto d-flex gap-2">
                                <button type="submit" class="btn-admin-salvar">
                                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                                </button>
                                <a href="${pageContext.request.contextPath}<%= URL_BASE %>/PagamentoController?opcao=cancelar"
                                   class="btn-admin-cancelar text-decoration-none">
                                    <i class="fa-solid fa-xmark"></i> Cancelar
                                </a>
                            </div>
                        </div>
                        <small class="text-muted mt-2 d-block">
                            <i class="fa-solid fa-circle-info me-1"></i>
                            O valor total é calculado automaticamente a partir dos itens do pedido (trigger do banco).
                        </small>
                    </form>
                </div>
            </div>

            <c:if test="${not empty pagamentos}">
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h5><i class="fa-solid fa-list"></i> Pagamentos Registrados</h5>
                    </div>
                    <div class="admin-card-body p-0">
                        <div class="table-responsive">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Pedido</th>
                                        <th>Cliente</th>
                                        <th>Forma</th>
                                        <th>Valor</th>
                                        <th>Data</th>
                                        <th>Status</th>
                                        <th class="text-end">Ações</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${pagamentos}">
                                        <tr>
                                            <td class="text-muted">${item.codPagamento}</td>
                                            <td>#${item.pedido_codpedido}</td>
                                            <td>${item.nomeCliente}</td>
                                            <td>${item.formaPagamento}</td>
                                            <td><strong>R$ ${item.valorPago}</strong></td>
                                            <td>${item.dataPagamento}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.statusPagamento == 'pago'}">
                                                        <span class="badge-status" style="background:rgba(46,204,113,0.1);color:#2ecc71;">Pago</span>
                                                    </c:when>
                                                    <c:when test="${item.statusPagamento == 'cancelado'}">
                                                        <span class="badge-status" style="background:rgba(231,76,60,0.1);color:#e74c3c;">Cancelado</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status" style="background:rgba(243,156,18,0.1);color:#f39c12;">Em andamento</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end actions-cell">
                                                <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/PagamentoController" style="display:inline">
                                                    <input type="hidden" name="opcao" value="enviarAlterar" />
                                                    <input type="hidden" name="codPagamento" value="${item.codPagamento}" />
                                                    <input type="hidden" name="formaPagamento" value="${item.formaPagamento}" />
                                                    <input type="hidden" name="statusPagamento" value="${item.statusPagamento}" />
                                                    <button type="submit" class="btn-admin-alterar">
                                                        <i class="fa-solid fa-pen"></i> Alterar
                                                    </button>
                                                </form>
                                                <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/PagamentoController" style="display:inline">
                                                    <input type="hidden" name="opcao" value="enviarExcluir" />
                                                    <input type="hidden" name="codPagamento" value="${item.codPagamento}" />
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
