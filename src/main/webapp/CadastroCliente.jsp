<%@page contentType="text/html" pageEncoding="Latin1"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <title>Cadastro de Cliente</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css">
    </head>
    <body>
        <nav>
            <a class="logo" href="${pageContext.request.contextPath}/index.html">? Hamburgueria</a>
            <ul>
                <li><a href="${pageContext.request.contextPath}${URL_BASE}/CargoController?opcao=listar">Cargo</a></li>
                <li><a href="${pageContext.request.contextPath}${URL_BASE}/CategoriaController?opcao=listar">Categoria</a></li>
                <li><a href="${pageContext.request.contextPath}${URL_BASE}/ClienteController?opcao=listar" class="ativo">Cliente</a></li>
                <li><a href="${pageContext.request.contextPath}${URL_BASE}/FornecedorController?opcao=listar">Fornecedor</a></li>
                <li><a href="${pageContext.request.contextPath}${URL_BASE}/MesaController?opcao=listar">Mesa</a></li>
                <li><a href="${pageContext.request.contextPath}${URL_BASE}/TurnosController?opcao=listar" >Turnos</a></li>
            </ul>
        </nav>
        <div class="container">
            <h1>Cadastro de Cliente</h1>
            <c:if test="${not empty mensagem}">
                <div class="mensagem">${mensagem}</div>
            </c:if>
            <form method="get" action="${pageContext.request.contextPath}${URL_BASE}/ClienteController">
                <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}"/>
                <input type="hidden" name="codCliente" value="${empty codCliente ? 0 : codCliente}"/>
                <div class="form-group">
                    <label>Nome:</label>
                    <input type="text" name="nomeCliente" value="${nomeCliente}" required/>
                </div>
                <div class="form-group">
                    <label>CPF:</label>
                    <input type="text" name="cpfCliente" value="${cpfCliente}"/>
                </div>
                <div class="form-group">
                    <label>Senha:</label>
                    <input type="password" name="senhaCliente" value="${senhaCliente}"/>
                </div>
                <div class="form-group">
                    <label>Telefone:</label>
                    <input type="text" name="telefone" value="${telefone}"/>
                </div>
                <div class="form-group">
                    <label>Data Cadastro:</label>
                    <input class="cadastroInput" type="text" name="dataCadastro" readonly="" value="${dataCadastro}"/>
                </div>
                <button type="submit" class="btn-salvar">Salvar</button>
            </form>
            <form method="get" action="${pageContext.request.contextPath}${URL_BASE}/ClienteController">
                <input type="hidden" name="opcao" value="cancelar"/>
                <button type="submit" class="btn-cancelar">Cancelar</button>
            </form>
            <c:if test="${not empty clientes}">
                <div class="table-wrapper">
                    <table>
                        <caption>Clientes Cadastrados</caption>
                        <tr><th>Código</th><th>Nome</th><th>CPF</th><th>Telefone</th><th>Data Cadastro</th><th>Ações</th></tr>
                                <c:forEach var="item" items="${clientes}">
                            <tr>
                                <td>${item.codCliente}</td>
                                <td>${item.nomeCliente}</td>
                                <td>${item.cpfCliente}</td>
                                <td>${item.telefone}</td>
                                <td>${item.dataCadastro}</td>
                                <td>
                                    <form method="get" action="${pageContext.request.contextPath}${URL_BASE}/ClienteController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarAlterar"/>
                                        <input type="hidden" name="codCliente" value="${item.codCliente}"/>
                                        <input type="hidden" name="nomeCliente" value="${item.nomeCliente}"/>
                                        <input type="hidden" name="cpfCliente" value="${item.cpfCliente}"/>
                                        <input type="hidden" name="senhaCliente" value="${item.senhaCliente}"/>
                                        <input type="hidden" name="telefone" value="${item.telefone}"/>
                                        <input type="hidden" name="dataCadastro" value="${item.dataCadastro}"/>
                                        <button type="submit" class="btn-alterar">Alterar</button>
                                    </form>
                                    <form method="get" action="${pageContext.request.contextPath}${URL_BASE}/ClienteController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarExcluir"/>
                                        <input type="hidden" name="codCliente" value="${item.codCliente}"/>
                                        <input type="hidden" name="nomeCliente" value="${item.nomeCliente}"/>
                                        <input type="hidden" name="cpfCliente" value="${item.cpfCliente}"/>
                                        <input type="hidden" name="senhaCliente" value="${item.senhaCliente}"/>
                                        <input type="hidden" name="telefone" value="${item.telefone}"/>
                                        <input type="hidden" name="dataCadastro" value="${item.dataCadastro}"/>
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
