<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="com.mycompany.restaurantehamburgueria.model.dao.CardapioDao" %>
<%@ page import="com.mycompany.restaurantehamburgueria.model.dao.CategoriaDao" %>
<%@ page import="com.mycompany.restaurantehamburgueria.model.dao.CardapioIngredienteDao" %>
<%@ page import="com.mycompany.restaurantehamburgueria.model.entity.Cardapio" %>
<%@ page import="com.mycompany.restaurantehamburgueria.model.entity.Categoria" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    CardapioDao cardapioDao = new CardapioDao();
    CategoriaDao categoriaDao = new CategoriaDao();
    CardapioIngredienteDao ingDao = new CardapioIngredienteDao();

    List<Cardapio> cardapios = cardapioDao.buscarTodos();
    List<Categoria> categorias = categoriaDao.buscarTodos();
    Map<Integer, List<String>> ingredientesMap = ingDao.buscarIngredientesPorTodosCardapios();

    request.setAttribute("cardapios", cardapios);
    request.setAttribute("categorias", categorias);
    request.setAttribute("ingredientesMap", ingredientesMap);

    String contextPath = request.getContextPath();
    String BASE_PATH = contextPath + "/com/mycompany/restaurantehamburgueria/controller";
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hamburgueria - Sabor que Conquista</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/cliente.css">
</head>
<body>

    <!-- ===== NAVBAR ===== -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top" id="mainNav">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">
                <i class="fa-solid fa-burger me-2 text-warning"></i>Hamburgueria
            </a>
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center gap-1">
                    <li class="nav-item"><a class="nav-link px-3" href="#inicio">Início</a></li>
                    <li class="nav-item"><a class="nav-link px-3" href="#cardapio">Cardápio</a></li>
                    <li class="nav-item"><a class="nav-link px-3" href="#sobre">Sobre</a></li>
                    <li class="nav-item"><a class="nav-link px-3" href="#contato">Contato</a></li>
                    <li class="nav-item ms-2">
                        <a class="btn btn-outline-warning btn-sm px-4 rounded-pill" href="${pageContext.request.contextPath}/login.html">
                            <i class="fa-solid fa-lock me-1"></i>Área do Gerente
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- ===== HERO ===== -->
    <section id="inicio" class="hero-section">
        <div class="hero-overlay"></div>
        <div class="container h-100 d-flex align-items-center justify-content-center">
            <div class="hero-content text-center text-white">
                <p class="hero-tagline text-warning text-uppercase mb-2">
                    <i class="fa-solid fa-fire me-2"></i>Artesanal &amp; Gourmet
                </p>
                <h1 class="hero-title">Sabor que<br><span class="text-warning">Conquista</span></h1>
                <p class="hero-subtitle mt-3 mb-4">
                    Hambúrgueres artesanais feitos com ingredientes<br class="d-none d-md-block">
                    selecionados e muito amor desde 2018
                </p>
                <div class="d-flex gap-3 justify-content-center flex-wrap">
                    <a href="#cardapio" class="btn btn-warning btn-lg px-5 rounded-pill fw-semibold">
                        <i class="fa-solid fa-utensils me-2"></i>Ver Cardápio
                    </a>
                    <a href="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/PedidoClienteController"
                       class="btn btn-outline-light btn-lg px-5 rounded-pill">
                        <i class="fa-solid fa-cart-shopping me-2"></i>Fazer Pedido
                    </a>
                </div>
            </div>
        </div>
        <a href="#diferenciais" class="hero-scroll-down">
            <i class="fa-solid fa-chevron-down"></i>
        </a>
    </section>

    <!-- ===== DIFERENCIAIS ===== -->
    <section id="diferenciais" class="py-5 bg-dark">
        <div class="container py-3">
            <div class="row g-4 text-center">
                <div class="col-md-4">
                    <div class="diferencial-card p-4">
                        <i class="fa-solid fa-star fa-2x text-warning mb-3 d-block"></i>
                        <h5 class="text-white fw-semibold">Ingredientes Premium</h5>
                        <p class="text-muted mb-0">Selecionamos os melhores ingredientes locais para garantir sabor e frescor em cada mordida.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="diferencial-card p-4">
                        <i class="fa-solid fa-bolt fa-2x text-warning mb-3 d-block"></i>
                        <h5 class="text-white fw-semibold">Preparo Rápido</h5>
                        <p class="text-muted mb-0">Seu pedido pronto em até 15 minutos, sem abrir mão da qualidade e do capricho.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="diferencial-card p-4">
                        <i class="fa-solid fa-heart fa-2x text-warning mb-3 d-block"></i>
                        <h5 class="text-white fw-semibold">Feito com Amor</h5>
                        <p class="text-muted mb-0">Cada hambúrguer é preparado com carinho e dedicação pela nossa equipe especializada.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== CARDÁPIO ===== -->
    <section id="cardapio" class="py-5 section-light">
        <div class="container py-3">
            <div class="text-center mb-5">
                <p class="section-tag text-warning text-uppercase fw-semibold">
                    <i class="fa-solid fa-burger me-2"></i>O que preparamos
                </p>
                <h2 class="section-title">Nosso <span class="text-warning">Cardápio</span></h2>
                <p class="text-muted">Cada receita é única, feita para surpreender seu paladar</p>
            </div>

            <!-- Filtros por categoria (dinâmicos) -->
            <div class="d-flex justify-content-center gap-2 mb-5 flex-wrap">
                <button class="btn btn-warning btn-sm rounded-pill px-4 filter-btn active" data-filter="todos">Todos</button>
                <c:forEach var="cat" items="${categorias}">
                    <button class="btn btn-outline-secondary btn-sm rounded-pill px-4 filter-btn"
                            data-filter="cat-${cat.codCategoria}">
                        ${cat.nomeCategoria}
                    </button>
                </c:forEach>
            </div>

            <!-- Itens do cardápio (dinâmicos do banco) -->
            <c:choose>
                <c:when test="${not empty cardapios}">
                    <div class="row g-4" id="menuGrid">
                        <c:forEach var="item" items="${cardapios}">
                            <div class="col-xl-3 col-md-6 menu-item" data-category="cat-${item.categoria_codCategoria}">
                                <div class="menu-card card h-100 border-0 shadow-sm">
                                    <div class="menu-img-wrapper">
                                        <%-- Imagem baseada na categoria --%>
                                        <c:choose>
                                            <c:when test="${item.nomeCategoria != null and (
                                                fn:containsIgnoreCase(item.nomeCategoria,'bebida') or
                                                fn:containsIgnoreCase(item.nomeCategoria,'drink') or
                                                fn:containsIgnoreCase(item.nomeCategoria,'suco'))}">
                                                <img src="https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400&q=80"
                                                     class="card-img-top menu-img" alt="${item.nomeComida}">
                                            </c:when>
                                            <c:when test="${item.nomeCategoria != null and (
                                                fn:containsIgnoreCase(item.nomeCategoria,'sobremesa') or
                                                fn:containsIgnoreCase(item.nomeCategoria,'doce') or
                                                fn:containsIgnoreCase(item.nomeCategoria,'milkshake'))}">
                                                <img src="https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400&q=80"
                                                     class="card-img-top menu-img" alt="${item.nomeComida}">
                                            </c:when>
                                            <c:when test="${item.nomeCategoria != null and (
                                                fn:containsIgnoreCase(item.nomeCategoria,'porcao') or
                                                fn:containsIgnoreCase(item.nomeCategoria,'porção') or
                                                fn:containsIgnoreCase(item.nomeCategoria,'petisco') or
                                                fn:containsIgnoreCase(item.nomeCategoria,'frita'))}">
                                                <img src="https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400&q=80"
                                                     class="card-img-top menu-img" alt="${item.nomeComida}">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80"
                                                     class="card-img-top menu-img" alt="${item.nomeComida}">
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${not empty item.nomeCategoria}">
                                            <span class="menu-badge badge bg-warning text-dark">${item.nomeCategoria}</span>
                                        </c:if>
                                    </div>
                                    <div class="card-body d-flex flex-column text-center p-4">
                                        <h5 class="card-title fw-bold mb-1">${item.nomeComida}</h5>

                                        <%-- Ingredientes --%>
                                        <c:set var="ings" value="${ingredientesMap[item.codCardapio]}" />
                                        <c:choose>
                                            <c:when test="${not empty ings}">
                                                <p class="card-text text-muted small flex-grow-1">
                                                    <c:forEach var="ing" items="${ings}" varStatus="st">
                                                        ${ing}<c:if test="${!st.last}">, </c:if>
                                                    </c:forEach>
                                                </p>
                                            </c:when>
                                            <c:when test="${not empty item.descricaoComida}">
                                                <p class="card-text text-muted small flex-grow-1">${item.descricaoComida}</p>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="card-text text-muted small flex-grow-1">Hambúrguer artesanal feito com ingredientes selecionados</p>
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="d-flex align-items-center justify-content-between mt-3">
                                            <span class="menu-price fw-bold text-warning fs-5">
                                                R$ <c:out value="${item.valorComida}" />
                                            </span>
                                            <a href="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/PedidoClienteController"
                                               class="btn btn-warning btn-sm rounded-pill px-3">
                                                <i class="fa-solid fa-cart-plus me-1"></i>Pedir
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <i class="fa-solid fa-burger fa-3x text-muted mb-3 d-block"></i>
                        <p class="text-muted">Cardápio em atualização. Volte em breve!</p>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="text-center mt-5">
                <a href="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/PedidoClienteController"
                   class="btn btn-warning btn-lg px-5 rounded-pill fw-semibold">
                    <i class="fa-solid fa-cart-shopping me-2"></i>Fazer Pedido Agora
                </a>
            </div>
        </div>
    </section>

    <!-- ===== SOBRE ===== -->
    <section id="sobre" class="py-5">
        <div class="container py-3">
            <div class="row align-items-center g-5">
                <div class="col-lg-6">
                    <div class="sobre-img-wrapper">
                        <img src="https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=700&q=80"
                             alt="Nossa cozinha" class="img-fluid rounded-4 shadow-lg">
                    </div>
                </div>
                <div class="col-lg-6">
                    <p class="section-tag text-warning text-uppercase fw-semibold">
                        <i class="fa-solid fa-store me-2"></i>Quem somos
                    </p>
                    <h2 class="section-title mb-4">Nossa <span class="text-warning">História</span></h2>
                    <p class="text-muted lh-lg">
                        Nascemos da paixão por hambúrgueres artesanais e do sonho de levar sabores únicos para nossa cidade.
                        Desde 2018, trabalhamos com ingredientes frescos e receitas exclusivas.
                    </p>
                    <p class="text-muted lh-lg">
                        Cada detalhe é pensado para proporcionar a melhor experiência gastronômica: do pão brioche
                        assado diariamente ao blend de carnes selecionado junto a produtores locais.
                    </p>
                    <div class="row mt-4 text-center g-3">
                        <div class="col-4">
                            <div class="stat-card p-3 rounded-3">
                                <h3 class="text-warning fw-bold mb-0">6+</h3>
                                <p class="text-muted small mb-0">Anos de história</p>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="stat-card p-3 rounded-3">
                                <h3 class="text-warning fw-bold mb-0">50k+</h3>
                                <p class="text-muted small mb-0">Clientes felizes</p>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="stat-card p-3 rounded-3">
                                <h3 class="text-warning fw-bold mb-0"><%=cardapios.size()%>+</h3>
                                <p class="text-muted small mb-0">Sabores únicos</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== DEPOIMENTOS ===== -->
    <section class="py-5 section-light">
        <div class="container py-3">
            <div class="text-center mb-5">
                <p class="section-tag text-warning text-uppercase fw-semibold">
                    <i class="fa-solid fa-quote-left me-2"></i>O que dizem nossos clientes
                </p>
                <h2 class="section-title">Depoimentos</h2>
            </div>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="depoimento-card p-4 rounded-4 h-100">
                        <div class="d-flex align-items-center mb-3">
                            <img src="https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=60&h=60&fit=crop&q=80" class="rounded-circle me-3" width="50" height="50" alt="Cliente">
                            <div>
                                <h6 class="mb-0 fw-semibold">Carlos Mendes</h6>
                                <div class="text-warning small">
                                    <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                                </div>
                            </div>
                        </div>
                        <p class="text-muted small mb-0">"O melhor hambúrguer que já comi! Simplesmente perfeito. Voltarei sempre!"</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="depoimento-card p-4 rounded-4 h-100">
                        <div class="d-flex align-items-center mb-3">
                            <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=60&h=60&fit=crop&q=80" class="rounded-circle me-3" width="50" height="50" alt="Cliente">
                            <div>
                                <h6 class="mb-0 fw-semibold">Ana Paula</h6>
                                <div class="text-warning small">
                                    <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                                </div>
                            </div>
                        </div>
                        <p class="text-muted small mb-0">"Atendimento nota 10 e os hambúrgueres são incríveis. Não tem igual na cidade!"</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="depoimento-card p-4 rounded-4 h-100">
                        <div class="d-flex align-items-center mb-3">
                            <img src="https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=60&h=60&fit=crop&q=80" class="rounded-circle me-3" width="50" height="50" alt="Cliente">
                            <div>
                                <h6 class="mb-0 fw-semibold">Roberto Silva</h6>
                                <div class="text-warning small">
                                    <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star-half-stroke"></i>
                                </div>
                            </div>
                        </div>
                        <p class="text-muted small mb-0">"Ambiente aconchegante, atendimento rápido e sabor excepcional. Virarei cliente fiel!"</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ===== CTA ===== -->
    <section class="cta-section py-5 text-white text-center">
        <div class="cta-overlay"></div>
        <div class="container position-relative py-4">
            <i class="fa-solid fa-burger fa-3x text-warning mb-3"></i>
            <h2 class="fw-bold mb-2">Pronto para o melhor hambúrguer da sua vida?</h2>
            <p class="mb-4 text-white-50 fs-5">Venha nos visitar ou faça seu pedido agora mesmo</p>
            <a href="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/PedidoClienteController"
               class="btn btn-warning btn-lg px-5 rounded-pill fw-semibold">
                <i class="fa-solid fa-utensils me-2"></i>Fazer Pedido
            </a>
        </div>
    </section>

    <!-- ===== FOOTER ===== -->
    <footer id="contato" class="bg-dark text-white pt-5 pb-3">
        <div class="container">
            <div class="row g-4 mb-4">
                <div class="col-lg-4">
                    <h5 class="fw-bold mb-3"><i class="fa-solid fa-burger text-warning me-2"></i>Hamburgueria</h5>
                    <p class="text-muted small lh-lg">O melhor hambúrguer artesanal da cidade, feito com ingredientes selecionados, receitas exclusivas e muito amor em cada preparo.</p>
                    <div class="d-flex gap-3 mt-3">
                        <a href="#" class="social-icon"><i class="fa-brands fa-instagram"></i></a>
                        <a href="#" class="social-icon"><i class="fa-brands fa-facebook"></i></a>
                        <a href="#" class="social-icon"><i class="fa-brands fa-whatsapp"></i></a>
                        <a href="#" class="social-icon"><i class="fa-brands fa-tiktok"></i></a>
                    </div>
                </div>
                <div class="col-lg-2 col-md-4">
                    <h6 class="text-warning fw-semibold mb-3">Navegação</h6>
                    <ul class="list-unstyled text-muted small">
                        <li class="mb-2"><a href="#inicio" class="footer-link">Início</a></li>
                        <li class="mb-2"><a href="#cardapio" class="footer-link">Cardápio</a></li>
                        <li class="mb-2"><a href="#sobre" class="footer-link">Sobre Nós</a></li>
                        <li class="mb-2"><a href="#contato" class="footer-link">Contato</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-4">
                    <h6 class="text-warning fw-semibold mb-3">Horário de Funcionamento</h6>
                    <ul class="list-unstyled text-muted small">
                        <li class="mb-2"><i class="fa-regular fa-clock me-2 text-warning"></i>Seg-Sex: 11h às 23h</li>
                        <li class="mb-2"><i class="fa-regular fa-clock me-2 text-warning"></i>Sábado: 11h às 00h</li>
                        <li class="mb-2"><i class="fa-regular fa-clock me-2 text-warning"></i>Domingo: 12h às 22h</li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-4">
                    <h6 class="text-warning fw-semibold mb-3">Contato</h6>
                    <ul class="list-unstyled text-muted small">
                        <li class="mb-2"><i class="fa-solid fa-location-dot me-2 text-warning"></i>Rua das Hamburguerias, 123</li>
                        <li class="mb-2"><i class="fa-solid fa-phone me-2 text-warning"></i>(35) 99999-0000</li>
                        <li class="mb-2"><i class="fa-solid fa-envelope me-2 text-warning"></i>contato@hamburgueria.com</li>
                        <li class="mb-2"><i class="fa-brands fa-whatsapp me-2 text-warning"></i>(35) 99999-0001</li>
                    </ul>
                </div>
            </div>
            <hr class="border-secondary">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <p class="text-muted small mb-0">&copy; 2024 Hamburgueria. Todos os direitos reservados.</p>
                <a href="${pageContext.request.contextPath}/login.html" class="text-muted small text-decoration-none">
                    <i class="fa-solid fa-lock me-1"></i>Área Restrita
                </a>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Navbar scroll effect
        window.addEventListener('scroll', () => {
            document.getElementById('mainNav').classList.toggle('scrolled', window.scrollY > 50);
        });

        // Filter buttons — dynamic categories
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.addEventListener('click', function () {
                document.querySelectorAll('.filter-btn').forEach(b => {
                    b.classList.remove('active', 'btn-warning');
                    b.classList.add('btn-outline-secondary');
                });
                this.classList.add('active', 'btn-warning');
                this.classList.remove('btn-outline-secondary');
                const filter = this.dataset.filter;
                document.querySelectorAll('.menu-item').forEach(item => {
                    item.style.display = (filter === 'todos' || item.dataset.category === filter) ? '' : 'none';
                });
            });
        });

        // Smooth scroll
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                const target = document.querySelector(this.getAttribute('href'));
                if (target) { e.preventDefault(); target.scrollIntoView({ behavior: 'smooth' }); }
            });
        });
    </script>
</body>
</html>
