<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ingrediente — Big Tites</title>
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
            <i class="fa-solid fa-carrot"></i>
            <h4>Cadastro de Ingrediente</h4>
        </div>
        <div class="card-body">
            <c:if test="${not empty mensagem}">
                <div class="mensagem"><i class="fa-solid fa-circle-check"></i> ${mensagem}</div>
            </c:if>

            <form id="formCadastro" method="get"
                action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/IngredienteController">
                <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}"/>
                <input type="hidden" name="codIngrediente" value="${empty codIngrediente ? 0 : codIngrediente}"/>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-leaf me-1 text-secondary"></i>Nome</label>
                        <input type="text" class="form-control" name="nomeIngredientes" value="${nomeIngredientes}" placeholder="Ex: Pão de hambúrguer, Carne bovina..." required/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-scale-balanced me-1 text-secondary"></i>Quantidade</label>
                        <input type="number" step="0.01" class="form-control" name="quantiIngredientes" value="${quantiIngredientes}" placeholder="0.00" required/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-money-bill me-1 text-secondary"></i>Valor (R$)</label>
                        <input type="number" step="0.01" class="form-control" name="valorIngrediente" value="${valorIngrediente}" placeholder="0,00" required/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-calendar-check me-1 text-secondary"></i>Data de Produção</label>
                        <input type="date" class="form-control" name="dataProducao" value="${dataProducao}" required/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-calendar-xmark me-1 text-secondary"></i>Data de Vencimento</label>
                        <input type="date" class="form-control" name="dataVencimento" value="${dataVencimento}" required/>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-truck me-1 text-secondary"></i>Fornecedor</label>
                        <select class="form-select" name="codFornecedor" required>
                            <c:forEach var="forn" items="${fornecedores}">
                                <option value="${forn.codFornecedor}" <c:if test="${forn.codFornecedor == codFornecedorAtual}">selected</c:if>>
                                    ${forn.nomeFornecedor}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-12">
                        <label class="form-label"><i class="fa-solid fa-align-left me-1 text-secondary"></i>Descrição</label>
                        <input type="text" class="form-control" name="descricaoIngrediente" value="${descricaoIngrediente}" placeholder="Informações adicionais..."/>
                    </div>
                </div>
            </form>

            <div class="btn-actions">
                <button type="submit" form="formCadastro" class="btn-salvar">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                </button>
                <a href="${pageContext.request.contextPath}${URL_BASE}/IngredienteController?opcao=listar" class="btn-cancelar">
                    <i class="fa-solid fa-ban"></i> Cancelar
                </a>
            </div>
        </div>
    </div>

    <c:if test="${not empty ingredientes}">
        <div class="card shadow-sm">
            <div class="card-header">
                <i class="fa-solid fa-list"></i>
                <h5>Ingredientes Cadastrados</h5>
            </div>
            <div class="table-wrapper">
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Nome</th>
                            <th>Qtd.</th>
                            <th>Produção</th>
                            <th>Vencimento</th>
                            <th>Valor</th>
                            <th>Fornecedor</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${ingredientes}">
                            <tr>
                                <td>${item.codIngrediente}</td>
                                <td>${item.nomeIngredientes}</td>
                                <td>${item.quantiIngredientes}</td>
                                <td>${item.dataProducao}</td>
                                <td>${item.dataVencimento}</td>
                                <td><strong>R$ ${item.valorIngrediente}</strong></td>
                                <td>${item.fornecedorIngrediente.nomeFornecedor}</td>
                                <td>
                                    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/IngredienteController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarAlterar"/>
                                        <input type="hidden" name="codIngrediente" value="${item.codIngrediente}"/>
                                        <input type="hidden" name="nomeIngredientes" value="${item.nomeIngredientes}"/>
                                        <input type="hidden" name="quantiIngredientes" value="${item.quantiIngredientes}"/>
                                        <input type="hidden" name="dataProducao" value="${item.dataProducao}"/>
                                        <input type="hidden" name="dataVencimento" value="${item.dataVencimento}"/>
                                        <input type="hidden" name="valorIngrediente" value="${item.valorIngrediente}"/>
                                        <input type="hidden" name="descricaoIngrediente" value="${item.descricaoIngrediente}"/>
                                        <input type="hidden" name="codFornecedor" value="${item.fornecedorIngrediente.codFornecedor}"/>
                                        <button type="submit" class="btn-alterar"><i class="fa-solid fa-pencil"></i> Alterar</button>
                                    </form>
                                    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/IngredienteController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarExcluir"/>
                                        <input type="hidden" name="codIngrediente" value="${item.codIngrediente}"/>
                                        <input type="hidden" name="nomeIngredientes" value="${item.nomeIngredientes}"/>
                                        <input type="hidden" name="quantiIngredientes" value="${item.quantiIngredientes}"/>
                                        <input type="hidden" name="dataProducao" value="${item.dataProducao}"/>
                                        <input type="hidden" name="dataVencimento" value="${item.dataVencimento}"/>
                                        <input type="hidden" name="valorIngrediente" value="${item.valorIngrediente}"/>
                                        <input type="hidden" name="descricaoIngrediente" value="${item.descricaoIngrediente}"/>
                                        <input type="hidden" name="codFornecedor" value="${item.fornecedorIngrediente.codFornecedor}"/>
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
