<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%-- Verificacao de sessao --%>
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
    <title>Dashboard - Painel do Gerente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/gerente.css">
</head>
<body>

<div class="d-flex">

    <!-- ===== SIDEBAR ===== -->
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
            <a href="${pageContext.request.contextPath}/gerente/dashboard.jsp" class="sidebar-link active">
                <i class="fa-solid fa-gauge nav-icon"></i> Dashboard
            </a>

            <div class="nav-section-title mt-2">Cadastros</div>
            <a href="${pageContext.request.contextPath}<%= URL_BASE %>/CargoController?opcao=listar" class="sidebar-link">
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

    <!-- ===== CONTEÚDO PRINCIPAL ===== -->
    <div class="admin-content">

        <!-- Topbar -->
        <div class="admin-topbar">
            <div class="topbar-left">
                <button id="sidebarToggle" onclick="toggleSidebar()">
                    <i class="fa-solid fa-bars"></i>
                </button>
                <div>
                    <div class="topbar-title">Dashboard</div>
                    <div class="topbar-breadcrumb">
                        <i class="fa-solid fa-house fa-xs"></i>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <span>Painel Principal</span>
                    </div>
                </div>
            </div>
            <div class="topbar-right">
                <span class="text-muted small d-none d-md-inline">
                    <i class="fa-regular fa-clock me-1"></i>
                    <span id="relogio"></span>
                </span>
                <div class="d-flex align-items-center gap-2">
                    <div class="rounded-circle bg-warning d-flex align-items-center justify-content-center"
                         style="width:34px;height:34px;color:#fff;font-size:0.85rem;">
                        <i class="fa-solid fa-user-tie"></i>
                    </div>
                    <span class="fw-semibold small d-none d-md-inline"><%= nomeGerente %></span>
                </div>
            </div>
        </div>

        <!-- Conteúdo -->
        <div class="admin-page">

            <!-- Boas-vindas -->
            <div class="mb-4">
                <h4 class="fw-semibold mb-1">Bem-vindo de volta, <%= nomeGerente %>! <span class="text-warning">&#x1F44B;</span></h4>
                <p class="text-muted small mb-0">Aqui está o resumo do sistema.</p>
            </div>

            <!-- Cards de módulos -->
            <div class="row g-3 mb-4">
                <div class="col-xl-2 col-md-4 col-6">
                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/CargoController?opcao=listar" class="stat-card">
                        <div class="stat-icon bg-orange">
                            <i class="fa-solid fa-id-badge"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-label">Módulo</div>
                            <div class="stat-title">Cargo</div>
                        </div>
                    </a>
                </div>
                <div class="col-xl-2 col-md-4 col-6">
                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/CategoriaController?opcao=listar" class="stat-card">
                        <div class="stat-icon bg-blue">
                            <i class="fa-solid fa-tags"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-label">Módulo</div>
                            <div class="stat-title">Categoria</div>
                        </div>
                    </a>
                </div>
                <div class="col-xl-2 col-md-4 col-6">
                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/ClienteController?opcao=listar" class="stat-card">
                        <div class="stat-icon bg-green">
                            <i class="fa-solid fa-users"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-label">Módulo</div>
                            <div class="stat-title">Clientes</div>
                        </div>
                    </a>
                </div>
                <div class="col-xl-2 col-md-4 col-6">
                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/FornecedorController?opcao=listar" class="stat-card">
                        <div class="stat-icon bg-purple">
                            <i class="fa-solid fa-truck"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-label">Módulo</div>
                            <div class="stat-title">Fornecedores</div>
                        </div>
                    </a>
                </div>
                <div class="col-xl-2 col-md-4 col-6">
                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/MesaController?opcao=listar" class="stat-card">
                        <div class="stat-icon bg-red">
                            <i class="fa-solid fa-chair"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-label">Módulo</div>
                            <div class="stat-title">Mesas</div>
                        </div>
                    </a>
                </div>
                <div class="col-xl-2 col-md-4 col-6">
                    <a href="${pageContext.request.contextPath}<%= URL_BASE %>/TurnosController?opcao=listar" class="stat-card">
                        <div class="stat-icon bg-teal">
                            <i class="fa-solid fa-clock"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-label">Módulo</div>
                            <div class="stat-title">Turnos</div>
                        </div>
                    </a>
                </div>
            </div>

            <!-- Acesso rápido -->
            <div class="admin-card">
                <div class="admin-card-header">
                    <h5><i class="fa-solid fa-bolt"></i> Acesso Rápido</h5>
                </div>
                <div class="admin-card-body">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}<%= URL_BASE %>/ClienteController?opcao=listar"
                               class="d-flex align-items-center gap-3 p-3 rounded-3 border text-decoration-none text-dark"
                               style="transition:all 0.2s" onmouseover="this.style.borderColor='#f39c12';this.style.background='#fffbf0'"
                               onmouseout="this.style.borderColor='';this.style.background=''">
                                <div class="stat-icon bg-green" style="width:40px;height:40px;border-radius:10px;font-size:1rem;">
                                    <i class="fa-solid fa-user-plus"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold small">Novo Cliente</div>
                                    <div class="text-muted" style="font-size:0.75rem">Cadastrar cliente</div>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}<%= URL_BASE %>/MesaController?opcao=listar"
                               class="d-flex align-items-center gap-3 p-3 rounded-3 border text-decoration-none text-dark"
                               style="transition:all 0.2s" onmouseover="this.style.borderColor='#f39c12';this.style.background='#fffbf0'"
                               onmouseout="this.style.borderColor='';this.style.background=''">
                                <div class="stat-icon bg-red" style="width:40px;height:40px;border-radius:10px;font-size:1rem;">
                                    <i class="fa-solid fa-chair"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold small">Gerenciar Mesas</div>
                                    <div class="text-muted" style="font-size:0.75rem">Ver todas as mesas</div>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/index.html" target="_blank"
                               class="d-flex align-items-center gap-3 p-3 rounded-3 border text-decoration-none text-dark"
                               style="transition:all 0.2s" onmouseover="this.style.borderColor='#f39c12';this.style.background='#fffbf0'"
                               onmouseout="this.style.borderColor='';this.style.background=''">
                                <div class="stat-icon bg-orange" style="width:40px;height:40px;border-radius:10px;font-size:1rem;">
                                    <i class="fa-solid fa-globe"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold small">Ver Site</div>
                                    <div class="text-muted" style="font-size:0.75rem">Tela do cliente</div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- Overlay (mobile) -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"
     style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:999;"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Relogio no topbar
    function atualizarRelogio() {
        const agora = new Date();
        document.getElementById('relogio').textContent = agora.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' });
    }
    atualizarRelogio();
    setInterval(atualizarRelogio, 60000);

    // Toggle sidebar (mobile)
    function toggleSidebar() {
        const sidebar  = document.getElementById('adminSidebar');
        const overlay  = document.getElementById('sidebarOverlay');
        const isOpen   = sidebar.classList.contains('show');
        sidebar.classList.toggle('show', !isOpen);
        overlay.style.display = isOpen ? 'none' : 'block';
    }
</script>
</body>
</html>
