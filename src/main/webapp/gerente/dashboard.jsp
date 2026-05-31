<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session.getAttribute("gerente") == null) {
        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }
    String nomeGerente = (String) session.getAttribute("gerente");
    String URL_BASE = "/com/mycompany/restaurantehamburgueria/controller";
    String paginaAtiva = "dashboard";
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

    <%@ include file="sidebar.jsp" %>

    <div class="admin-content">
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

        <div class="admin-page">

            <!-- Boas-vindas -->
            <div class="mb-4" style="overflow:hidden;">
                <h4 class="fw-semibold mb-1" style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                    Bem-vindo de volta, <%= nomeGerente %>!
                </h4>
                <p class="text-muted small mb-0">Aqui está o resumo do sistema.</p>
            </div>

            <!-- Estatísticas reais do banco -->
            <c:if test="${not empty stats}">
                <div class="row g-3 mb-4">
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/PedidoController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-orange"><i class="fa-solid fa-receipt"></i></div>
                            <div class="stat-info">
                                <div class="stat-label">Pedidos</div>
                                <div class="stat-title">${stats.pedidos}</div>
                            </div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/PagamentoController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-green"><i class="fa-solid fa-money-bill-wave"></i></div>
                            <div class="stat-info">
                                <div class="stat-label">Pagamentos</div>
                                <div class="stat-title">${stats.pagamentos}</div>
                            </div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/ClienteController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-blue"><i class="fa-solid fa-users"></i></div>
                            <div class="stat-info">
                                <div class="stat-label">Clientes</div>
                                <div class="stat-title">${stats.clientes}</div>
                            </div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/FuncionarioController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-purple"><i class="fa-solid fa-user-gear"></i></div>
                            <div class="stat-info">
                                <div class="stat-label">Funcionários</div>
                                <div class="stat-title">${stats.funcionarios}</div>
                            </div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/CardapioController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-teal"><i class="fa-solid fa-utensils"></i></div>
                            <div class="stat-info">
                                <div class="stat-label">Cardápio</div>
                                <div class="stat-title">${stats.cardapios}</div>
                            </div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/FeedbackController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-red"><i class="fa-solid fa-star"></i></div>
                            <div class="stat-info">
                                <div class="stat-label">Feedbacks</div>
                                <div class="stat-title">${stats.feedbacks}</div>
                            </div>
                        </a>
                    </div>
                </div>

                <!-- Segunda linha de stats -->
                <div class="row g-3 mb-4">
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/IngredienteController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-orange"><i class="fa-solid fa-seedling"></i></div>
                            <div class="stat-info">
                                <div class="stat-label">Ingredientes</div>
                                <div class="stat-title">${stats.ingredientes}</div>
                            </div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/MesaController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-red"><i class="fa-solid fa-chair"></i></div>
                            <div class="stat-info">
                                <div class="stat-label">Mesas</div>
                                <div class="stat-title">${stats.mesas}</div>
                            </div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/FornecedorController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-blue"><i class="fa-solid fa-truck"></i></div>
                            <div class="stat-info">
                                <div class="stat-label">Fornecedores</div>
                                <div class="stat-title">${stats.fornecedores}</div>
                            </div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/CargoController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-purple"><i class="fa-solid fa-id-badge"></i></div>
                            <div class="stat-info">
                                <div class="stat-label">Cargos</div>
                                <div class="stat-title">${stats.cargos}</div>
                            </div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/TurnosController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-teal"><i class="fa-solid fa-clock"></i></div>
                            <div class="stat-info">
                                <div class="stat-label">Turnos</div>
                                <div class="stat-title">${stats.turnos}</div>
                            </div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/CategoriaController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-green"><i class="fa-solid fa-tags"></i></div>
                            <div class="stat-info">
                                <div class="stat-label">Categorias</div>
                                <div class="stat-title">${stats.categorias}</div>
                            </div>
                        </a>
                    </div>
                </div>
            </c:if>

            <!-- Cards sem stats (dashboard direto, sem DashboardController) -->
            <c:if test="${empty stats}">
                <div class="row g-3 mb-4">
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/PedidoController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-orange"><i class="fa-solid fa-receipt"></i></div>
                            <div class="stat-info"><div class="stat-label">Módulo</div><div class="stat-title">Pedidos</div></div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/PagamentoController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-green"><i class="fa-solid fa-money-bill-wave"></i></div>
                            <div class="stat-info"><div class="stat-label">Módulo</div><div class="stat-title">Pagamentos</div></div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/ClienteController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-blue"><i class="fa-solid fa-users"></i></div>
                            <div class="stat-info"><div class="stat-label">Módulo</div><div class="stat-title">Clientes</div></div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/FuncionarioController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-purple"><i class="fa-solid fa-user-gear"></i></div>
                            <div class="stat-info"><div class="stat-label">Módulo</div><div class="stat-title">Funcionários</div></div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/CardapioController?opcao=listar" class="stat-card">
                            <div class="stat-icon bg-teal"><i class="fa-solid fa-utensils"></i></div>
                            <div class="stat-info"><div class="stat-label">Módulo</div><div class="stat-title">Cardápio</div></div>
                        </a>
                    </div>
                    <div class="col-xl-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/RelatorioController" class="stat-card">
                            <div class="stat-icon bg-red"><i class="fa-solid fa-chart-bar"></i></div>
                            <div class="stat-info"><div class="stat-label">Módulo</div><div class="stat-title">Relatórios</div></div>
                        </a>
                    </div>
                </div>
            </c:if>

            <!-- Acesso rápido -->
            <div class="admin-card">
                <div class="admin-card-header">
                    <h5><i class="fa-solid fa-bolt"></i> Acesso Rápido</h5>
                </div>
                <div class="admin-card-body">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}<%= URL_BASE %>/PedidoController?opcao=listar"
                               class="d-flex align-items-center gap-3 p-3 rounded-3 border text-decoration-none text-dark"
                               style="transition:all 0.2s" onmouseover="this.style.borderColor='#f39c12';this.style.background='#fffbf0'"
                               onmouseout="this.style.borderColor='';this.style.background=''">
                                <div class="stat-icon bg-orange" style="width:40px;height:40px;border-radius:10px;font-size:1rem;">
                                    <i class="fa-solid fa-receipt"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold small">Novo Pedido</div>
                                    <div class="text-muted" style="font-size:0.75rem">Registrar pedido</div>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}<%= URL_BASE %>/PagamentoController?opcao=listar"
                               class="d-flex align-items-center gap-3 p-3 rounded-3 border text-decoration-none text-dark"
                               style="transition:all 0.2s" onmouseover="this.style.borderColor='#f39c12';this.style.background='#fffbf0'"
                               onmouseout="this.style.borderColor='';this.style.background=''">
                                <div class="stat-icon bg-green" style="width:40px;height:40px;border-radius:10px;font-size:1rem;">
                                    <i class="fa-solid fa-money-bill-wave"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold small">Pagamento</div>
                                    <div class="text-muted" style="font-size:0.75rem">Registrar pagamento</div>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}<%= URL_BASE %>/RelatorioController?tipo=cardapio&opcao=3"
                               class="d-flex align-items-center gap-3 p-3 rounded-3 border text-decoration-none text-dark"
                               style="transition:all 0.2s" onmouseover="this.style.borderColor='#f39c12';this.style.background='#fffbf0'"
                               onmouseout="this.style.borderColor='';this.style.background=''">
                                <div class="stat-icon bg-purple" style="width:40px;height:40px;border-radius:10px;font-size:1rem;">
                                    <i class="fa-solid fa-chart-bar"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold small">+ Vendidos</div>
                                    <div class="text-muted" style="font-size:0.75rem">Relatório cardápio</div>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/index.html" target="_blank"
                               class="d-flex align-items-center gap-3 p-3 rounded-3 border text-decoration-none text-dark"
                               style="transition:all 0.2s" onmouseover="this.style.borderColor='#f39c12';this.style.background='#fffbf0'"
                               onmouseout="this.style.borderColor='';this.style.background=''">
                                <div class="stat-icon bg-teal" style="width:40px;height:40px;border-radius:10px;font-size:1rem;">
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

<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"
     style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:999;"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function atualizarRelogio() {
        const agora = new Date();
        document.getElementById('relogio').textContent = agora.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' });
    }
    atualizarRelogio();
    setInterval(atualizarRelogio, 60000);

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
