<%@page contentType="text/html" pageEncoding="Latin1" %>
    <%@taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="pt-BR">

        <head>
            <meta charset="UTF-8">
            <title>Cadastro de Cliente</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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
                            <a class="nav-link"
                                href="${pageContext.request.contextPath}${URL_BASE}/CargoController?opcao=listar">
                                <i class="fa-solid fa-id-badge"></i> Cargo
                            </a>
                        </li>
                        <li class="nav-item px-2">
                            <a class="nav-link"
                                href="${pageContext.request.contextPath}${URL_BASE}/CategoriaController?opcao=listar">
                                <i class="fa-solid fa-tags"></i> Categoria
                            </a>
                        </li>
                        <li class="nav-item px-2">
                            <a class="nav-link"
                                href="${pageContext.request.contextPath}${URL_BASE}/ClienteController?opcao=listar">
                                <i class="fa-solid fa-user"></i> Cliente
                            </a>
                        </li>
                        <li class="nav-item px-2">
                            <a class="nav-link"
                                href="${pageContext.request.contextPath}${URL_BASE}/FornecedorController?opcao=listar">
                                <i class="fa-solid fa-truck"></i> Fornecedor
                            </a>
                        </li>
                        <li class="nav-item px-2">
                            <a class="nav-link"
                                href="${pageContext.request.contextPath}${URL_BASE}/MesaController?opcao=listar">
                                <i class="fa-solid fa-chair"></i> Mesa
                            </a>
                        </li>
                        <li class="nav-item px-2">
                            <a class="nav-link"
                                href="${pageContext.request.contextPath}${URL_BASE}/TurnosController?opcao=listar">
                                <i class="fa-solid fa-clock"></i> Turnos
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
            <div class="containerr">
                <h1>Cadastro de Cliente</h1>
                <c:if test="${not empty mensagem}">
                    <div class="mensagem">${mensagem}</div>
                </c:if>
                <form method="get" action="${pageContext.request.contextPath}${URL_BASE}/ClienteController">
                    <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}" />
                    <input type="hidden" name="codCliente" value="${empty codCliente ? 0 : codCliente}" />
                    <div class="form-group">
                        <label>Nome:</label>
                        <input type="text" name="nomeCliente" value="${nomeCliente}" required />
                    </div>
                    <div class="form-group">
                        <label>CPF:</label>
                        <input type="text" name="cpfCliente" value="${cpfCliente}" />
                    </div>
                    <div class="form-group">
                        <label>Senha:</label>
                        <input type="password" name="senhaCliente" value="${senhaCliente}" />
                    </div>
                    <div class="form-group">
                        <label>Telefone:</label>
                        <input type="text" name="telefone" value="${telefone}" />
                    </div>
                    <div class="form-group">
                        <label>Data Cadastro:</label>
                        <input class="cadastroInput" type="text" name="dataCadastro" readonly=""
                            value="${dataCadastro}" />
                    </div>
                    <button type="submit" class="btn-salvar">Salvar</button>
                </form>
                <form method="get" action="${pageContext.request.contextPath}${URL_BASE}/ClienteController">
                    <input type="hidden" name="opcao" value="cancelar" />
                    <button type="submit" class="btn-cancelar">Cancelar</button>
                </form>
                <c:if test="${not empty clientes}">
                    <div class="table-wrapper">
                        <table>
                            <caption>Clientes Cadastrados</caption>
                            <tr>
                                <th>Código</th>
                                <th>Nome</th>
                                <th>CPF</th>
                                <th>Telefone</th>
                                <th>Data Cadastro</th>
                                <th>Ações</th>
                            </tr>
                            <c:forEach var="item" items="${clientes}">
                                <tr>
                                    <td>${item.codCliente}</td>
                                    <td>${item.nomeCliente}</td>
                                    <td>${item.cpfCliente}</td>
                                    <td>${item.telefone}</td>
                                    <td>${item.dataCadastro}</td>
                                    <td>
                                        <form method="get"
                                            action="${pageContext.request.contextPath}${URL_BASE}/ClienteController"
                                            style="display:inline">
                                            <input type="hidden" name="opcao" value="enviarAlterar" />
                                            <input type="hidden" name="codCliente" value="${item.codCliente}" />
                                            <input type="hidden" name="nomeCliente" value="${item.nomeCliente}" />
                                            <input type="hidden" name="cpfCliente" value="${item.cpfCliente}" />
                                            <input type="hidden" name="senhaCliente" value="${item.senhaCliente}" />
                                            <input type="hidden" name="telefone" value="${item.telefone}" />
                                            <input type="hidden" name="dataCadastro" value="${item.dataCadastro}" />
                                            <button type="submit" class="btn-alterar">Alterar</button>
                                        </form>
                                        <form method="get"
                                            action="${pageContext.request.contextPath}${URL_BASE}/ClienteController"
                                            style="display:inline">
                                            <input type="hidden" name="opcao" value="enviarExcluir" />
                                            <input type="hidden" name="codCliente" value="${item.codCliente}" />
                                            <input type="hidden" name="nomeCliente" value="${item.nomeCliente}" />
                                            <input type="hidden" name="cpfCliente" value="${item.cpfCliente}" />
                                            <input type="hidden" name="senhaCliente" value="${item.senhaCliente}" />
                                            <input type="hidden" name="telefone" value="${item.telefone}" />
                                            <input type="hidden" name="dataCadastro" value="${item.dataCadastro}" />
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