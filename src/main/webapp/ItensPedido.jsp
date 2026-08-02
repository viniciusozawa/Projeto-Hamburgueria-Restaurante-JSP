<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Itens do Pedido #${pedidoAtual.codpedido} — Big Tites</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css">
</head>
<body>

<%@ include file="menu.jsp" %>

<c:set var="URL_CONTROLLER" value="${pageContext.request.contextPath}${URL_BASE}/PedidoController"/>

<div class="page-wrapper">

    <nav aria-label="Navegação" class="mb-3">
        <ol class="breadcrumb mb-0">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/index.jsp"><i class="fa-solid fa-house"></i></a>
            </li>
            <li class="breadcrumb-item"><a href="${URL_CONTROLLER}?opcao=listar">Pedidos</a></li>
            <li class="breadcrumb-item active" aria-current="page">Pedido #${pedidoAtual.codpedido}</li>
        </ol>
    </nav>

    <c:if test="${not empty mensagem}">
        <div class="alert alert-success d-flex align-items-center gap-2 border-0 shadow-sm" role="alert">
            <i class="fa-solid fa-circle-check"></i>
            <div>${mensagem}</div>
        </div>
    </c:if>

    <%-- ===== Cabeçalho do pedido ===== --%>
    <section class="pedido-hero mb-4">
        <div class="row align-items-center g-4">
            <div class="col-xl-5">
                <div class="d-flex align-items-center gap-3">
                    <span class="hero-hash">#${pedidoAtual.codpedido}</span>
                    <div>
                        <h1 class="hero-titulo">${pedidoAtual.clientePedido.nomeCliente}</h1>
                        <p class="hero-sublinha mb-0">
                            <i class="fa-regular fa-clock"></i>
                            Comanda aberta em ${pedidoAtual.datahoraFormatada}
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-xl-7">
                <div class="row g-2 g-md-3">
                    <div class="col-6 col-md-3">
                        <div class="hero-box">
                            <span><i class="fa-solid fa-chair"></i> Mesa</span>
                            <strong>${pedidoAtual.mesaPedido.numeroMesa}</strong>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="hero-box">
                            <span><i class="fa-solid fa-user-tie"></i> Atendente</span>
                            <strong>${pedidoAtual.funcionarioPedido.nomeFuncionario}</strong>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="hero-box">
                            <span><i class="fa-solid fa-basket-shopping"></i> Itens</span>
                            <strong>${pedidoAtual.qtdItens} un.</strong>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="hero-box destaque">
                            <span><i class="fa-solid fa-sack-dollar"></i> Total</span>
                            <strong>R$ <fmt:formatNumber value="${pedidoAtual.total}" pattern="#,##0.00"/></strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="row g-4">

        <%-- ===== Coluna: cadastrar novos itens ===== --%>
        <div class="col-xl-4">
            <div class="card shadow-sm h-100">
                <div class="card-header">
                    <i class="fa-solid fa-cart-plus"></i>
                    <h5>Adicionar item</h5>
                </div>
                <div class="card-body">
                    <form method="get" action="${URL_CONTROLLER}">
                        <input type="hidden" name="opcao" value="adicionarItem"/>
                        <input type="hidden" name="codpedido" value="${pedidoAtual.codpedido}"/>

                        <div class="mb-3">
                            <label for="codCardapio" class="form-label">
                                <i class="fa-solid fa-utensils me-1 text-secondary"></i>Produto do cardápio
                            </label>
                            <select class="form-select" id="codCardapio" name="codCardapio" required>
                                <c:forEach var="c" items="${cardapios}">
                                    <option value="${c.codCardapio}">
                                        ${c.nomeComida} — R$ <fmt:formatNumber value="${c.valorComida}" pattern="#,##0.00"/>
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="form-text">O preço unitário já está indicado ao lado de cada produto.</div>
                        </div>

                        <div class="mb-3">
                            <label for="quantidade" class="form-label">
                                <i class="fa-solid fa-hashtag me-1 text-secondary"></i>Quantidade
                            </label>
                            <div class="input-group campo-qtd">
                                <input type="number" class="form-control" id="quantidade" name="quantidade"
                                       min="1" step="1" value="1" required>
                                <span class="input-group-text">un.</span>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-adicionar w-100">
                            <i class="fa-solid fa-plus me-1"></i> Adicionar ao pedido
                        </button>
                    </form>
                </div>
                <div class="card-footer-dica">
                    <i class="fa-solid fa-lightbulb"></i>
                    Para lançar o mesmo produto em quantidade maior, use o campo de quantidade
                    em vez de adicionar várias vezes.
                </div>
            </div>
        </div>

        <%-- ===== Coluna: itens já lançados ===== --%>
        <div class="col-xl-8">
            <div class="card shadow-sm h-100">
                <div class="card-header">
                    <i class="fa-solid fa-receipt"></i>
                    <h5>Itens do cliente</h5>
                    <span class="badge-header ms-auto">
                        ${fn:length(itens)} ${fn:length(itens) == 1 ? 'produto' : 'produtos'}
                    </span>
                </div>

                <c:choose>
                    <c:when test="${empty itens}">
                        <div class="card-body">
                            <div class="itens-vazio">
                                <i class="fa-solid fa-utensils"></i>
                                <p class="mb-1">Nenhum item neste pedido ainda</p>
                                <small>Escolha um produto ao lado e clique em <b>Adicionar ao pedido</b>.</small>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-wrapper">
                            <table class="table tabela-itens align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Produto</th>
                                        <th class="text-center">Qtd.</th>
                                        <th class="text-end">Preço unit.</th>
                                        <th class="text-end">Subtotal</th>
                                        <th class="text-end">Ação</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="it" items="${itens}">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <span class="item-icone"><i class="fa-solid fa-burger"></i></span>
                                                    <div>
                                                        <div class="item-nome">${it.cardapioItem.nomeComida}</div>
                                                        <div class="item-meta">
                                                            <c:choose>
                                                                <c:when test="${not empty it.cardapioItem.categoriaCardapio.nomeCategoria}">
                                                                    ${it.cardapioItem.categoriaCardapio.nomeCategoria}
                                                                </c:when>
                                                                <c:otherwise>Sem categoria</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge-item">${it.quantidade}x</span>
                                            </td>
                                            <td class="text-end text-secondary">
                                                R$ <fmt:formatNumber value="${it.cardapioItem.valorComida}" pattern="#,##0.00"/>
                                            </td>
                                            <td class="text-end fw-bold">
                                                R$ <fmt:formatNumber value="${it.subtotal}" pattern="#,##0.00"/>
                                            </td>
                                            <td class="text-end">
                                                <form method="get" action="${URL_CONTROLLER}">
                                                    <input type="hidden" name="opcao" value="removerItem"/>
                                                    <input type="hidden" name="codpedido" value="${pedidoAtual.codpedido}"/>
                                                    <input type="hidden" name="codItem" value="${it.codPedidoPorCardapio}"/>
                                                    <button type="submit" class="btn btn-remover" title="Remover item">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="card-body pt-3">
                    <div class="resumo">
                        <div class="resumo-linha">
                            <span>Produtos diferentes</span>
                            <span>${fn:length(itens)}</span>
                        </div>
                        <div class="resumo-linha">
                            <span>Quantidade de itens</span>
                            <span>${pedidoAtual.qtdItens} un.</span>
                        </div>
                        <div class="resumo-total">
                            <span>Total do pedido</span>
                            <span>R$ <fmt:formatNumber value="${pedidoAtual.total}" pattern="#,##0.00"/></span>
                        </div>
                    </div>

                    <div class="d-flex flex-wrap gap-2 mt-3">
                        <a href="${URL_CONTROLLER}?opcao=listar" class="btn btn-voltar">
                            <i class="fa-solid fa-arrow-left me-1"></i> Voltar para os pedidos
                        </a>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<footer>
    <i class="fa-solid fa-burger me-1"></i>
    <span class="brand">Big Tites</span> &copy; 2024 &mdash; Sistema de Gerenciamento
</footer>

</body>
</html>
