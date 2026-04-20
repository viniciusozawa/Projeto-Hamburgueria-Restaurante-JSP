<%@page contentType="text/html" pageEncoding="Latin1"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <title>Cadastro de Mesa</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css">
    </head>
    <body>
        <nav>
            <a class="logo" href="${pageContext.request.contextPath}/index.html">? Hamburgueria</a>
            <ul>
                <li><a href="${pageContext.request.contextPath}${URL_BASE}/CargoController?opcao=listar">Cargo</a></li>
                <li><a href="${pageContext.request.contextPath}${URL_BASE}/CategoriaController?opcao=listar">Categoria</a></li>
                <li><a href="${pageContext.request.contextPath}${URL_BASE}/ClienteController?opcao=listar">Cliente</a></li>
                <li><a href="${pageContext.request.contextPath}${URL_BASE}/FornecedorController?opcao=listar">Fornecedor</a></li>
                <li><a href="${pageContext.request.contextPath}${URL_BASE}/MesaController?opcao=listar" class="ativo">Mesa</a></li>
                <li><a href="${pageContext.request.contextPath}${URL_BASE}/TurnosController?opcao=listar" >Turnos</a></li>
            </ul>
        </nav>
        <div class="container">
            <h1>Cadastro de Mesa</h1>
            <c:if test="${not empty mensagem}">
                <div class="mensagem">${mensagem}</div>
            </c:if>
            <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/MesaController">
                <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}"/>
                <input type="hidden" name="codMesa" value="${empty codMesa ? 0 : codMesa}"/>
                <div class="form-group">
                    <label>Número da Mesa:</label>
                    <input type="number" name="numeroMesa" value="${numeroMesa}" required/>
                </div>
                <div class="form-group">
                    <label>Local:</label>
                    <input type="text" name="localMesa" value="${localMesa}"/>
                </div>
                <button type="submit" class="btn-salvar">Salvar</button>
            </form>
            <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/MesaController">
                <input type="hidden" name="opcao" value="cancelar"/>
                <button type="submit" class="btn-cancelar">Cancelar</button>
            </form>
            <c:if test="${not empty mesas}">
                <div class="table-wrapper">
                    <table>
                        <caption>Mesas Cadastradas</caption>
                        <tr><th>Código</th><th>Número</th><th>Local</th><th>Ações</th></tr>
                                <c:forEach var="item" items="${mesas}">
                            <tr>
                                <td>${item.codMesa}</td>
                                <td>${item.numeroMesa}</td>
                                <td>${item.localMesa}</td>
                                <td>
                                    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/MesaController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarAlterar"/>
                                        <input type="hidden" name="codMesa" value="${item.codMesa}"/>
                                        <input type="hidden" name="numeroMesa" value="${item.numeroMesa}"/>
                                        <input type="hidden" name="localMesa" value="${item.localMesa}"/>
                                        <button type="submit" class="btn-alterar">Alterar</button>
                                    </form>
                                    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/MesaController" style="display:inline">

                                        <input type="hidden" name="opcao" value="enviarExcluir"/>
                                        <input type="hidden" name="codMesa" value="${item.codMesa}"/>
                                        <input type="hidden" name="numeroMesa" value="${item.numeroMesa}"/>
                                        <input type="hidden" name="localMesa" value="${item.localMesa}"/>
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
