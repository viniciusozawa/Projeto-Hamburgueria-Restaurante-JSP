<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Cadastro de Funcionario</title>
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}${URL_BASE}/FuncionarioController?opcao=listar">
                        <i class="fa-solid fa-user-tie"></i> Funcionario
                    </a>
                </li>
                <li class="nav-item px-2">
                    <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/CardapioController?opcao=listar">
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
        <h1>Cadastro de Funcionario</h1>
        <c:if test="${not empty mensagem}">
            <div class="mensagem">${mensagem}</div>
        </c:if>

        <form id="formCadastro" method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/FuncionarioController">
            <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}" />
            <input type="hidden" name="codFuncionario" value="${empty codFuncionario ? 0 : codFuncionario}" />

            <div class="form-group">
                <label>Nome:</label>
                <input type="text" name="nomeFuncionario" value="${nomeFuncionario}" required />
            </div>
            <div class="form-group">
                <label>Data de Nascimento:</label>
                <input type="date" name="dataNascimento" value="${dataNascimento}" required />
            </div>
            <div class="form-group">
                <label>CPF:</label>
                <input type="text" name="cpfFuncionario" value="${cpfFuncionario}" />
            </div>
            <div class="form-group">
                <label>Senha:</label>
                <input type="text" name="senhaFuncionario" value="${senhaFuncionario}" required />
            </div>
            <div class="form-group">
                <label>Salario:</label>
                <input type="number" step="0.01" name="salarioFuncionario" value="${salarioFuncionario}" required />
            </div>
            <div class="form-group">
                <label>Turno:</label>
                <select name="codTurnos" required>
                    <c:forEach var="t" items="${turnos}">
                        <option value="${t.codTurnos}" <c:if test="${t.codTurnos == codTurnosAtual}">selected</c:if>>
                            ${t.horarioInicio} - ${t.horarioFinal}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label>Cargo:</label>
                <select name="codCargo" required>
                    <c:forEach var="c" items="${cargos}">
                        <option value="${c.codCargo}" <c:if test="${c.codCargo == codCargoAtual}">selected</c:if>>
                            ${c.nomeCargo}
                        </option>
                    </c:forEach>
                </select>
            </div>
        </form>
        <div class="btn-actions">
            <button type="submit" form="formCadastro" class="btn-salvar">Salvar</button>
            <a href="${pageContext.request.contextPath}${URL_BASE}/FuncionarioController?opcao=listar" class="btn-cancelar">Cancelar</a>
        </div>

        <c:if test="${not empty funcionarios}">
            <div class="table-wrapper">
                <table>
                    <caption>Funcionarios Cadastrados</caption>
                    <tr>
                        <th>Codigo</th>
                        <th>Nome</th>
                        <th>Nascimento</th>
                        <th>CPF</th>
                        <th>Salario</th>
                        <th>Turno</th>
                        <th>Cargo</th>
                        <th>Acoes</th>
                    </tr>
                    <c:forEach var="item" items="${funcionarios}">
                        <tr>
                            <td>${item.codFuncionario}</td>
                            <td>${item.nomeFuncionario}</td>
                            <td>${item.dataNascimento}</td>
                            <td>${item.cpfFuncionario}</td>
                            <td>${item.salarioFuncionario}</td>
                            <td>${item.turnosFuncionario.horarioInicio} - ${item.turnosFuncionario.horarioFinal}</td>
                            <td>${item.cargoFuncionario.nomeCargo}</td>
                            <td>
                                <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/FuncionarioController" style="display:inline">
                                    <input type="hidden" name="opcao" value="enviarAlterar" />
                                    <input type="hidden" name="codFuncionario" value="${item.codFuncionario}" />
                                    <input type="hidden" name="nomeFuncionario" value="${item.nomeFuncionario}" />
                                    <input type="hidden" name="dataNascimento" value="${item.dataNascimento}" />
                                    <input type="hidden" name="senhaFuncionario" value="${item.senhaFuncionario}" />
                                    <input type="hidden" name="cpfFuncionario" value="${item.cpfFuncionario}" />
                                    <input type="hidden" name="salarioFuncionario" value="${item.salarioFuncionario}" />
                                    <input type="hidden" name="codTurnos" value="${item.turnosFuncionario.codTurnos}" />
                                    <input type="hidden" name="codCargo" value="${item.cargoFuncionario.codCargo}" />
                                    <button type="submit" class="btn-alterar">Alterar</button>
                                </form>
                                <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/FuncionarioController" style="display:inline">
                                    <input type="hidden" name="opcao" value="enviarExcluir" />
                                    <input type="hidden" name="codFuncionario" value="${item.codFuncionario}" />
                                    <input type="hidden" name="nomeFuncionario" value="${item.nomeFuncionario}" />
                                    <input type="hidden" name="dataNascimento" value="${item.dataNascimento}" />
                                    <input type="hidden" name="senhaFuncionario" value="${item.senhaFuncionario}" />
                                    <input type="hidden" name="cpfFuncionario" value="${item.cpfFuncionario}" />
                                    <input type="hidden" name="salarioFuncionario" value="${item.salarioFuncionario}" />
                                    <input type="hidden" name="codTurnos" value="${item.turnosFuncionario.codTurnos}" />
                                    <input type="hidden" name="codCargo" value="${item.cargoFuncionario.codCargo}" />
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
