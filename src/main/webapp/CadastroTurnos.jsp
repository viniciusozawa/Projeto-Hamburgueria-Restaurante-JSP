<%@page contentType="text/html" pageEncoding="Latin1"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Cadastro de Turnos</title>
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
        <li><a href="${pageContext.request.contextPath}${URL_BASE}/MesaController?opcao=listar">Mesa</a></li>
        <li><a href="${pageContext.request.contextPath}${URL_BASE}/TurnosController?opcao=listar" class="ativo">Turnos</a></li>
    </ul>
</nav>
<div class="container">
    <h1>Cadastro de Turnos</h1>
    <c:if test="${not empty mensagem}">
        <div class="mensagem">${mensagem}</div>
    </c:if>
    <form method="get" action="${pageContext.request.contextPath}${URL_BASE}/TurnosController">
        <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}"/>
        <input type="hidden" name="codTurnos" value="${empty codTurnos ? 0 : codTurnos}"/>
        <div class="form-group">
            <label>Horário Início:</label>
            <input type="time" name="horarioInicio" value="${horarioInicio}" required/>
        </div>
        <div class="form-group">
            <label>Horário Final:</label>
            <input type="time" name="horarioFinal" value="${horarioFinal}" required/>
        </div>
        <button type="submit" class="btn-salvar">Salvar</button>
    </form>
    <form method="get" action="${pageContext.request.contextPath}${URL_BASE}/TurnosController">
        <input type="hidden" name="opcao" value="cancelar"/>
        <button type="submit" class="btn-cancelar">Cancelar</button>
    </form>
    <c:if test="${not empty turnos}">
        <div class="table-wrapper">
            <table>
                <caption>Turnos Cadastrados</caption>
                <tr><th>Código</th><th>Início</th><th>Final</th><th>Ações</th></tr>
                <c:forEach var="item" items="${turnos}">
                    <tr>
                        <td>${item.codTurnos}</td>
                        <td>${item.horarioInicio}</td>
                        <td>${item.horarioFinal}</td>
                        <td>
                            <form method="get" action="${pageContext.request.contextPath}${URL_BASE}/TurnosController" style="display:inline">
                                <input type="hidden" name="opcao" value="enviarAlterar"/>
                                <input type="hidden" name="codTurnos" value="${item.codTurnos}"/>
                                <input type="hidden" name="horarioInicio" value="${item.horarioInicio}"/>
                                <input type="hidden" name="horarioFinal" value="${item.horarioFinal}"/>
                                <button type="submit" class="btn-alterar">Alterar</button>
                            </form>
                            <form method="get" action="${pageContext.request.contextPath}${URL_BASE}/TurnosController" style="display:inline">
                                <input type="hidden" name="opcao" value="enviarExcluir"/>
                                <input type="hidden" name="codTurnos" value="${item.codTurnos}"/>
                                <input type="hidden" name="horarioInicio" value="${item.horarioInicio}"/>
                                <input type="hidden" name="horarioFinal" value="${item.horarioFinal}"/>
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
