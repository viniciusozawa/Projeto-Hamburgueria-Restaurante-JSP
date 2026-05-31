<%-- Sidebar reutilizável - requer: nomeGerente e URL_BASE no escopo da página pai --%>
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
        <a href="${pageContext.request.contextPath}/gerente/dashboard.jsp" class="sidebar-link <%= "dashboard".equals(paginaAtiva) ? "active" : "" %>">
            <i class="fa-solid fa-gauge nav-icon"></i> Dashboard
        </a>
        <div class="nav-section-title mt-2">Operacional</div>
        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/PedidoController?opcao=listar" class="sidebar-link <%= "pedido".equals(paginaAtiva) ? "active" : "" %>">
            <i class="fa-solid fa-receipt nav-icon"></i> Pedidos
        </a>
        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/PagamentoController?opcao=listar" class="sidebar-link <%= "pagamento".equals(paginaAtiva) ? "active" : "" %>">
            <i class="fa-solid fa-money-bill-wave nav-icon"></i> Pagamentos
        </a>
        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/FeedbackController?opcao=listar" class="sidebar-link <%= "feedback".equals(paginaAtiva) ? "active" : "" %>">
            <i class="fa-solid fa-star nav-icon"></i> Feedbacks
        </a>
        <div class="nav-section-title mt-2">Cadastros</div>
        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/FuncionarioController?opcao=listar" class="sidebar-link <%= "funcionario".equals(paginaAtiva) ? "active" : "" %>">
            <i class="fa-solid fa-user-gear nav-icon"></i> Funcionários
        </a>
        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/CardapioController?opcao=listar" class="sidebar-link <%= "cardapio".equals(paginaAtiva) ? "active" : "" %>">
            <i class="fa-solid fa-utensils nav-icon"></i> Cardápio
        </a>
        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/IngredienteController?opcao=listar" class="sidebar-link <%= "ingrediente".equals(paginaAtiva) ? "active" : "" %>">
            <i class="fa-solid fa-seedling nav-icon"></i> Ingredientes
        </a>
        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/CargoController?opcao=listar" class="sidebar-link <%= "cargo".equals(paginaAtiva) ? "active" : "" %>">
            <i class="fa-solid fa-id-badge nav-icon"></i> Cargo
        </a>
        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/CategoriaController?opcao=listar" class="sidebar-link <%= "categoria".equals(paginaAtiva) ? "active" : "" %>">
            <i class="fa-solid fa-tags nav-icon"></i> Categoria
        </a>
        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/ClienteController?opcao=listar" class="sidebar-link <%= "cliente".equals(paginaAtiva) ? "active" : "" %>">
            <i class="fa-solid fa-users nav-icon"></i> Clientes
        </a>
        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/FornecedorController?opcao=listar" class="sidebar-link <%= "fornecedor".equals(paginaAtiva) ? "active" : "" %>">
            <i class="fa-solid fa-truck nav-icon"></i> Fornecedores
        </a>
        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/MesaController?opcao=listar" class="sidebar-link <%= "mesa".equals(paginaAtiva) ? "active" : "" %>">
            <i class="fa-solid fa-chair nav-icon"></i> Mesas
        </a>
        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/TurnosController?opcao=listar" class="sidebar-link <%= "turno".equals(paginaAtiva) ? "active" : "" %>">
            <i class="fa-solid fa-clock nav-icon"></i> Turnos
        </a>
        <div class="nav-section-title mt-2">Relatórios</div>
        <a href="${pageContext.request.contextPath}<%= URL_BASE %>/RelatorioController?tipo=cardapio" class="sidebar-link <%= "relatorio".equals(paginaAtiva) ? "active" : "" %>">
            <i class="fa-solid fa-chart-bar nav-icon"></i> Relatórios
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
