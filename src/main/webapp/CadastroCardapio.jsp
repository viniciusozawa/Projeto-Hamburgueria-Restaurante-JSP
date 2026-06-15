<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cardápio — Big Tites</title>
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
            <i class="fa-solid fa-utensils"></i>
            <h4>Cadastro de Cardápio</h4>
        </div>
        <div class="card-body">
            <c:if test="${not empty mensagem}">
                <div class="mensagem"><i class="fa-solid fa-circle-check"></i> ${mensagem}</div>
            </c:if>

            <form id="formCadastro" method="get"
                action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/CardapioController">
                <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}"/>
                <input type="hidden" name="codCardapio" value="${empty codCardapio ? 0 : codCardapio}"/>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-bowl-food me-1 text-secondary"></i>Nome do Prato</label>
                        <input type="text" class="form-control" name="nomeComida" value="${nomeComida}" placeholder="Ex: X-Burger Clássico..." required/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-money-bill me-1 text-secondary"></i>Valor (R$)</label>
                        <input type="number" step="0.01" class="form-control" name="valorComida" value="${valorComida}" placeholder="0,00" required/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-tags me-1 text-secondary"></i>Categoria</label>
                        <select class="form-select" name="codCategoria" required>
                            <c:forEach var="cat" items="${categorias}">
                                <option value="${cat.codCategoria}" <c:if test="${cat.codCategoria == codCategoriaAtual}">selected</c:if>>
                                    ${cat.nomeCategoria}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-9">
                        <label class="form-label"><i class="fa-solid fa-align-left me-1 text-secondary"></i>Descrição</label>
                        <input type="text" class="form-control" name="descricaoComida" value="${descricaoComida}" placeholder="Breve descrição do prato..."/>
                    </div>
                </div>
            </form>

            <div class="btn-actions">
                <button type="submit" form="formCadastro" class="btn-salvar">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                </button>
                <a href="${pageContext.request.contextPath}${URL_BASE}/CardapioController?opcao=listar" class="btn-cancelar">
                    <i class="fa-solid fa-ban"></i> Cancelar
                </a>
            </div>
        </div>
    </div>

    <c:if test="${not empty cardapios}">
        <div class="card shadow-sm">
            <div class="card-header">
                <i class="fa-solid fa-list"></i>
                <h5>Cardápio Cadastrado</h5>
            </div>
            <div class="table-wrapper">
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Nome</th>
                            <th>Valor</th>
                            <th>Descrição</th>
                            <th>Categoria</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${cardapios}">
                            <tr>
                                <td>${item.codCardapio}</td>
                                <td>${item.nomeComida}</td>
                                <td><strong>R$ ${item.valorComida}</strong></td>
                                <td>${item.descricaoComida}</td>
                                <td><span style="background:#f39c12;color:#1e1e2e;padding:2px 10px;border-radius:20px;font-size:0.78rem;font-weight:600">${item.categoriaCardapio.nomeCategoria}</span></td>
                                <td>
                                    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/CardapioController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarAlterar"/>
                                        <input type="hidden" name="codCardapio" value="${item.codCardapio}"/>
                                        <input type="hidden" name="nomeComida" value="${item.nomeComida}"/>
                                        <input type="hidden" name="valorComida" value="${item.valorComida}"/>
                                        <input type="hidden" name="descricaoComida" value="${item.descricaoComida}"/>
                                        <input type="hidden" name="codCategoria" value="${item.categoriaCardapio.codCategoria}"/>
                                        <button type="submit" class="btn-alterar"><i class="fa-solid fa-pencil"></i> Alterar</button>
                                    </form>
                                    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/CardapioController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarExcluir"/>
                                        <input type="hidden" name="codCardapio" value="${item.codCardapio}"/>
                                        <input type="hidden" name="nomeComida" value="${item.nomeComida}"/>
                                        <input type="hidden" name="valorComida" value="${item.valorComida}"/>
                                        <input type="hidden" name="descricaoComida" value="${item.descricaoComida}"/>
                                        <input type="hidden" name="codCategoria" value="${item.categoriaCardapio.codCategoria}"/>
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
