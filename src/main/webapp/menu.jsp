<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Menu</title>

        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="styles/estilo.css">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark px-4" id="mainNav">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/index.html">
                <i class="fa-solid fa-burger me-1"></i> Big Tites
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#menuNav" aria-controls="menuNav" aria-expanded="false">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="menuNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item px-1">
                        <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/CargoController?opcao=listar">
                            <i class="fa-solid fa-id-badge me-1"></i>Cargo
                        </a>
                    </li>
                    <li class="nav-item px-1">
                        <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/CategoriaController?opcao=listar">
                            <i class="fa-solid fa-tags me-1"></i>Categoria
                        </a>
                    </li>
                    <li class="nav-item px-1">
                        <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/ClienteController?opcao=listar">
                            <i class="fa-solid fa-user me-1"></i>Cliente
                        </a>
                    </li>
                    <li class="nav-item px-1">
                        <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/FornecedorController?opcao=listar">
                            <i class="fa-solid fa-truck me-1"></i>Fornecedor
                        </a>
                    </li>
                    <li class="nav-item px-1">
                        <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/MesaController?opcao=listar">
                            <i class="fa-solid fa-chair me-1"></i>Mesa
                        </a>
                    </li>
                    <li class="nav-item px-1">
                        <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/TurnosController?opcao=listar">
                            <i class="fa-solid fa-clock me-1"></i>Turnos
                        </a>
                    </li>
                    <li class="nav-item px-1">
                        <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/FuncionarioController?opcao=listar">
                            <i class="fa-solid fa-user-tie me-1"></i>Funcionário
                        </a>
                    </li>
                    <li class="nav-item px-1">
                        <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/CardapioController?opcao=listar">
                            <i class="fa-solid fa-utensils me-1"></i>Cardápio
                        </a>
                    </li>
                    <li class="nav-item px-1">
                        <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/IngredienteController?opcao=listar">
                            <i class="fa-solid fa-carrot me-1"></i>Ingrediente
                        </a>
                    </li>
                    <li class="nav-item px-1">
                        <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/PedidoController?opcao=listar">
                            <i class="fa-solid fa-receipt me-1"></i>Pedido
                        </a>
                    </li>
                    <li class="nav-item px-1">
                        <a class="nav-link" href="${pageContext.request.contextPath}${URL_BASE}/PagamentoController?opcao=listar">
                            <i class="fa-solid fa-credit-card me-1"></i>Pagamento
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
        <script>
            /* Marca o link ativo com base no controller na URL atual */
            document.addEventListener('DOMContentLoaded', function () {
                var url = window.location.href;
                document.querySelectorAll('#mainNav .nav-link').forEach(function (link) {
                    var controller = (link.getAttribute('href') || '').split('/').pop().split('?')[0];
                    if (controller && url.indexOf(controller) !== -1) {
                        link.classList.add('active');
                    }
                });
            });


        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>