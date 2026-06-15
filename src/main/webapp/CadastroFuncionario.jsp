<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Funcionário — Big Tites</title>
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
            <i class="fa-solid fa-user-tie"></i>
            <h4>Cadastro de Funcionário</h4>
        </div>
        <div class="card-body">
            <c:if test="${not empty mensagem}">
                <div class="mensagem"><i class="fa-solid fa-circle-check"></i> ${mensagem}</div>
            </c:if>

            <form id="formCadastro" method="get"
                action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/FuncionarioController">
                <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}"/>
                <input type="hidden" name="codFuncionario" value="${empty codFuncionario ? 0 : codFuncionario}"/>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-user me-1 text-secondary"></i>Nome</label>
                        <input type="text" class="form-control" name="nomeFuncionario" value="${nomeFuncionario}" placeholder="Nome completo" required/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-cake-candles me-1 text-secondary"></i>Data de Nascimento</label>
                        <input type="date" class="form-control" name="dataNascimento" value="${dataNascimento}" required/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-id-card me-1 text-secondary"></i>CPF</label>
                        <input type="text" class="form-control" name="cpfFuncionario" value="${cpfFuncionario}" placeholder="000.000.000-00"/>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><i class="fa-solid fa-lock me-1 text-secondary"></i>Senha</label>
                        <input type="text" class="form-control" name="senhaFuncionario" value="${senhaFuncionario}" required/>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><i class="fa-solid fa-money-bill-wave me-1 text-secondary"></i>Salário (R$)</label>
                        <input type="number" step="0.01" class="form-control" name="salarioFuncionario" value="${salarioFuncionario}" placeholder="0,00" required/>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><i class="fa-solid fa-clock me-1 text-secondary"></i>Turno</label>
                        <select class="form-select" name="codTurnos" required>
                            <c:forEach var="t" items="${turnos}">
                                <option value="${t.codTurnos}" <c:if test="${t.codTurnos == codTurnosAtual}">selected</c:if>>
                                    ${t.horarioInicio} — ${t.horarioFinal}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><i class="fa-solid fa-id-badge me-1 text-secondary"></i>Cargo</label>
                        <select class="form-select" name="codCargo" required>
                            <c:forEach var="c" items="${cargos}">
                                <option value="${c.codCargo}" <c:if test="${c.codCargo == codCargoAtual}">selected</c:if>>
                                    ${c.nomeCargo}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </form>

            <div class="btn-actions">
                <button type="submit" form="formCadastro" class="btn-salvar">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                </button>
                <a href="${pageContext.request.contextPath}${URL_BASE}/FuncionarioController?opcao=listar" class="btn-cancelar">
                    <i class="fa-solid fa-ban"></i> Cancelar
                </a>
            </div>
        </div>
    </div>

    <c:if test="${not empty funcionarios}">
        <div class="card shadow-sm">
            <div class="card-header">
                <i class="fa-solid fa-list"></i>
                <h5>Funcionários Cadastrados</h5>
            </div>
            <div class="table-wrapper">
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Nome</th>
                            <th>Nascimento</th>
                            <th>CPF</th>
                            <th>Salário</th>
                            <th>Turno</th>
                            <th>Cargo</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${funcionarios}">
                            <tr>
                                <td>${item.codFuncionario}</td>
                                <td>${item.nomeFuncionario}</td>
                                <td>${item.dataNascimento}</td>
                                <td>${item.cpfFuncionario}</td>
                                <td>R$ ${item.salarioFuncionario}</td>
                                <td>${item.turnosFuncionario.horarioInicio} — ${item.turnosFuncionario.horarioFinal}</td>
                                <td>${item.cargoFuncionario.nomeCargo}</td>
                                <td>
                                    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/FuncionarioController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarAlterar"/>
                                        <input type="hidden" name="codFuncionario" value="${item.codFuncionario}"/>
                                        <input type="hidden" name="nomeFuncionario" value="${item.nomeFuncionario}"/>
                                        <input type="hidden" name="dataNascimento" value="${item.dataNascimento}"/>
                                        <input type="hidden" name="senhaFuncionario" value="${item.senhaFuncionario}"/>
                                        <input type="hidden" name="cpfFuncionario" value="${item.cpfFuncionario}"/>
                                        <input type="hidden" name="salarioFuncionario" value="${item.salarioFuncionario}"/>
                                        <input type="hidden" name="codTurnos" value="${item.turnosFuncionario.codTurnos}"/>
                                        <input type="hidden" name="codCargo" value="${item.cargoFuncionario.codCargo}"/>
                                        <button type="submit" class="btn-alterar"><i class="fa-solid fa-pencil"></i> Alterar</button>
                                    </form>
                                    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/FuncionarioController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarExcluir"/>
                                        <input type="hidden" name="codFuncionario" value="${item.codFuncionario}"/>
                                        <input type="hidden" name="nomeFuncionario" value="${item.nomeFuncionario}"/>
                                        <input type="hidden" name="dataNascimento" value="${item.dataNascimento}"/>
                                        <input type="hidden" name="senhaFuncionario" value="${item.senhaFuncionario}"/>
                                        <input type="hidden" name="cpfFuncionario" value="${item.cpfFuncionario}"/>
                                        <input type="hidden" name="salarioFuncionario" value="${item.salarioFuncionario}"/>
                                        <input type="hidden" name="codTurnos" value="${item.turnosFuncionario.codTurnos}"/>
                                        <input type="hidden" name="codCargo" value="${item.cargoFuncionario.codCargo}"/>
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
