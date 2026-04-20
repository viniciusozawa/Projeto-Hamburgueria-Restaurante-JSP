<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@page contentType="text/html" pageEncoding="Latin1" %>
        <!DOCTYPE html>
        <html lang="pt-BR">

        <head>
            <meta charset="UTF-8">
            <title>Cadastro de Fornecedor</title>
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
                <h1>Cadastro de Fornecedor</h1>
                <c:if test="${not empty mensagem}">
                    <div class="mensagem">${mensagem}</div>
                </c:if>
                <form method="get"
                    action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/FornecedorController">
                    <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}" />
                    <input type="hidden" name="codFornecedor" value="${empty codFornecedor ? 0 : codFornecedor}" />
                    <div class="form-group">
                        <label>Nome:</label>
                        <input type="text" name="nomeFornecedor" value="${nomeFornecedor}" required />
                    </div>
                    <div class="form-group">
                        <label>CNPJ:</label>
                        <input type="text" name="cnpj" value="${cnpj}" />
                    </div>
                    <div class="form-group">
                        <label>Endereço:</label>
                        <input type="text" name="endereco" value="${endereco}" />
                    </div>
                    <div class="form-group">
                        <label>Bairro:</label>
                        <input type="text" name="bairro" value="${bairro}" />
                    </div>
                    <div class="form-group">
                        <label>Cidade:</label>
                        <input type="text" name="cidade" value="${cidade}" />
                    </div>
                    <div class="form-group">
                        <label>Estado (UF):</label>
                        <input type="text" name="estado" value="${estado}" maxlength="2" />
                    </div>
                    <button type="submit" class="btn-salvar">Salvar</button>
                </form>
                <form method="get"
                    action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/FornecedorController">
                    <input type="hidden" name="opcao" value="cancelar" />
                    <button type="submit" class="btn-cancelar">Cancelar</button>
                </form>
                <c:if test="${not empty fornecedores}">
                    <div class="table-wrapper">
                        <table>
                            <caption>Fornecedores Cadastrados</caption>
                            <tr>
                                <th>Código</th>
                                <th>Nome</th>
                                <th>CNPJ</th>
                                <th>Cidade</th>
                                <th>UF</th>
                                <th>Ações</th>
                            </tr>
                            <c:forEach var="item" items="${fornecedores}">
                                <tr>
                                    <td>${item.codFornecedor}</td>
                                    <td>${item.nomeFornecedor}</td>
                                    <td>${item.cnpj}</td>
                                    <td>${item.cidade}</td>
                                    <td>${item.estado}</td>
                                    <td>
                                        <form method="get"
                                            action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/FornecedorController"
                                            style="display:inline">
                                            <input type="hidden" name="opcao" value="enviarAlterar" />
                                            <input type="hidden" name="codFornecedor" value="${item.codFornecedor}" />
                                            <input type="hidden" name="nomeFornecedor" value="${item.nomeFornecedor}" />
                                            <input type="hidden" name="cnpj" value="${item.cnpj}" />
                                            <input type="hidden" name="endereco" value="${item.endereco}" />
                                            <input type="hidden" name="bairro" value="${item.bairro}" />
                                            <input type="hidden" name="cidade" value="${item.cidade}" />
                                            <input type="hidden" name="estado" value="${item.estado}" />
                                            <button type="submit" class="btn-alterar">Alterar</button>
                                        </form>
                                        <form method="get"
                                            action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/FornecedorController"
                                            style="display:inline">

                                            <input type="hidden" name="opcao" value="enviarExcluir" />
                                            <input type="hidden" name="codFornecedor" value="${item.codFornecedor}" />
                                            <input type="hidden" name="nomeFornecedor" value="${item.nomeFornecedor}" />
                                            <input type="hidden" name="cnpj" value="${item.cnpj}" />
                                            <input type="hidden" name="endereco" value="${item.endereco}" />
                                            <input type="hidden" name="bairro" value="${item.bairro}" />
                                            <input type="hidden" name="cidade" value="${item.cidade}" />
                                            <input type="hidden" name="estado" value="${item.estado}" />
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