<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session.getAttribute("gerente") == null) {
        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }
    String nomeGerente = (String) session.getAttribute("gerente");
    String URL_BASE = "/com/mycompany/restaurantehamburgueria/controller";
    String paginaAtiva = "funcionario";
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Funcionários - Painel do Gerente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/gerente.css">
</head>
<body>
<div class="d-flex">

    <%@ include file="gerente/sidebar.jsp" %>

    <div class="admin-content">
        <div class="admin-topbar">
            <div class="topbar-left">
                <button id="sidebarToggle" onclick="toggleSidebar()"><i class="fa-solid fa-bars"></i></button>
                <div>
                    <div class="topbar-title">Funcionários</div>
                    <div class="topbar-breadcrumb">
                        <i class="fa-solid fa-house fa-xs"></i>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <a href="${pageContext.request.contextPath}/gerente/dashboard.jsp">Dashboard</a>
                        <i class="fa-solid fa-chevron-right fa-xs opacity-50"></i>
                        <span>Funcionários</span>
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
                    <h5><i class="fa-solid fa-user-gear"></i>
                        ${empty opcao || opcao == 'cadastrar' ? 'Novo Funcionário' : opcao == 'confirmarAlterar' ? 'Alterar Funcionário' : opcao == 'confirmarExcluir' ? 'Excluir Funcionário' : 'Novo Funcionário'}
                    </h5>
                </div>
                <div class="admin-card-body admin-form">
                    <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/FuncionarioController">
                        <input type="hidden" name="opcao" value="${empty opcao ? 'cadastrar' : opcao}" />
                        <input type="hidden" name="codFuncionario" value="${empty codFuncionario ? 0 : codFuncionario}" />
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Nome</label>
                                <input type="text" class="form-control" name="nomeFuncionario" value="${nomeFuncionario}" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Data de Nascimento</label>
                                <input type="date" class="form-control" name="dataNascimento" value="${dataNascimento}" />
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Senha</label>
                                <input type="text" class="form-control" name="senhaFuncionario" value="${senhaFuncionario}" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">CPF</label>
                                <input type="text" class="form-control" name="cpfFuncionario" value="${cpfFuncionario}" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Salário (R$)</label>
                                <input type="number" step="0.01" class="form-control" name="salarioFuncionario" value="${salarioFuncionario}" required />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Cargo</label>
                                <select class="form-select" name="cargo_codCargo" required>
                                    <option value="">Selecione...</option>
                                    <c:forEach var="c" items="${cargos}">
                                        <option value="${c.codCargo}" ${codCargo_val == c.codCargo ? 'selected' : ''}>
                                            ${c.nomeCargo}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Turno</label>
                                <select class="form-select" name="turnos_codTurnos" required>
                                    <option value="">Selecione...</option>
                                    <c:forEach var="t" items="${turnos}">
                                        <option value="${t.codTurnos}">${t.horarioInicio} - ${t.horarioFinal}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-auto d-flex gap-2 align-items-end">
                                <button type="submit" class="btn-admin-salvar">
                                    <i class="fa-solid fa-floppy-disk"></i> Salvar
                                </button>
                                <a href="${pageContext.request.contextPath}<%= URL_BASE %>/FuncionarioController?opcao=cancelar"
                                   class="btn-admin-cancelar text-decoration-none">
                                    <i class="fa-solid fa-xmark"></i> Cancelar
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <c:if test="${not empty funcionarios}">
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h5><i class="fa-solid fa-list"></i> Funcionários Cadastrados</h5>
                    </div>
                    <div class="admin-card-body p-0">
                        <div class="table-responsive">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Nome</th>
                                        <th>CPF</th>
                                        <th>Cargo</th>
                                        <th>Turno</th>
                                        <th>Salário</th>
                                        <th>Status</th>
                                        <th class="text-end">Ações</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${funcionarios}">
                                        <tr>
                                            <td class="text-muted">${item.codFuncionario}</td>
                                            <td><strong>${item.nomeFuncionario}</strong></td>
                                            <td>${item.cpfFuncionario}</td>
                                            <td>${item.nomeCargo}</td>
                                            <td>${item.horarioTurno}</td>
                                            <td>R$ ${item.salarioFuncionario}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.disponivel == 1}">
                                                        <span class="badge-status" style="background:rgba(46,204,113,0.1);color:#2ecc71;">Disponível</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status" style="background:rgba(231,76,60,0.1);color:#e74c3c;">Indisponível</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end actions-cell">
                                                <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/FuncionarioController" style="display:inline">
                                                    <input type="hidden" name="opcao" value="enviarAlterar" />
                                                    <input type="hidden" name="codFuncionario" value="${item.codFuncionario}" />
                                                    <input type="hidden" name="nomeFuncionario" value="${item.nomeFuncionario}" />
                                                    <input type="hidden" name="cpfFuncionario" value="${item.cpfFuncionario}" />
                                                    <input type="hidden" name="senhaFuncionario" value="${item.senhaFuncionario}" />
                                                    <input type="hidden" name="salarioFuncionario" value="${item.salarioFuncionario}" />
                                                    <input type="hidden" name="turnos_codTurnos" value="${item.turnos_codTurnos}" />
                                                    <input type="hidden" name="cargo_codCargo" value="${item.cargo_codCargo}" />
                                                    <button type="submit" class="btn-admin-alterar">
                                                        <i class="fa-solid fa-pen"></i> Alterar
                                                    </button>
                                                </form>
                                                <form method="get" action="${pageContext.request.contextPath}<%= URL_BASE %>/FuncionarioController" style="display:inline">
                                                    <input type="hidden" name="opcao" value="enviarExcluir" />
                                                    <input type="hidden" name="codFuncionario" value="${item.codFuncionario}" />
                                                    <button type="submit" class="btn-admin-excluir">
                                                        <i class="fa-solid fa-trash"></i> Excluir
                                                    </button>
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
