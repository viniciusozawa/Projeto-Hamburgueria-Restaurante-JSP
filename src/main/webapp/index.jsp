<%-- 
    Document   : index
    Created on : 21 de jun. de 2026, 10:15:41
    Author     : yuji
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Big Tites — Sistema de Gerenciamento</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="styles/estilo.css">
    </head>
    <body>
        <%@include file="menu.jsp" %>

        <!-- ===== HERO ===== -->
        <section class="hero-section">
            <div class="hero-bg"></div>
            <div class="hero-content">
                <div class="hero-logo">
                    <i class="fa-solid fa-burger"></i>
                </div>
                <h1 class="hero-title"><span class="accent">Big</span> Tites</h1>
                <p class="hero-sub">Sistema completo de gerenciamento para sua hamburgueria — cadastros, estoque, cardápio e muito mais.</p>
                <a href="#modulos" class="btn btn-warning btn-lg px-5 fw-bold rounded-pill">
                    <i class="fa-solid fa-rocket me-2"></i>Acessar Sistema
                </a>
            </div>
        </section>

        <!-- ===== STATS BAR ===== -->
        <div class="stats-bar">
            <div class="container">
                <div class="row justify-content-center text-center">
                    <div class="col stat-item">
                        <div class="stat-num">9</div>
                        <div class="stat-label">Módulos</div>
                    </div>
                    <div class="col stat-item">
                        <div class="stat-num"><i class="fa-solid fa-database" style="font-size:1.4rem; color:var(--primary)"></i></div>
                        <div class="stat-label">CRUD Completo</div>
                    </div>
                    <div class="col stat-item">
                        <div class="stat-num"><i class="fa-solid fa-link" style="font-size:1.4rem; color:var(--primary)"></i></div>
                        <div class="stat-label">Relacionamentos</div>
                    </div>
                    <div class="col stat-item">
                        <div class="stat-num"><i class="fa-solid fa-mobile-screen" style="font-size:1.4rem; color:var(--primary)"></i></div>
                        <div class="stat-label">Responsivo</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ===== MÓDULOS ===== -->
        <section class="modules-section" id="modulos">
            <h2 class="section-title"><i class="fa-solid fa-table-cells-large me-2"></i>Módulos do Sistema</h2>
            <p class="section-sub">Selecione um módulo para gerenciar os cadastros da hamburgueria</p>

            <div class="row row-cols-2 row-cols-sm-3 row-cols-md-3 g-3">

                <div class="col">
                    <a class="module-card" href="com/mycompany/restaurantehamburgueria/controller/CargoController?opcao=listar">
                        <i class="fa-solid fa-id-badge mod-icon"></i>
                        <span class="mod-name">Cargo</span>
                        <span class="mod-desc">Funções e cargos</span>
                    </a>
                </div>

                <div class="col">
                    <a class="module-card" href="com/mycompany/restaurantehamburgueria/controller/CategoriaController?opcao=listar">
                        <i class="fa-solid fa-tags mod-icon"></i>
                        <span class="mod-name">Categoria</span>
                        <span class="mod-desc">Categorias de pratos</span>
                    </a>
                </div>

                <div class="col">
                    <a class="module-card" href="com/mycompany/restaurantehamburgueria/controller/ClienteController?opcao=listar">
                        <i class="fa-solid fa-users mod-icon"></i>
                        <span class="mod-name">Cliente</span>
                        <span class="mod-desc">Base de clientes</span>
                    </a>
                </div>

                <div class="col">
                    <a class="module-card" href="com/mycompany/restaurantehamburgueria/controller/FornecedorController?opcao=listar">
                        <i class="fa-solid fa-truck mod-icon"></i>
                        <span class="mod-name">Fornecedor</span>
                        <span class="mod-desc">Parceiros e fornecedores</span>
                    </a>
                </div>

                <div class="col">
                    <a class="module-card" href="com/mycompany/restaurantehamburgueria/controller/MesaController?opcao=listar">
                        <i class="fa-solid fa-chair mod-icon"></i>
                        <span class="mod-name">Mesa</span>
                        <span class="mod-desc">Layout do salão</span>
                    </a>
                </div>

                <div class="col">
                    <a class="module-card" href="com/mycompany/restaurantehamburgueria/controller/TurnosController?opcao=listar">
                        <i class="fa-solid fa-clock mod-icon"></i>
                        <span class="mod-name">Turnos</span>
                        <span class="mod-desc">Horários de trabalho</span>
                    </a>
                </div>

                <div class="col">
                    <a class="module-card" href="com/mycompany/restaurantehamburgueria/controller/FuncionarioController?opcao=listar">
                        <i class="fa-solid fa-user-tie mod-icon"></i>
                        <span class="mod-name">Funcionário</span>
                        <span class="mod-desc">Equipe e colaboradores</span>
                    </a>
                </div>

                <div class="col">
                    <a class="module-card" href="com/mycompany/restaurantehamburgueria/controller/CardapioController?opcao=listar">
                        <i class="fa-solid fa-utensils mod-icon"></i>
                        <span class="mod-name">Cardápio</span>
                        <span class="mod-desc">Pratos e preços</span>
                    </a>
                </div>

                <div class="col">
                    <a class="module-card" href="com/mycompany/restaurantehamburgueria/controller/IngredienteController?opcao=listar">
                        <i class="fa-solid fa-carrot mod-icon"></i>
                        <span class="mod-name">Ingrediente</span>
                        <span class="mod-desc">Estoque e insumos</span>
                    </a>
                </div>

            </div>
        </section>

           <!-- ===== FOOTER ===== -->
        <footer>
            <i class="fa-solid fa-burger me-1"></i>
            <span class="brand">Big Tites</span> &copy; 2024 &mdash; Sistema de Gerenciamento
        </footer>
    </body>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</html>
