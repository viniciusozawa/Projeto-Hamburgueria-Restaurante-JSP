<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pedido — Big Tites</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&family=Rubik:wght@400;500;600;700&family=Courier+Prime:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css?v=${VERSAO}">
</head>
<body>

<%@ include file="menu.jsp" %>

<c:set var="URL_CONTROLLER" value="${pageContext.request.contextPath}${URL_BASE}/PedidoController"/>

<div class="page-wrapper">

    <div class="card shadow-sm mb-4">
        <div class="card-header">
            <i class="fa-solid fa-receipt"></i>
            <h4>Cadastro de Pedido</h4>
        </div>
        <div class="card-body">
            <c:if test="${not empty mensagem}">
                <div class="mensagem"><i class="fa-solid fa-circle-check"></i> ${mensagem}</div>
            </c:if>

            <c:choose>
            <c:when test="${sessionScope.usuario.pode('PedidoController', empty opcao ? 'cadastrar' : opcao)}">
            <form id="formCadastro" method="get" action="${URL_CONTROLLER}">
                <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}"/>
                <input type="hidden" name="codpedido" value="${empty codpedido ? 0 : codpedido}"/>
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label"><i class="fa-solid fa-user me-1 text-secondary"></i>Cliente</label>
                        <select class="form-select" name="codCliente" required>
                            <c:forEach var="cli" items="${clientes}">
                                <option value="${cli.codCliente}" <c:if test="${cli.codCliente == codClienteAtual}">selected</c:if>>
                                    ${cli.nomeCliente}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><i class="fa-solid fa-chair me-1 text-secondary"></i>Mesa</label>
                        <select class="form-select" name="codMesa" required>
                            <c:forEach var="m" items="${mesas}">
                                <option value="${m.codMesa}" <c:if test="${m.codMesa == codMesaAtual}">selected</c:if>>
                                    Mesa ${m.numeroMesa} — ${m.localMesa}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><i class="fa-solid fa-user-tie me-1 text-secondary"></i>Funcionário</label>
                        <select class="form-select" name="codFuncionario" required>
                            <c:forEach var="f" items="${funcionarios}">
                                <option value="${f.codFuncionario}" <c:if test="${f.codFuncionario == codFuncionarioAtual}">selected</c:if>>
                                    ${f.nomeFuncionario}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </form>

            <div class="btn-actions">
                <button type="submit" form="formCadastro" class="btn-salvar">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                </button>
                <a href="${URL_CONTROLLER}?opcao=listar" class="btn-cancelar">
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

    <%-- Caixa do dia a dia: nada é apagado ao dar baixa. O pedido pago só
         passa de "Em aberto" para "Finalizados". --%>
    <div class="caixa-resumo" role="group" aria-label="Resumo dos pedidos">
        <p><span>Em aberto</span><b>${fn:length(pedidosAbertos)}</b></p>
        <p><span>Finalizados</span><b>${fn:length(pedidosFinalizados)}</b></p>
        <p class="caixa-total"><span>Total arrecadado</span><b>R$ <fmt:formatNumber value="${totalArrecadado}" pattern="#,##0.00"/></b></p>
    </div>

    <div class="card shadow-sm mb-4">
        <div class="card-header">
            <i class="fa-solid fa-clock"></i>
            <h5>Em aberto</h5>
            <span class="header-hint"><i class="fa-solid fa-circle-info"></i> pago o total, o pedido vai para <b>Finalizados</b></span>
        </div>
        <c:choose>
            <c:when test="${empty pedidosAbertos}">
                <p class="lista-vazia">Nenhum pedido em aberto. Os pedidos novos aparecem aqui até serem pagos.</p>
            </c:when>
            <c:otherwise>
            <div class="table-wrapper">
                <table class="table tabela-pedidos">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Cliente</th>
                            <th>Mesa</th>
                            <th>Funcionário</th>
                            <th>Data/Hora</th>
                            <th>Itens</th>
                            <th>Total</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${pedidosAbertos}">
                            <tr>
                                <td><span class="cod-pedido">#${item.codpedido}</span></td>
                                <td>${item.clientePedido.nomeCliente}</td>
                                <td>Mesa ${item.mesaPedido.numeroMesa}</td>
                                <td>${item.funcionarioPedido.nomeFuncionario}</td>
                                <td>${item.datahoraFormatada}</td>
                                <td>
                                    <span class="badge-qtd ${item.qtdItens == 0 ? 'vazio' : ''}">${item.qtdItens} un.</span>
                                </td>
                                <td class="valor-total">
                                    R$ <fmt:formatNumber value="${item.total}" pattern="#,##0.00"/>
                                    <c:if test="${item.valorRecebido > 0}">
                                        <small class="falta">falta R$ <fmt:formatNumber value="${item.falta}" pattern="#,##0.00"/></small>
                                    </c:if>
                                </td>
                                <td>
                                    <div class="acoes">
                                        <a href="${URL_CONTROLLER}?opcao=abrirItens&codpedido=${item.codpedido}" class="btn-itens">
                                            <i class="fa-solid fa-burger"></i> Itens
                                        </a>
                                        <c:if test="${item.qtdItens > 0 and sessionScope.usuario.pode('PagamentoController', 'cadastrar')}">
                                            <a href="${pageContext.request.contextPath}${URL_BASE}/PagamentoController?opcao=listar&codpedido=${item.codpedido}" class="btn-receber">
                                                <i class="fa-solid fa-cash-register"></i> Receber
                                            </a>
                                        </c:if>
                                        <c:if test="${sessionScope.usuario.pode('PedidoController', 'enviarAlterar')}">
                                        <form method="get" action="${URL_CONTROLLER}" style="display:inline">
                                            <input type="hidden" name="opcao" value="enviarAlterar"/>
                                            <input type="hidden" name="codpedido" value="${item.codpedido}"/>
                                            <input type="hidden" name="codCliente" value="${item.clientePedido.codCliente}"/>
                                            <input type="hidden" name="codMesa" value="${item.mesaPedido.codMesa}"/>
                                            <input type="hidden" name="codFuncionario" value="${item.funcionarioPedido.codFuncionario}"/>
                                            <button type="submit" class="btn-alterar"><i class="fa-solid fa-pencil"></i> Alterar</button>
                                        </form>
                                        </c:if>
                                        <c:if test="${sessionScope.usuario.pode('PedidoController', 'enviarExcluir')}">
                                        <form method="get" action="${URL_CONTROLLER}" style="display:inline">
                                            <input type="hidden" name="opcao" value="enviarExcluir"/>
                                            <input type="hidden" name="codpedido" value="${item.codpedido}"/>
                                            <input type="hidden" name="codCliente" value="${item.clientePedido.codCliente}"/>
                                            <input type="hidden" name="codMesa" value="${item.mesaPedido.codMesa}"/>
                                            <input type="hidden" name="codFuncionario" value="${item.funcionarioPedido.codFuncionario}"/>
                                            <button type="submit" class="btn-excluir"><i class="fa-solid fa-trash"></i> Excluir</button>
                                        </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            </c:otherwise>
        </c:choose>
    </div>

    <c:if test="${not empty pedidosFinalizados}">
        <%-- Recolhido: é o histórico, não o serviço de agora. Abre com um clique. --%>
        <details class="card shadow-sm historico">
            <summary class="card-header">
                <i class="fa-solid fa-box-archive"></i>
                <h5>Finalizados</h5>
                <span class="header-hint">${fn:length(pedidosFinalizados)} pagos · clique para ver</span>
            </summary>
            <div class="table-wrapper">
                <table class="table tabela-pedidos">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Cliente</th>
                            <th>Mesa</th>
                            <th>Data/Hora</th>
                            <th>O que comprou</th>
                            <th>Total</th>
                            <th>Pago</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${pedidosFinalizados}">
                            <tr>
                                <td><span class="cod-pedido">#${item.codpedido}</span></td>
                                <td>${item.clientePedido.nomeCliente}</td>
                                <td>Mesa ${item.mesaPedido.numeroMesa}</td>
                                <td>${item.datahoraFormatada}</td>
                                <td class="resumo-itens"><c:out value="${item.resumoItens}"/></td>
                                <td>R$ <fmt:formatNumber value="${item.total}" pattern="#,##0.00"/></td>
                                <td class="valor-total">R$ <fmt:formatNumber value="${item.valorRecebido}" pattern="#,##0.00"/></td>
                                <td>
                                    <div class="acoes">
                                        <a href="${URL_CONTROLLER}?opcao=abrirItens&codpedido=${item.codpedido}" class="btn-itens">
                                            <i class="fa-solid fa-burger"></i> Itens
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </details>
    </c:if>

</div>

<footer>
    <i class="fa-solid fa-burger me-1"></i>
    <span class="brand">Big Tites</span> &mdash; painel de gerenciamento
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
