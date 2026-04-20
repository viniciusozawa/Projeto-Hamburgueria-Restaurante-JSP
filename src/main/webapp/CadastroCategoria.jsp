<%@page contentType="text/html" pageEncoding="Latin1"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Cadastro de Categoria</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css">
</head>
<body>
<nav>
    <a class="logo" href="${pageContext.request.contextPath}/index.html">? Hamburgueria</a>
    <ul>
        <li><a href="${pageContext.request.contextPath}${URL_BASE}/CargoController?opcao=listar">Cargo</a></li>
        <li><a href="${pageContext.request.contextPath}${URL_BASE}/CategoriaController?opcao=listar" class="ativo">Categoria</a></li>
        <li><a href="${pageContext.request.contextPath}${URL_BASE}/ClienteController?opcao=listar" >Cliente</a></li>
        <li><a href="${pageContext.request.contextPath}${URL_BASE}/FornecedorController?opcao=listar">Fornecedor</a></li>
        <li><a href="${pageContext.request.contextPath}${URL_BASE}/MesaController?opcao=listar">Mesa</a></li>
        <li><a href="${pageContext.request.contextPath}${URL_BASE}/TurnosController?opcao=listar">Turnos</a></li>
    </ul>
</nav>
<div class="container">
    <h1>Cadastro de Categoria</h1>
    <c:if test="${not empty mensagem}">
        <div class="mensagem">${mensagem}</div>
    </c:if>
    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/CategoriaController">
        <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}"/>
        <input type="hidden" name="codCategoria" value="${empty codCategoria ? 0 : codCategoria}"/>
        <div class="form-group">
            <label>Nome da Categoria:</label>
            <input type="text" name="nomeCategoria" value="${nomeCategoria}" required/>
        </div>
        <button type="submit" class="btn-salvar">Salvar</button>
    </form>
    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/CategoriaController">
        <input type="hidden" name="opcao" value="cancelar"/>
        <button type="submit" class="btn-cancelar">Cancelar</button>
    </form>
    <c:if test="${not empty categorias}">
        <div class="table-wrapper">
            <table>
                <caption>Categorias Cadastradas</caption>
                <tr><th>Código</th><th>Nome</th><th>Ações</th></tr>
                <c:forEach var="item" items="${categorias}">
                    <tr>
                        <td>${item.codCategoria}</td>
                        <td>${item.nomeCategoria}</td>
                        <td>
                            <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/CategoriaController" style="display:inline">
                                <input type="hidden" name="opcao" value="enviarAlterar"/>
                                <input type="hidden" name="codCategoria" value="${item.codCategoria}"/>
                                <input type="hidden" name="nomeCategoria" value="${item.nomeCategoria}"/>
                                <button type="submit" class="btn-alterar">Alterar</button>
                            </form>
                            <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/CategoriaController" style="display:inline">
                                <input type="hidden" name="opcao" value="enviarExcluir"/>
                                <input type="hidden" name="codCategoria" value="${item.codCategoria}"/>
                                <input type="hidden" name="nomeCategoria" value="${item.nomeCategoria}"/>
                                <button type="submit" class="btn-excluir">Excluir</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </c:if>
</div>
</body>
</html>
