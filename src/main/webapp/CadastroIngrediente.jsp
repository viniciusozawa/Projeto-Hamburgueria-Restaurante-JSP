<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Cadastro de Ingrediente</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        select { width:100%; padding:9px 12px; font-size:15px; border-radius:8px; border:1px solid #ccc; }
        input[type="date"] { width:100%; padding:9px 12px; font-size:15px; border-radius:8px; border:1px solid #ccc; }
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
                    <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/CardapioController?opcao=listar">
                        <i class="fa-solid fa-utensils"></i> Cardapio
                    </a>
                </li>
                <li class="nav-item px-2">
                    <a class="nav-link active" href="${pageContext.request.contextPath}${URL_BASE}/IngredienteController?opcao=listar">
                        <i class="fa-solid fa-carrot"></i> Ingrediente
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="containerr">
        <h1>Cadastro de Ingrediente</h1>
        <c:if test="${not empty mensagem}">
            <div class="mensagem">${mensagem}</div>
        </c:if>

        <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/IngredienteController">
            <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}" />
            <input type="hidden" name="codIngrediente" value="${empty codIngrediente ? 0 : codIngrediente}" />

            <div class="form-group">
                <label>Nome:</label>
                <input type="text" name="nomeIngredientes" value="${nomeIngredientes}" required />
            </div>
            <div class="form-group">
                <label>Quantidade:</label>
                <input type="number" step="0.01" name="quantiIngredientes" value="${quantiIngredientes}" required />
            </div>
            <div class="form-group">
                <label>Data de Producao:</label>
                <input type="date" name="dataProducao" value="${dataProducao}" required />
            </div>
            <div class="form-group">
                <label>Data de Vencimento:</label>
                <input type="date" name="dataVencimento" value="${dataVencimento}" required />
            </div>
            <div class="form-group">
                <label>Valor (R$):</label>
                <input type="number" step="0.01" name="valorIngrediente" value="${valorIngrediente}" required />
            </div>
            <div class="form-group">
                <label>Descricao:</label>
                <input type="text" name="descricaoIngrediente" value="${descricaoIngrediente}" />
            </div>
            <div class="form-group">
                <label>Fornecedor:</label>
                <select name="codFornecedor" required>
                    <c:forEach var="forn" items="${fornecedores}">
                        <option value="${forn.codFornecedor}" <c:if test="${forn.codFornecedor == codFornecedorAtual}">selected</c:if>>
                            ${forn.nomeFornecedor}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <button type="submit" class="btn-salvar">Salvar</button>
        </form>
        <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/IngredienteController">
            <input type="hidden" name="opcao" value="cancelar" />
            <button type="submit" class="btn-cancelar">Cancelar</button>
        </form>

        <c:if test="${not empty ingredientes}">
            <div class="table-wrapper">
                <table>
                    <caption>Ingredientes Cadastrados</caption>
                    <tr>
                        <th>Codigo</th>
                        <th>Nome</th>
                        <th>Quantidade</th>
                        <th>Producao</th>
                        <th>Vencimento</th>
                        <th>Valor</th>
                        <th>Fornecedor</th>
                        <th>Acoes</th>
                    </tr>
                    <c:forEach var="item" items="${ingredientes}">
                        <tr>
                            <td>${item.codIngrediente}</td>
                            <td>${item.nomeIngredientes}</td>
                            <td>${item.quantiIngredientes}</td>
                            <td>${item.dataProducao}</td>
                            <td>${item.dataVencimento}</td>
                            <td>R$ ${item.valorIngrediente}</td>
                            <td>${item.fornecedorIngrediente.nomeFornecedor}</td>
                            <td>
                                <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/IngredienteController" style="display:inline">
                                    <input type="hidden" name="opcao" value="enviarAlterar" />
                                    <input type="hidden" name="codIngrediente" value="${item.codIngrediente}" />
                                    <input type="hidden" name="nomeIngredientes" value="${item.nomeIngredientes}" />
                                    <input type="hidden" name="quantiIngredientes" value="${item.quantiIngredientes}" />
                                    <input type="hidden" name="dataProducao" value="${item.dataProducao}" />
                                    <input type="hidden" name="dataVencimento" value="${item.dataVencimento}" />
                                    <input type="hidden" name="valorIngrediente" value="${item.valorIngrediente}" />
                                    <input type="hidden" name="descricaoIngrediente" value="${item.descricaoIngrediente}" />
                                    <input type="hidden" name="codFornecedor" value="${item.fornecedorIngrediente.codFornecedor}" />
                                    <button type="submit" class="btn-alterar">Alterar</button>
                                </form>
                                <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/IngredienteController" style="display:inline">
                                    <input type="hidden" name="opcao" value="enviarExcluir" />
                                    <input type="hidden" name="codIngrediente" value="${item.codIngrediente}" />
                                    <input type="hidden" name="nomeIngredientes" value="${item.nomeIngredientes}" />
                                    <input type="hidden" name="quantiIngredientes" value="${item.quantiIngredientes}" />
                                    <input type="hidden" name="dataProducao" value="${item.dataProducao}" />
                                    <input type="hidden" name="dataVencimento" value="${item.dataVencimento}" />
                                    <input type="hidden" name="valorIngrediente" value="${item.valorIngrediente}" />
                                    <input type="hidden" name="descricaoIngrediente" value="${item.descricaoIngrediente}" />
                                    <input type="hidden" name="codFornecedor" value="${item.fornecedorIngrediente.codFornecedor}" />
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
