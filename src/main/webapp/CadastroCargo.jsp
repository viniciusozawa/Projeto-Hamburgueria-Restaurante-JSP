<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session.getAttribute("gerente") == null) {
        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }
    String nomeGerente = (String) session.getAttribute("gerente");
    String URL_BASE = "/com/mycompany/restaurantehamburgueria/controller";
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cargo - Painel do Gerente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/gerente.css">
</head>
<body>
<div class="d-flex">

    <!-- SIDEBAR -->
    <nav class="admin-sidebar" id="adminSidebar">
        <div class="sidebar-brand">
            <div class="brand-icon"><i class="fa-solid fa-burger"></i></div>
            <div>
                <div class="brand-name">Hamburgueria</div>
                <div class="brand-sub">Painel Administrativo</div>
            </div>
        </div>
        <div class="sidebar-user">
            <div class="user-avatar"><i class="fa-solid fa-user-tie fa-sm"></i></div>
            <div>
                <div class="user-name"><%= nomeGerente %></div>
                <div class="user-role">Gerente</div>
            </div>
        </div>
        <div class="sidebar-nav">
            <div class="nav-section-title">Principal</div>
            <a href="${pageContext.request.contextPath}/gerente/dashboard.jsp" class="sidebar-link">
                <i class="fa-solid fa-gauge nav-icon"></i> Dashboard
            </a>
            <div class="nav-section-title mt-2">Cadastros</div>
            <a href="${pageContext.request.contextPath}<%= URL_BASE %>/CargoController?opcao=listar" class="sidebar-link active">
                <i class="fa-solid fa-id-badge nav-icon"></i> Cargo
            </a>
            <a href="${pageContext.request.contextPath}<%= URL_BASE %>/CategoriaController?opcao=listar" class="sidebar-link">
                <i class="fa-solid fa-tags nav-icon"></i> Categoria
            </a>
            <a href="${pageContext.request.contextPath}<%= URL_BASE %>/ClienteController?opcao=listar" class="sidebar-link">
                <i class="fa-solid fa-users nav-icon"></i> Clientes
            </a>
            <a href="${pageContext.request.contextPath}<%= URL_BASE %>/FornecedorController?opcao=listar" class="sidebar-link">
                <i class="fa-solid fa-truck nav-icon"></i> Fornecedores
            </a>
            <a href="${pageContext.request.contextPath}<%= URL_BASE %>/MesaController?opcao=listar" class="sidebar-link">
                <i class="fa-solid fa-chair nav-icon"></i> Mesas
            </a>
            <a href="${pageContext.request.contextPath}<%= URL_BASE %>/TurnosController?opcao=listar" class="sidebar-link">
                <i class="fa-solid fa-clock nav-icon"></i> Turnos
            </a>
            <div class="nav-section-title mt-2">Site</div>
            <a href="${pageContext.request.contextPath}/index.html" class="sidebar-link" target="_blank">
                <i class="fa-solid fa-globe nav-icon"></i> Ver Site
                <i class="fa-solid fa-arrow-up-right-from-square fa-xs ms-auto opacity-50"></i>
            </a>
        </div>
        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}<%= URL_BASE %>/LogoutController" class="btn-logout">
                <i class="fa-solid fa-right-from-bracket fa-sm"></i> Sair
            </a>
        </div>
    </nav>

    <!-- CONTEÚDO -->
    <div class="admin-content">
        <div class="admin-topbar">
            <div class="topbar-left">
                <button id="sidebarToggle" onclick="toggleSidebar()"><i class="fa-solid fa-bars"></i></button>
                <div>
                    <div class="topbar-title">Cargo</div>
                    <div class="topbar-breadcrumb">
                        <i class="fa-solid fa-house fa-xs"></i>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <a href="${pageContext.request.contextPath}/gerente/dashboard.jsp">Dashboard</a>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <span>Cargo</span>
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

            <!-- Mensagem -->
            <c:if test="${not empty mensagem}">
                <div class="admin-mensagem">
                    <i class="fa-solid fa-circle-check"></i> ${mensagem}
                </div>
            </c:if>

            <!-- Formulário -->
            <div class="admin-card mb-4">
                <div class="admin-card-header">
                    <h5><i class="fa-solid fa-id-badge"></i>
                        ${empty opcao || opcao == 'cadastrar' ? 'Novo Cargo' : opcao == 'enviarAlterar' ? 'Alterar Cargo' : 'Excluir Cargo'}
                    </h5>
                </div>
                <div class="admin-card-body admin-form">
                    <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/CargoController">
                        <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}" />
                        <input type="hidden" name="codCargo" value="${empty codCargo ? 0 : codCargo}" />
                        <div class="row g-3 align-items-end">
                            <div class="col-md-6">
                                <label class="form-label">Nome do Cargo</label>
                                <input type="text" class="form-control" name="nomeCargo"
                                       value="${nomeCargo}" placeholder="Ex: Atendente, Cozinheiro..." required />
                            </div>
                            <div class="col-auto d-flex gap-2">
                                <button type="submit" class="btn-admin-salvar">
                                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                                </button>
                                <a href="${pageContext.request.contextPath}<%= URL_BASE %>/CargoController?opcao=cancelar"
                                   class="btn-admin-cancelar text-decoration-none">
                                    <i class="fa-solid fa-xmark"></i> Cancelar
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Tabela -->
            <c:if test="${not empty cargos}">
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h5><i class="fa-solid fa-list"></i> Cargos Cadastrados</h5>
                        <span class="badge" style="background:rgba(243,156,18,0.15);color:#f39c12;font-size:0.8rem;padding:0.4rem 0.8rem;border-radius:20px;">
                            Cargos
                        </span>
                    </div>
                    <div class="admin-card-body p-0">
                        <div class="table-responsive">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Nome do Cargo</th>
                                        <th class="text-end">Ações</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${cargos}">
                                        <tr>
                                            <td class="text-muted">${item.codCargo}</td>
                                            <td><strong>${item.nomeCargo}</strong></td>
                                            <td class="text-end actions-cell">
                                                <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/CargoController" style="display:inline">
                                                    <input type="hidden" name="opcao" value="enviarAlterar" />
                                                    <input type="hidden" name="codCargo" value="${item.codCargo}" />
                                                    <input type="hidden" name="nomeCargo" value="${item.nomeCargo}" />
                                                    <button type="submit" class="btn-admin-alterar">
                                                        <i class="fa-solid fa-pen"></i> Alterar
                                                    </button>
                                                </form>
                                                <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/CargoController" style="display:inline">
                                                    <input type="hidden" name="opcao" value="enviarExcluir" />
                                                    <input type="hidden" name="codCargo" value="${item.codCargo}" />
                                                    <input type="hidden" name="nomeCargo" value="${item.nomeCargo}" />
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
