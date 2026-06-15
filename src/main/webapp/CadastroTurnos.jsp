<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Turnos — Big Tites</title>
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
            <i class="fa-solid fa-clock"></i>
            <h4>Cadastro de Turnos</h4>
        </div>
        <div class="card-body">
            <c:if test="${not empty mensagem}">
                <div class="mensagem"><i class="fa-solid fa-circle-check"></i> ${mensagem}</div>
            </c:if>

            <form id="formCadastro" method="get"
                action="${pageContext.request.contextPath}${URL_BASE}/TurnosController">
                <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}"/>
                <input type="hidden" name="codTurnos" value="${empty codTurnos ? 0 : codTurnos}"/>
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label"><i class="fa-solid fa-play me-1 text-secondary"></i>Horário de Início</label>
                        <input type="time" class="form-control" name="horarioInicio" value="${horarioInicio}" required/>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><i class="fa-solid fa-stop me-1 text-secondary"></i>Horário Final</label>
                        <input type="time" class="form-control" name="horarioFinal" value="${horarioFinal}" required/>
                    </div>
                </div>
            </form>

            <div class="btn-actions">
                <button type="submit" form="formCadastro" class="btn-salvar">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                </button>
                <a href="${pageContext.request.contextPath}${URL_BASE}/TurnosController?opcao=listar" class="btn-cancelar">
                    <i class="fa-solid fa-ban"></i> Cancelar
                </a>
            </div>
        </div>
    </div>

    <c:if test="${not empty turnos}">
        <div class="card shadow-sm">
            <div class="card-header">
                <i class="fa-solid fa-list"></i>
                <h5>Turnos Cadastrados</h5>
            </div>
            <div class="table-wrapper">
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Início</th>
                            <th>Final</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${turnos}">
                            <tr>
                                <td>${item.codTurnos}</td>
                                <td><i class="fa-solid fa-play fa-xs text-success me-1"></i>${item.horarioInicio}</td>
                                <td><i class="fa-solid fa-stop fa-xs text-danger me-1"></i>${item.horarioFinal}</td>
                                <td>
                                    <form method="get" action="${pageContext.request.contextPath}${URL_BASE}/TurnosController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarAlterar"/>
                                        <input type="hidden" name="codTurnos" value="${item.codTurnos}"/>
                                        <input type="hidden" name="horarioInicio" value="${item.horarioInicio}"/>
                                        <input type="hidden" name="horarioFinal" value="${item.horarioFinal}"/>
                                        <button type="submit" class="btn-alterar"><i class="fa-solid fa-pencil"></i> Alterar</button>
                                    </form>
                                    <form method="get" action="${pageContext.request.contextPath}${URL_BASE}/TurnosController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarExcluir"/>
                                        <input type="hidden" name="codTurnos" value="${item.codTurnos}"/>
                                        <input type="hidden" name="horarioInicio" value="${item.horarioInicio}"/>
                                        <input type="hidden" name="horarioFinal" value="${item.horarioFinal}"/>
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
