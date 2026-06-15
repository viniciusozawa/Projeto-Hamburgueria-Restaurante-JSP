<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fornecedor — Big Tites</title>
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
            <i class="fa-solid fa-truck"></i>
            <h4>Cadastro de Fornecedor</h4>
        </div>
        <div class="card-body">
            <c:if test="${not empty mensagem}">
                <div class="mensagem"><i class="fa-solid fa-circle-check"></i> ${mensagem}</div>
            </c:if>

            <form id="formCadastro" method="get"
                action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/FornecedorController">
                <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}"/>
                <input type="hidden" name="codFornecedor" value="${empty codFornecedor ? 0 : codFornecedor}"/>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-building me-1 text-secondary"></i>Nome</label>
                        <input type="text" class="form-control" name="nomeFornecedor" value="${nomeFornecedor}" placeholder="Razão social" required/>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-file-lines me-1 text-secondary"></i>CNPJ</label>
                        <input type="text" class="form-control" name="cnpj" value="${cnpj}" placeholder="00.000.000/0001-00"/>
                    </div>
                    <div class="col-md-8">
                        <label class="form-label"><i class="fa-solid fa-map-marker-alt me-1 text-secondary"></i>Endereço</label>
                        <input type="text" class="form-control" name="endereco" value="${endereco}" placeholder="Rua, número"/>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><i class="fa-solid fa-map me-1 text-secondary"></i>Bairro</label>
                        <input type="text" class="form-control" name="bairro" value="${bairro}" placeholder="Bairro"/>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-city me-1 text-secondary"></i>Cidade</label>
                        <input type="text" class="form-control" name="cidade" value="${cidade}" placeholder="Cidade"/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fa-solid fa-flag me-1 text-secondary"></i>Estado (UF)</label>
                        <input type="text" class="form-control" name="estado" value="${estado}" maxlength="2" placeholder="MG"/>
                    </div>
                </div>
            </form>

            <div class="btn-actions">
                <button type="submit" form="formCadastro" class="btn-salvar">
                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                </button>
                <a href="${pageContext.request.contextPath}${URL_BASE}/FornecedorController?opcao=listar" class="btn-cancelar">
                    <i class="fa-solid fa-ban"></i> Cancelar
                </a>
            </div>
        </div>
    </div>

    <c:if test="${not empty fornecedores}">
        <div class="card shadow-sm">
            <div class="card-header">
                <i class="fa-solid fa-list"></i>
                <h5>Fornecedores Cadastrados</h5>
            </div>
            <div class="table-wrapper">
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Nome</th>
                            <th>CNPJ</th>
                            <th>Cidade</th>
                            <th>UF</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${fornecedores}">
                            <tr>
                                <td>${item.codFornecedor}</td>
                                <td>${item.nomeFornecedor}</td>
                                <td>${item.cnpj}</td>
                                <td>${item.cidade}</td>
                                <td>${item.estado}</td>
                                <td>
                                    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/FornecedorController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarAlterar"/>
                                        <input type="hidden" name="codFornecedor" value="${item.codFornecedor}"/>
                                        <input type="hidden" name="nomeFornecedor" value="${item.nomeFornecedor}"/>
                                        <input type="hidden" name="cnpj" value="${item.cnpj}"/>
                                        <input type="hidden" name="endereco" value="${item.endereco}"/>
                                        <input type="hidden" name="bairro" value="${item.bairro}"/>
                                        <input type="hidden" name="cidade" value="${item.cidade}"/>
                                        <input type="hidden" name="estado" value="${item.estado}"/>
                                        <button type="submit" class="btn-alterar"><i class="fa-solid fa-pencil"></i> Alterar</button>
                                    </form>
                                    <form method="get" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/FornecedorController" style="display:inline">
                                        <input type="hidden" name="opcao" value="enviarExcluir"/>
                                        <input type="hidden" name="codFornecedor" value="${item.codFornecedor}"/>
                                        <input type="hidden" name="nomeFornecedor" value="${item.nomeFornecedor}"/>
                                        <input type="hidden" name="cnpj" value="${item.cnpj}"/>
                                        <input type="hidden" name="endereco" value="${item.endereco}"/>
                                        <input type="hidden" name="bairro" value="${item.bairro}"/>
                                        <input type="hidden" name="cidade" value="${item.cidade}"/>
                                        <input type="hidden" name="estado" value="${item.estado}"/>
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
