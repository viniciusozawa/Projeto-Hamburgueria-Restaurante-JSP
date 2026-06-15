<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cliente — Big Tites</title>
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
            <i class="fa-solid fa-users"></i>
            <h4>Cadastro de Cliente</h4>
        </div>
        <div class="card-body">
            <c:if test="${not empty mensagem}">
                <div class="mensagem"><i class="fa-solid fa-circle-check"></i> ${mensagem}</div>
            </c:if>

            <form id="formCadastro" method="get"
                action="${pageContext.request.contextPath}${URL_BASE}/ClienteController">
                <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}"/>
                <input type="hidden" name="codCliente" value="${empty codCliente ? 0 : codCliente}"/>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-user me-1 text-secondary"></i>Nome</label>
                        <input type="text" class="form-control" name="nomeCliente" value="${nomeCliente}" placeholder="Nome completo" required/>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-id-card me-1 text-secondary"></i>CPF</label>
                        <input type="text" class="form-control" name="cpfCliente" value="${cpfCliente}" placeholder="000.000.000-00"/>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-lock me-1 text-secondary"></i>Senha</label>
                        <input type="password" class="form-control" name="senhaCliente" value="${senhaCliente}" placeholder="Senha de acesso"/>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-phone me-1 text-secondary"></i>Telefone</label>
                        <input type="text" class="form-control" name="telefone" value="${telefone}" placeholder="(00) 00000-0000"/>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-calendar me-1 text-secondary"></i>Data de Cadastro</label>
                        <input type="text" class="form-control" name="dataCadastro" value="${dataCadastro}" readonly/>
                    </div>
                </div>
            </form>

            <div class="btn-actions">
                <button type="submit" form="formCadastro" class="btn-salvar">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                </button>
                <a href="${pageContext.request.contextPath}${URL_BASE}/ClienteController?opcao=listar" class="btn-cancelar">
                    <i class="fa-solid fa-ban"></i> Cancelar
                </a>
            </div>
        </div>
    </div>

    <c:if test="${not empty clientes}">
        <div class="card shadow-sm">
            <div class="card-header">
                <i class="fa-solid fa-list"></i>
                <h5>Clientes Cadastrados</h5>
            </div>
            <div class="table-wrapper">
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Nome</th>
                            <th>CPF</th>
                            <th>Telefone</th>
                            <th>Data Cadastro</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
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
                                        <button type="submit" class="btn-alterar"><i class="fa-solid fa-pencil"></i> Alterar</button>
                                    </form>
                                    <form method="get" action="${pageContext.request.contextPath}${URL_BASE}/ClienteController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarExcluir"/>
                                        <input type="hidden" name="codCliente" value="${item.codCliente}"/>
                                        <input type="hidden" name="nomeCliente" value="${item.nomeCliente}"/>
                                        <input type="hidden" name="cpfCliente" value="${item.cpfCliente}"/>
                                        <input type="hidden" name="senhaCliente" value="${item.senhaCliente}"/>
                                        <input type="hidden" name="telefone" value="${item.telefone}"/>
                                        <input type="hidden" name="dataCadastro" value="${item.dataCadastro}"/>
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
