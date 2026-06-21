<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pagamento — Big Tites</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css">
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

            <form id="formCadastro" method="get"
                action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/PagamentoController">
                <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}"/>
                <input type="hidden" name="codPagamento" value="${empty codPagamento ? 0 : codPagamento}"/>
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-money-check me-1 text-secondary"></i>Forma de Pagamento</label>
                        <input type="text" class="form-control" name="formaPagamento" value="${formaPagamento}" placeholder="Ex: Pix, Cartão, Dinheiro..." required/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-money-bill me-1 text-secondary"></i>Valor Pago (R$)</label>
                        <input type="number" step="0.01" class="form-control" name="valorPago" value="${valorPago}" placeholder="0,00" required/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-calendar me-1 text-secondary"></i>Data do Pagamento</label>
                        <input type="date" class="form-control" name="dataPagamento" value="${dataPagamento}" required/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-circle-info me-1 text-secondary"></i>Status</label>
                        <input type="text" class="form-control" name="statusPagamento" value="${statusPagamento}" placeholder="Ex: andamento, concluido..."/>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-receipt me-1 text-secondary"></i>Pedido</label>
                        <select class="form-select" name="codpedido" required>
                            <c:forEach var="p" items="${pedidos}">
                                <option value="${p.codpedido}" <c:if test="${p.codpedido == codPedidoAtual}">selected</c:if>>
                                    Pedido #${p.codpedido} — ${p.clientePedido.nomeCliente}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-user me-1 text-secondary"></i>Cliente</label>
                        <select class="form-select" name="codCliente" required>
                            <c:forEach var="cli" items="${clientes}">
                                <option value="${cli.codCliente}" <c:if test="${cli.codCliente == codClienteAtual}">selected</c:if>>
                                    ${cli.nomeCliente}
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
                <a href="${pageContext.request.contextPath}${URL_BASE}/PagamentoController?opcao=listar" class="btn-cancelar">
                    <i class="fa-solid fa-ban"></i> Cancelar
                </a>
            </div>
        </div>
    </div>

    <c:if test="${not empty pagamentos}">
        <div class="card shadow-sm">
            <div class="card-header">
                <i class="fa-solid fa-list"></i>
                <h5>Pagamentos Cadastrados</h5>
            </div>
            <div class="table-wrapper">
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Forma</th>
                            <th>Valor</th>
                            <th>Data</th>
                            <th>Status</th>
                            <th>Pedido</th>
                            <th>Cliente</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${pagamentos}">
                            <tr>
                                <td>${item.codPagamento}</td>
                                <td>${item.formaPagamento}</td>
                                <td><strong>R$ ${item.valorPago}</strong></td>
                                <td>${item.dataPagamento}</td>
                                <td>${item.statusPagamento}</td>
                                <td>#${item.pedidoPagamento.codpedido}</td>
                                <td>${item.clientePagamento.nomeCliente}</td>
                                <td>
                                    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/PagamentoController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarAlterar"/>
                                        <input type="hidden" name="codPagamento" value="${item.codPagamento}"/>
                                        <input type="hidden" name="formaPagamento" value="${item.formaPagamento}"/>
                                        <input type="hidden" name="valorPago" value="${item.valorPago}"/>
                                        <input type="hidden" name="dataPagamento" value="${item.dataPagamento}"/>
                                        <input type="hidden" name="statusPagamento" value="${item.statusPagamento}"/>
                                        <input type="hidden" name="codpedido" value="${item.pedidoPagamento.codpedido}"/>
                                        <input type="hidden" name="codCliente" value="${item.clientePagamento.codCliente}"/>
                                        <button type="submit" class="btn-alterar"><i class="fa-solid fa-pencil"></i> Alterar</button>
                                    </form>
                                    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/PagamentoController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarExcluir"/>
                                        <input type="hidden" name="codPagamento" value="${item.codPagamento}"/>
                                        <input type="hidden" name="formaPagamento" value="${item.formaPagamento}"/>
                                        <input type="hidden" name="valorPago" value="${item.valorPago}"/>
                                        <input type="hidden" name="dataPagamento" value="${item.dataPagamento}"/>
                                        <input type="hidden" name="statusPagamento" value="${item.statusPagamento}"/>
                                        <input type="hidden" name="codpedido" value="${item.pedidoPagamento.codpedido}"/>
                                        <input type="hidden" name="codCliente" value="${item.clientePagamento.codCliente}"/>
                                        <button type="submit" class="btn-excluir"><i class="fa-solid fa-trash"></i> Excluir</button>
                                    </form>
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
    <span class="brand">Big Tites</span> &copy; 2024 &mdash; Sistema de Gerenciamento
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
