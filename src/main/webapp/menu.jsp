<%-- Barra do painel. FRAGMENTO: quem inclui já traz <html>, <head> e as
     folhas de estilo, então aqui não vai documento nem diretiva de página.

     Os onze módulos não cabem numa linha só. Ficam à mostra os que se usa
     durante o serviço; o resto vai para o menu "Mais". --%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<nav class="navbar navbar-expand-lg navbar-dark px-4" id="mainNav">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/painel.jsp">
        <i class="fa-solid fa-burger" aria-hidden="true"></i>Big Tites
    </a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
            data-bs-target="#menuNav" aria-controls="menuNav" aria-expanded="false"
            aria-label="Abrir o menu do painel">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="menuNav">
        <ul class="navbar-nav ms-auto align-items-lg-center">
            <li class="nav-item px-1">
                <a class="nav-link" href="${pageContext.request.contextPath}/painel.jsp">
                    <i class="fa-solid fa-table-cells-large me-1" aria-hidden="true"></i>Painel
                </a>
            </li>
            <li class="nav-item px-1">
                <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/PedidoController?opcao=listar">
                    <i class="fa-solid fa-receipt me-1" aria-hidden="true"></i>Pedido
                </a>
            </li>
            <c:if test="${sessionScope.usuario.podeAtenderSalao}">
                <li class="nav-item px-1">
                <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/PagamentoController?opcao=listar">
                    <i class="fa-solid fa-credit-card me-1" aria-hidden="true"></i>Pagamento
                </a>
            </li>
            </c:if>
            <c:if test="${sessionScope.usuario.podeAtenderSalao}">
                <li class="nav-item px-1">
                <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/MesaController?opcao=listar">
                    <i class="fa-solid fa-chair me-1" aria-hidden="true"></i>Mesa
                </a>
            </li>
            </c:if>
            <li class="nav-item px-1">
                <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/CardapioController?opcao=listar">
                    <i class="fa-solid fa-utensils me-1" aria-hidden="true"></i>Cardápio
                </a>
            </li>

            <c:if test="${sessionScope.usuario.podeAdministrar}">
                <li class="nav-item dropdown px-1">
                <a class="nav-link dropdown-toggle" href="#" id="menuMais" role="button"
                   data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fa-solid fa-ellipsis me-1" aria-hidden="true"></i>Mais
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="menuMais">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}${URL_BASE}/CategoriaController?opcao=listar">
                        <i class="fa-solid fa-tags" aria-hidden="true"></i>Categoria</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}${URL_BASE}/IngredienteController?opcao=listar">
                        <i class="fa-solid fa-carrot" aria-hidden="true"></i>Ingrediente</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}${URL_BASE}/FornecedorController?opcao=listar">
                        <i class="fa-solid fa-truck" aria-hidden="true"></i>Fornecedor</a></li>
                    <li><div class="dropdown-divisor"></div></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}${URL_BASE}/FuncionarioController?opcao=listar">
                        <i class="fa-solid fa-user-tie" aria-hidden="true"></i>Funcionário</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}${URL_BASE}/CargoController?opcao=listar">
                        <i class="fa-solid fa-id-badge" aria-hidden="true"></i>Cargo</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}${URL_BASE}/TurnosController?opcao=listar">
                        <i class="fa-solid fa-clock" aria-hidden="true"></i>Turnos</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}${URL_BASE}/ClienteController?opcao=listar">
                        <i class="fa-solid fa-users" aria-hidden="true"></i>Cliente</a></li>
                </ul>
            </li>
            </c:if>

            <%-- o admin já alcança Ingrediente pelo menu "Mais" --%>
            <c:if test="${sessionScope.usuario.podeVerPreparo and not sessionScope.usuario.podeAdministrar}">
                <li class="nav-item px-1">
                    <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/IngredienteController?opcao=listar">
                        <i class="fa-solid fa-carrot me-1" aria-hidden="true"></i>Ingrediente
                    </a>
                </li>
            </c:if>

            <li class="nav-item">
                <span class="nav-quem">
                    <span class="inicial" aria-hidden="true"></span>
                    <span class="nome"><c:choose><c:when test="${not empty sessionScope.user}">${sessionScope.user}</c:when><c:otherwise>Balcão</c:otherwise></c:choose></span>
                    <c:if test="${not empty sessionScope.usuario}"><span class="nav-cargo">${sessionScope.usuario.perfil.rotulo}</span></c:if>
                </span>
            </li>
            <li class="nav-item px-1">
                <a class="nav-link nav-sair" href="${pageContext.request.contextPath}${URL_BASE}/LoginControlador?opcao=sair">
                    <i class="fa-solid fa-right-from-bracket me-1" aria-hidden="true"></i>Sair
                </a>
            </li>
        </ul>
    </div>
</nav>

<script>
    /* Marca a tela atual. "Painel" e "Sair" ficam de fora: um é destino fixo,
       o outro é ação. Quando o item ativo está dentro de "Mais", o próprio
       "Mais" é marcado, senão o usuário não vê onde está. */
    document.addEventListener('DOMContentLoaded', function () {
        var url = window.location.href;

        /* Inicial do nome sai daqui e não da EL, pra não precisar da taglib fn. */
        var quem = document.querySelector('.nav-quem .nome');
        var ini  = document.querySelector('.nav-quem .inicial');
        if (quem && ini) ini.textContent = quem.textContent.trim().charAt(0).toUpperCase();

        function combina(link) {
            var alvo = (link.getAttribute('href') || '').split('/').pop().split('?')[0];
            return alvo && alvo !== 'painel.jsp' && alvo !== '#' && url.indexOf(alvo) !== -1;
        }

        document.querySelectorAll('#mainNav .navbar-nav > .nav-item > .nav-link').forEach(function (link) {
            if (!link.classList.contains('nav-sair') && combina(link)) link.classList.add('active');
        });

        var dentro = Array.prototype.some.call(
            document.querySelectorAll('#mainNav .dropdown-item'), combina);
        if (dentro) document.getElementById('menuMais').classList.add('active');
    });
</script>
