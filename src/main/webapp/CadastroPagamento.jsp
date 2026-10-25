<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pagamento — Big Tites</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&family=Rubik:wght@400;500;600;700&family=Courier+Prime:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css?v=${VERSAO}">
</head>
<body>

<%@ include file="menu.jsp" %>

<div class="page-wrapper">

    <div class="card shadow-sm mb-4">
        <div class="card-header">
            <i class="fa-solid fa-credit-card"></i>
            <h4>Cadastro de Pagamento</h4>
        </div>
        <div class="card-body">
            <c:if test="${not empty mensagem}">
                <div class="mensagem"><i class="fa-solid fa-circle-check"></i> ${mensagem}</div>
            </c:if>

            <c:choose>
            <c:when test="${sessionScope.usuario.pode('PagamentoController', empty opcao ? 'cadastrar' : opcao)}">
            <form id="formCadastro" method="get"
                action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/PagamentoController">
                <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}"/>
                <input type="hidden" name="codPagamento" value="${empty codPagamento ? 0 : codPagamento}"/>
                <div class="row g-3">
                    <%-- Dois passos: o cliente e depois a comanda dele. O cliente
                         só filtra a lista (não tem name): quem vai para o banco é o
                         dono do pedido, que o controlador busca. Assim não dá para
                         pagar a comanda de um no nome de outro. Sem JavaScript, a
                         lista de comandas vem inteira, com o nome em cada uma. --%>
                    <div class="col-md-5">
                        <label class="form-label" for="campoCliente"><i class="fa-solid fa-user me-1 text-secondary"></i>1. Cliente</label>
                        <select class="form-select" id="campoCliente">
                            <option value="">Todos com comanda aberta</option>
                            <c:forEach var="cli" items="${clientesComComanda}">
                                <option value="${cli.codCliente}"><c:out value="${cli.nomeCliente}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-7">
                        <label class="form-label" for="campoPedido"><i class="fa-solid fa-receipt me-1 text-secondary"></i>2. Comanda</label>
                        <select class="form-select" name="codpedido" id="campoPedido" required>
                            <option value="">Escolha a comanda</option>
                            <c:forEach var="p" items="${pedidos}">
                                <c:if test="${(not p.finalizado and p.qtdItens > 0) or p.codpedido == codPedidoAtual}">
                                    <option value="${p.codpedido}"
                                            data-cliente="${p.clientePedido.codCliente}"
                                            data-total="${p.total}"
                                            data-falta="${p.falta}"
                                            data-itens="<c:out value='${p.resumoItens}'/>"
                                            <c:if test="${p.codpedido == codPedidoAtual}">selected</c:if>>
                                        #${p.codpedido} · <c:out value="${p.clientePedido.nomeCliente}"/> · Mesa ${p.mesaPedido.numeroMesa} · R$ <fmt:formatNumber value="${p.total}" pattern="#,##0.00"/>
                                    </option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <p class="campo-ajuda" id="ajudaComanda" hidden></p>
                    </div>

                    <%-- o que foi comprado, para conferir com o cliente antes de cobrar --%>
                    <div class="col-12">
                        <div class="conferir-pedido" id="conferirPedido" hidden>
                            <p class="conferir-titulo">O que foi pedido</p>
                            <p class="conferir-itens" id="conferirItens"></p>
                            <p class="conferir-total"><span>Total do pedido</span><b id="conferirTotal"></b></p>
                            <p class="conferir-falta" id="conferirFalta" hidden></p>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label" for="campoValor"><i class="fa-solid fa-money-bill me-1 text-secondary"></i>Valor Pago (R$)</label>
                        <input type="number" step="0.01" min="0.01" class="form-control" name="valorPago" id="campoValor" value="${valorPago}" placeholder="0,00" required/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-money-check me-1 text-secondary"></i>Forma de Pagamento</label>
                        <input type="text" class="form-control" name="formaPagamento" value="${formaPagamento}" placeholder="Ex: Pix, Cartão, Dinheiro..." list="formas" required/>
                        <datalist id="formas">
                            <option value="pix"></option>
                            <option value="dinheiro"></option>
                            <option value="cartão de crédito"></option>
                            <option value="cartão de débito"></option>
                        </datalist>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-calendar me-1 text-secondary"></i>Data do Pagamento</label>
                        <input type="date" class="form-control" name="dataPagamento" value="${dataPagamento}" required/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-circle-info me-1 text-secondary"></i>Status</label>
                        <input type="text" class="form-control" name="statusPagamento"
                               value="${empty opcao and empty statusPagamento ? 'pago' : statusPagamento}" placeholder="Ex: pago"/>
                    </div>
                </div>
            </form>
            <div class="btn-actions">
                <button type="submit" form="formCadastro" class="btn-salvar">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                </button>
                <a href="${pageContext.request.contextPath}${URL_BASE}/PagamentoController?opcao=listar" class="btn-cancelar">
                    <i class="fa-solid fa-ban"></i> Cancelar
                </a>
            </div>
            </c:when>
            <c:otherwise>
                <p class="somente-consulta"><i class="fa-solid fa-eye"></i> Seu perfil só consulta esta lista.</p>
            </c:otherwise>
            </c:choose>
        </div>
    </div>

    <c:if test="${not empty pagamentos}">
        <div class="caixa-resumo" role="group" aria-label="Resumo do caixa">
            <p><span>Pagamentos</span><b>${fn:length(pagamentos)}</b></p>
            <p class="caixa-total"><span>Total arrecadado</span><b>R$ <fmt:formatNumber value="${totalArrecadado}" pattern="#,##0.00"/></b></p>
        </div>

        <div class="card shadow-sm">
            <div class="card-header">
                <i class="fa-solid fa-list"></i>
                <h5>Pagamentos Cadastrados</h5>
                <span class="header-hint">o mais recente primeiro</span>
            </div>
            <div class="table-wrapper">
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Pedido</th>
                            <th>O que comprou</th>
                            <th>Total do pedido</th>
                            <th>Valor pago</th>
                            <th>Forma</th>
                            <th>Data</th>
                            <th>Cliente</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${pagamentos}">
                            <tr>
                                <td>${item.codPagamento}</td>
                                <td>
                                    <span class="cod-pedido">#${item.pedidoPagamento.codpedido}</span>
                                    <c:choose>
                                        <c:when test="${item.pedidoPagamento.finalizado}"><span class="selo selo-pago">pago</span></c:when>
                                        <c:otherwise><span class="selo selo-aberto">em aberto</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="resumo-itens"><c:out value="${item.pedidoPagamento.resumoItens}" default="—"/></td>
                                <td>R$ <fmt:formatNumber value="${item.pedidoPagamento.total}" pattern="#,##0.00"/></td>
                                <td class="valor-total">R$ <fmt:formatNumber value="${item.valorPago}" pattern="#,##0.00"/></td>
                                <td>${item.formaPagamento}</td>
                                <td>${item.dataFormatada}</td>
                                <td>${item.clientePagamento.nomeCliente}</td>
                                <td>
                                    <c:if test="${sessionScope.usuario.pode('PagamentoController', 'enviarAlterar')}">
                                    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/PagamentoController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarAlterar"/>
                                        <input type="hidden" name="codPagamento" value="${item.codPagamento}"/>
                                        <input type="hidden" name="formaPagamento" value="${item.formaPagamento}"/>
                                        <input type="hidden" name="valorPago" value="${item.valorPago}"/>
                                        <input type="hidden" name="dataPagamento" value="${item.dataPagamento}"/>
                                        <input type="hidden" name="statusPagamento" value="${item.statusPagamento}"/>
                                        <input type="hidden" name="codpedido" value="${item.pedidoPagamento.codpedido}"/>
                                        <button type="submit" class="btn-alterar"><i class="fa-solid fa-pencil"></i> Alterar</button>
                                    </form>
                                    </c:if>
                                    <c:if test="${sessionScope.usuario.pode('PagamentoController', 'enviarExcluir')}">
                                    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/PagamentoController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarExcluir"/>
                                        <input type="hidden" name="codPagamento" value="${item.codPagamento}"/>
                                        <input type="hidden" name="formaPagamento" value="${item.formaPagamento}"/>
                                        <input type="hidden" name="valorPago" value="${item.valorPago}"/>
                                        <input type="hidden" name="dataPagamento" value="${item.dataPagamento}"/>
                                        <input type="hidden" name="statusPagamento" value="${item.statusPagamento}"/>
                                        <input type="hidden" name="codpedido" value="${item.pedidoPagamento.codpedido}"/>
                                        <button type="submit" class="btn-excluir"><i class="fa-solid fa-trash"></i> Excluir</button>
                                    </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>

</div>

<footer>
    <i class="fa-solid fa-burger me-1"></i>
    <span class="brand">Big Tites</span> &mdash; painel de gerenciamento
</footer>

<script src="${pageContext.request.contextPath}/js/pagamento.js?v=${VERSAO}"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
