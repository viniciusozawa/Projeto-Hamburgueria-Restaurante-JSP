<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session.getAttribute("gerente") == null) {
        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }
    String nomeGerente = (String) session.getAttribute("gerente");
    String URL_BASE = "/com/mycompany/restaurantehamburgueria/controller";
    String paginaAtiva = "fornecedor";
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fornecedores - Painel do Gerente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/gerente.css">
</head>
<body>
<div class="d-flex">

    <%@ include file="gerente/sidebar.jsp" %>

    <!-- CONTEÚDO -->
    <div class="admin-content">
        <div class="admin-topbar">
            <div class="topbar-left">
                <button id="sidebarToggle" onclick="toggleSidebar()"><i class="fa-solid fa-bars"></i></button>
                <div>
                    <div class="topbar-title">Fornecedores</div>
                    <div class="topbar-breadcrumb">
                        <i class="fa-solid fa-house fa-xs"></i>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <a href="${pageContext.request.contextPath}/gerente/dashboard.jsp">Dashboard</a>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <span>Fornecedores</span>
                    </div>
                </div>
            </div>
            <div class="topbar-right">
                <div class="d-flex align-items-center gap-2">
                    <div class="rounded-circle bg-warning d-flex align-items-center justify-content-center"
                         style="width:34px;height:34px;color:#fff;font-size:0.85rem;">
                        <i class="fa-solid fa-user-tie"></i>
                    </div>
                    <span class="fw-semibold small d-none d-md-inline"><%= nomeGerente %></span>
                </div>
            </div>
        </div>

        <div class="admin-page">

            <c:if test="${not empty mensagem}">
                <div class="admin-mensagem">
                    <i class="fa-solid fa-circle-check"></i> ${mensagem}
                </div>
            </c:if>

            <div class="admin-card mb-4">
                <div class="admin-card-header">
                    <h5><i class="fa-solid fa-truck"></i> ${empty opcao ? 'Novo Fornecedor' : 'Gerenciar Fornecedor'}</h5>
                </div>
                <div class="admin-card-body admin-form">
                    <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/FornecedorController">
                        <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}" />
                        <input type="hidden" name="codFornecedor" value="${empty codFornecedor ? 0 : codFornecedor}" />
                        <div class="row g-3">
                            <div class="col-md-5">
                                <label class="form-label">Nome do Fornecedor</label>
                                <input type="text" class="form-control" name="nomeFornecedor"
                                       value="${nomeFornecedor}" placeholder="Razão social" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">CNPJ</label>
                                <input type="text" class="form-control" name="cnpj"
                                       value="${cnpj}" placeholder="00.000.000/0001-00" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Endereço</label>
                                <input type="text" class="form-control" name="endereco"
                                       value="${endereco}" placeholder="Rua, número" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Bairro</label>
                                <input type="text" class="form-control" name="bairro"
                                       value="${bairro}" placeholder="Bairro" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Cidade</label>
                                <input type="text" class="form-control" name="cidade"
                                       value="${cidade}" placeholder="Cidade" />
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Estado (UF)</label>
                                <input type="text" class="form-control" name="estado"
                                       value="${estado}" placeholder="MG" maxlength="2" />
                            </div>
                            <div class="col-12 d-flex gap-2 mt-1">
                                <button type="submit" class="btn-admin-salvar">
                                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                                </button>
                                <a href="${pageContext.request.contextPath}<%= URL_BASE %>/FornecedorController?opcao=cancelar"
                                   class="btn-admin-cancelar text-decoration-none">
                                    <i class="fa-solid fa-xmark"></i> Cancelar
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <c:if test="${not empty fornecedores}">
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h5><i class="fa-solid fa-list"></i> Fornecedores Cadastrados</h5>
                    </div>
                    <div class="admin-card-body p-0">
                        <div class="table-responsive">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Nome</th>
                                        <th>CNPJ</th>
                                        <th>Cidade/UF</th>
                                        <th class="text-end">Ações</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${fornecedores}">
                                        <tr>
                                            <td class="text-muted">${item.codFornecedor}</td>
                                            <td><strong>${item.nomeFornecedor}</strong></td>
                                            <td class="text-muted small">${item.cnpj}</td>
                                            <td class="text-muted small">${item.cidade}/${item.estado}</td>
                                            <td class="text-end actions-cell">
                                                <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/FornecedorController" style="display:inline">
                                                    <input type="hidden" name="opcao" value="enviarAlterar" />
                                                    <input type="hidden" name="codFornecedor" value="${item.codFornecedor}" />
                                                    <input type="hidden" name="nomeFornecedor" value="${item.nomeFornecedor}" />
                                                    <input type="hidden" name="cnpj" value="${item.cnpj}" />
                                                    <input type="hidden" name="endereco" value="${item.endereco}" />
                                                    <input type="hidden" name="bairro" value="${item.bairro}" />
                                                    <input type="hidden" name="cidade" value="${item.cidade}" />
                                                    <input type="hidden" name="estado" value="${item.estado}" />
                                                    <button type="submit" class="btn-admin-alterar"><i class="fa-solid fa-pen"></i> Alterar</button>
                                                </form>
                                                <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/FornecedorController" style="display:inline">
                                                    <input type="hidden" name="opcao" value="enviarExcluir" />
                                                    <input type="hidden" name="codFornecedor" value="${item.codFornecedor}" />
                                                    <input type="hidden" name="nomeFornecedor" value="${item.nomeFornecedor}" />
                                                    <input type="hidden" name="cnpj" value="${item.cnpj}" />
                                                    <input type="hidden" name="endereco" value="${item.endereco}" />
                                                    <input type="hidden" name="bairro" value="${item.bairro}" />
                                                    <input type="hidden" name="cidade" value="${item.cidade}" />
                                                    <input type="hidden" name="estado" value="${item.estado}" />
                                                    <button type="submit" class="btn-admin-excluir"><i class="fa-solid fa-trash"></i> Excluir</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"
     style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:999;"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleSidebar() {
        const sidebar = document.getElementById('adminSidebar');
        const overlay = document.getElementById('sidebarOverlay');
        const isOpen  = sidebar.classList.contains('show');
        sidebar.classList.toggle('show', !isOpen);
        overlay.style.display = isOpen ? 'none' : 'block';
    }
</script>
</body>
</html>
