<%--
    Painel de gerenciamento — fica atrás do login.
    Era o antigo index.jsp; a home agora é a vitrine pública.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>
<%-- As comandas de hoje, para o trilho do topo. Bean e não controlador
     porque o painel é aberto por /painel.jsp em vários lugares. --%>
<jsp:useBean id="servico" class="com.mycompany.restaurantehamburgueria.service.ResumoDoServico" scope="request"/>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Painel — Big Tites</title>
    <meta name="robots" content="noindex">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&family=Rubik:wght@400;500;600;700&family=Courier+Prime:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css?v=${VERSAO}">
</head>
<body>

<%@include file="menu.jsp" %>

<div class="faixa-painel">
    <div class="interno">
        <div>
            <p class="etiqueta">Big Tites · <c:out value="${sessionScope.usuario.perfil.rotulo}" default="balcão"/></p>
            <h1>Bom serviço<c:if test="${not empty sessionScope.user}">, ${sessionScope.user}</c:if></h1>
        </div>
        <p class="data" id="dataHoje"></p>
    </div>
</div>

<%-- ===== TRILHO DE COMANDAS =====
     A barra onde a cozinha pendura os pedidos. Mostra os de hoje, o mais
     novo primeiro; cada comanda abre os itens do pedido. --%>
<c:set var="comandas" value="${servico.comandasDeHoje}"/>
<section class="trilho" aria-labelledby="tituloTrilho">
    <div class="trilho-interno">
        <div class="trilho-cabeca">
            <h2 class="bloco-nome" id="tituloTrilho">Comandas em aberto</h2>
            <c:if test="${not empty comandas}">
                <p class="trilho-resumo">
                    ${fn:length(comandas)} ${fn:length(comandas) == 1 ? 'comanda' : 'comandas'} de hoje,
                    R$ <fmt:formatNumber value="${servico.totalDeHoje}" pattern="#,##0.00"/> a receber
                </p>
            </c:if>
        </div>

        <div class="trilho-barra" aria-hidden="true"></div>

        <c:choose>
            <c:when test="${empty comandas}">
                <div class="trilho-vazio">
                    <p>Nenhuma comanda em aberto hoje. Quando o salão lançar um pedido, ele aparece aqui até ser pago.</p>
                    <c:if test="${sessionScope.usuario.pode('PedidoController', 'cadastrar')}">
                        <a class="btn-salvar" href="${pageContext.request.contextPath}${URL_BASE}/PedidoController?opcao=listar">
                            <i class="fa-solid fa-receipt" aria-hidden="true"></i> Abrir uma comanda
                        </a>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <ul class="trilho-comandas">
                    <c:forEach var="p" items="${comandas}">
                        <li>
                            <a class="trilho-comanda"
                               href="${pageContext.request.contextPath}${URL_BASE}/PedidoController?opcao=abrirItens&codpedido=${p.codpedido}"
                               aria-label="Pedido ${p.codpedido}, mesa ${p.mesaPedido.numeroMesa}, ${p.qtdItens} itens. Abrir os itens">
                                <span class="comanda-meta"><b>#${p.codpedido}</b><span>${p.horaPedido}</span></span>
                                <span class="trilho-mesa">Mesa ${p.mesaPedido.numeroMesa}</span>
                                <span class="trilho-itens">
                                    <c:choose>
                                        <c:when test="${p.qtdItens == 0}">sem itens ainda</c:when>
                                        <c:when test="${p.qtdItens == 1}">1 item</c:when>
                                        <c:otherwise>${p.qtdItens} itens</c:otherwise>
                                    </c:choose>
                                </span>
                                <span class="comanda-total">
                                    <span>TOTAL</span>
                                    <span>R$ <fmt:formatNumber value="${p.total}" pattern="#,##0.00"/></span>
                                </span>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<section class="modules-section">

    <c:if test="${sessionScope.usuario.podeAtenderSalao}">
    <div class="bloco">
        <h2 class="bloco-nome">No serviço</h2>
        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-3">
            <div class="col">
                <a class="module-card" href="${pageContext.request.contextPath}${URL_BASE}/PedidoController?opcao=listar">
                    <i class="fa-solid fa-receipt mod-icon" aria-hidden="true"></i>
                    <span class="mod-texto">
                        <span class="mod-name">Pedido</span>
                        <span class="mod-desc">Comandas abertas e itens</span>
                    </span>
                </a>
            </div>
            <div class="col">
                <a class="module-card" href="${pageContext.request.contextPath}${URL_BASE}/PagamentoController?opcao=listar">
                    <i class="fa-solid fa-credit-card mod-icon" aria-hidden="true"></i>
                    <span class="mod-texto">
                        <span class="mod-name">Pagamento</span>
                        <span class="mod-desc">Fechar conta e formas</span>
                    </span>
                </a>
            </div>
            <div class="col">
                <a class="module-card" href="${pageContext.request.contextPath}${URL_BASE}/MesaController?opcao=listar">
                    <i class="fa-solid fa-chair mod-icon" aria-hidden="true"></i>
                    <span class="mod-texto">
                        <span class="mod-name">Mesa</span>
                        <span class="mod-desc">Salão e numeração</span>
                    </span>
                </a>
            </div>
        </div>
    </div>
    </c:if>

    <div class="bloco">
        <h2 class="bloco-nome">Cozinha e estoque</h2>
        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-4 g-3">
            <div class="col">
                <a class="module-card" href="${pageContext.request.contextPath}${URL_BASE}/CardapioController?opcao=listar">
                    <i class="fa-solid fa-utensils mod-icon" aria-hidden="true"></i>
                    <span class="mod-texto">
                        <span class="mod-name">Cardápio</span>
                        <span class="mod-desc">Itens e preços</span>
                    </span>
                </a>
            </div>
            <c:if test="${sessionScope.usuario.podeAdministrar}">
            <div class="col">
                <a class="module-card" href="${pageContext.request.contextPath}${URL_BASE}/CategoriaController?opcao=listar">
                    <i class="fa-solid fa-tags mod-icon" aria-hidden="true"></i>
                    <span class="mod-texto">
                        <span class="mod-name">Categoria</span>
                        <span class="mod-desc">Como o cardápio é dividido</span>
                    </span>
                </a>
            </div>
            </c:if>
            <div class="col">
                <a class="module-card" href="${pageContext.request.contextPath}${URL_BASE}/IngredienteController?opcao=listar">
                    <i class="fa-solid fa-carrot mod-icon" aria-hidden="true"></i>
                    <span class="mod-texto">
                        <span class="mod-name">Ingrediente</span>
                        <span class="mod-desc">Estoque e validade</span>
                    </span>
                </a>
            </div>
            <c:if test="${sessionScope.usuario.podeAdministrar}">
            <div class="col">
                <a class="module-card" href="${pageContext.request.contextPath}${URL_BASE}/FornecedorController?opcao=listar">
                    <i class="fa-solid fa-truck mod-icon" aria-hidden="true"></i>
                    <span class="mod-texto">
                        <span class="mod-name">Fornecedor</span>
                        <span class="mod-desc">Quem entrega o quê</span>
                    </span>
                </a>
            </div>
            </c:if>
        </div>
    </div>

    <c:if test="${sessionScope.usuario.podeAdministrar}">
    <div class="bloco">
        <h2 class="bloco-nome">Gente</h2>
        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-4 g-3">
            <div class="col">
                <a class="module-card" href="${pageContext.request.contextPath}${URL_BASE}/FuncionarioController?opcao=listar">
                    <i class="fa-solid fa-user-tie mod-icon" aria-hidden="true"></i>
                    <span class="mod-texto">
                        <span class="mod-name">Funcionário</span>
                        <span class="mod-desc">Equipe da casa</span>
                    </span>
                </a>
            </div>
            <div class="col">
                <a class="module-card" href="${pageContext.request.contextPath}${URL_BASE}/CargoController?opcao=listar">
                    <i class="fa-solid fa-id-badge mod-icon" aria-hidden="true"></i>
                    <span class="mod-texto">
                        <span class="mod-name">Cargo</span>
                        <span class="mod-desc">Função de cada um</span>
                    </span>
                </a>
            </div>
            <div class="col">
                <a class="module-card" href="${pageContext.request.contextPath}${URL_BASE}/TurnosController?opcao=listar">
                    <i class="fa-solid fa-clock mod-icon" aria-hidden="true"></i>
                    <span class="mod-texto">
                        <span class="mod-name">Turnos</span>
                        <span class="mod-desc">Horários de trabalho</span>
                    </span>
                </a>
            </div>
            <div class="col">
                <a class="module-card" href="${pageContext.request.contextPath}${URL_BASE}/ClienteController?opcao=listar">
                    <i class="fa-solid fa-users mod-icon" aria-hidden="true"></i>
                    <span class="mod-texto">
                        <span class="mod-name">Cliente</span>
                        <span class="mod-desc">Contas cadastradas</span>
                    </span>
                </a>
            </div>
        </div>
    </div>
    </c:if>

</section>

<footer>
    <span class="brand">Big Tites</span> &mdash; painel de gerenciamento
</footer>

<script>
    /* Data de hoje por extenso, sem depender da taglib de formatação. */
    document.getElementById('dataHoje').textContent =
        new Date().toLocaleDateString('pt-BR', {
            weekday: 'long', day: 'numeric', month: 'long'
        });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
