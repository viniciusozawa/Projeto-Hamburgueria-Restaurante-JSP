<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Cadastro de Cardapio</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        select { width:100%; padding:9px 12px; font-size:15px; border-radius:8px; border:1px solid #ccc; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.html">
            <i class="fa-solid fa-burger"></i> Hamburgueria
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#menuNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="menuNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item px-2">
                    <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/CargoController?opcao=listar">
                        <i class="fa-solid fa-id-badge"></i> Cargo
                    </a>
                </li>
                <li class="nav-item px-2">
                    <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/CategoriaController?opcao=listar">
                        <i class="fa-solid fa-tags"></i> Categoria
                    </a>
                </li>
                <li class="nav-item px-2">
                    <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/ClienteController?opcao=listar">
                        <i class="fa-solid fa-user"></i> Cliente
                    </a>
                </li>
                <li class="nav-item px-2">
                    <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/FornecedorController?opcao=listar">
                        <i class="fa-solid fa-truck"></i> Fornecedor
                    </a>
                </li>
                <li class="nav-item px-2">
                    <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/MesaController?opcao=listar">
                        <i class="fa-solid fa-chair"></i> Mesa
                    </a>
                </li>
                <li class="nav-item px-2">
                    <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/TurnosController?opcao=listar">
                        <i class="fa-solid fa-clock"></i> Turnos
                    </a>
                </li>
                <li class="nav-item px-2">
                    <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/FuncionarioController?opcao=listar">
                        <i class="fa-solid fa-user-tie"></i> Funcionario
                    </a>
                </li>
                <li class="nav-item px-2">
                    <a class="nav-link active" href="${pageContext.request.contextPath}${URL_BASE}/CardapioController?opcao=listar">
                        <i class="fa-solid fa-utensils"></i> Cardapio
                    </a>
                </li>
                <li class="nav-item px-2">
                    <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/IngredienteController?opcao=listar">
                        <i class="fa-solid fa-carrot"></i> Ingrediente
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="containerr">
        <h1>Cadastro de Cardapio</h1>
        <c:if test="${not empty mensagem}">
            <div class="mensagem">${mensagem}</div>
        </c:if>

        <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/CardapioController">
            <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}" />
            <input type="hidden" name="codCardapio" value="${empty codCardapio ? 0 : codCardapio}" />

            <div class="form-group">
                <label>Nome do Prato:</label>
                <input type="text" name="nomeComida" value="${nomeComida}" required />
            </div>
            <div class="form-group">
                <label>Valor (R$):</label>
                <input type="number" step="0.01" name="valorComida" value="${valorComida}" required />
            </div>
            <div class="form-group">
                <label>Descricao:</label>
                <input type="text" name="descricaoComida" value="${descricaoComida}" />
            </div>
            <div class="form-group">
                <label>Categoria:</label>
                <select name="codCategoria" required>
                    <c:forEach var="cat" items="${categorias}">
                        <option value="${cat.codCategoria}" <c:if test="${cat.codCategoria == codCategoriaAtual}">selected</c:if>>
                            ${cat.nomeCategoria}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <button type="submit" class="btn-salvar">Salvar</button>
        </form>
        <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/CardapioController">
            <input type="hidden" name="opcao" value="cancelar" />
            <button type="submit" class="btn-cancelar">Cancelar</button>
        </form>

        <c:if test="${not empty cardapios}">
            <div class="table-wrapper">
                <table>
                    <caption>Cardapio Cadastrado</caption>
                    <tr>
                        <th>Codigo</th>
                        <th>Nome</th>
                        <th>Valor</th>
                        <th>Descricao</th>
                        <th>Categoria</th>
                        <th>Acoes</th>
                    </tr>
                    <c:forEach var="item" items="${cardapios}">
                        <tr>
                            <td>${item.codCardapio}</td>
                            <td>${item.nomeComida}</td>
                            <td>R$ ${item.valorComida}</td>
                            <td>${item.descricaoComida}</td>
                            <td>${item.categoriaCardapio.nomeCategoria}</td>
                            <td>
                                <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/CardapioController" style="display:inline">
                                    <input type="hidden" name="opcao" value="enviarAlterar" />
                                    <input type="hidden" name="codCardapio" value="${item.codCardapio}" />
                                    <input type="hidden" name="nomeComida" value="${item.nomeComida}" />
                                    <input type="hidden" name="valorComida" value="${item.valorComida}" />
                                    <input type="hidden" name="descricaoComida" value="${item.descricaoComida}" />
                                    <input type="hidden" name="codCategoria" value="${item.categoriaCardapio.codCategoria}" />
                                    <button type="submit" class="btn-alterar">Alterar</button>
                                </form>
                                <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/CardapioController" style="display:inline">
                                    <input type="hidden" name="opcao" value="enviarExcluir" />
                                    <input type="hidden" name="codCardapio" value="${item.codCardapio}" />
                                    <input type="hidden" name="nomeComida" value="${item.nomeComida}" />
                                    <input type="hidden" name="valorComida" value="${item.valorComida}" />
                                    <input type="hidden" name="descricaoComida" value="${item.descricaoComida}" />
                                    <input type="hidden" name="codCategoria" value="${item.categoriaCardapio.codCategoria}" />
                                    <button type="submit" class="btn-excluir">Excluir</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
