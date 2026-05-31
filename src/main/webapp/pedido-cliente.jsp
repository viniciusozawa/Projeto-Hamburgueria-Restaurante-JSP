<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fazer Pedido - Hamburgueria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/cliente.css">
    <style>
        body { background: #f8f9fa; }

        .page-header {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            padding: 1.2rem 0;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 20px rgba(0,0,0,0.3);
        }

        .menu-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 1.25rem; }

        .item-card {
            background: #fff;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            transition: all 0.25s ease;
            border: 2px solid transparent;
        }
        .item-card:hover { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(0,0,0,0.12); }
        .item-card.selecionado { border-color: #f39c12; box-shadow: 0 4px 20px rgba(243,156,18,0.2); }

        .item-img { width:100%; height:160px; object-fit:cover; }

        .item-body { padding: 1rem; }
        .item-nome { font-weight: 700; font-size: 0.95rem; margin-bottom: 0.25rem; }
        .item-cat  { font-size: 0.72rem; color: #f39c12; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        .item-desc { font-size: 0.8rem; color: #7f8c8d; line-height: 1.4; margin: 0.4rem 0; }
        .item-ingredientes { font-size: 0.75rem; color: #95a5a6; }
        .item-preco { font-size: 1.1rem; font-weight: 700; color: #f39c12; }

        .qty-control { display: flex; align-items: center; gap: 0.5rem; }
        .qty-btn {
            width: 30px; height: 30px; border-radius: 50%;
            border: 1.5px solid #dee2e6; background: #fff;
            font-size: 1rem; cursor: pointer; line-height: 1;
            display: flex; align-items: center; justify-content: center;
            transition: all 0.2s;
        }
        .qty-btn:hover { background: #f39c12; border-color: #f39c12; color: #fff; }
        .qty-input { width: 40px; text-align: center; border: 1.5px solid #dee2e6; border-radius: 8px; padding: 0.2rem; font-weight: 600; }

        /* CART */
        .cart-panel {
            position: fixed; right: 0; top: 0; bottom: 0;
            width: 340px;
            background: #fff;
            box-shadow: -4px 0 30px rgba(0,0,0,0.1);
            z-index: 200;
            display: flex; flex-direction: column;
            transform: translateX(100%);
            transition: transform 0.3s ease;
        }
        .cart-panel.open { transform: translateX(0); }
        .cart-header { padding: 1.25rem 1.5rem; border-bottom: 1px solid #edf0f2; display: flex; align-items: center; justify-content: space-between; }
        .cart-items  { flex: 1; overflow-y: auto; padding: 1rem 1.5rem; }
        .cart-footer { padding: 1.25rem 1.5rem; border-top: 1px solid #edf0f2; background: #fafbfc; }

        .cart-item { display: flex; align-items: center; justify-content: space-between; padding: 0.6rem 0; border-bottom: 1px solid #f5f7f9; font-size: 0.875rem; }
        .cart-item:last-child { border-bottom: none; }
        .cart-empty { text-align: center; color: #adb5bd; padding: 2rem; font-size: 0.875rem; }

        .cart-badge {
            position: absolute; top: -6px; right: -6px;
            width: 18px; height: 18px;
            background: #e74c3c; color: #fff;
            border-radius: 50%; font-size: 0.65rem;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700;
        }

        .btn-cart-open {
            position: fixed; bottom: 2rem; right: 2rem;
            width: 60px; height: 60px;
            background: linear-gradient(135deg, #f39c12, #e67e22);
            border: none; border-radius: 50%;
            color: #fff; font-size: 1.3rem;
            cursor: pointer;
            box-shadow: 0 4px 20px rgba(243,156,18,0.45);
            transition: all 0.2s;
            z-index: 150;
        }
        .btn-cart-open:hover { transform: scale(1.1); }

        .overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.4); z-index: 190;
        }
        .overlay.active { display: block; }

        /* Form de finalizar */
        .checkout-form { padding: 0.5rem 0; }
        .checkout-form .form-label { font-size: 0.82rem; font-weight: 600; color: #2c3e50; margin-bottom: 0.3rem; }
        .checkout-form .form-control,
        .checkout-form .form-select { font-size: 0.875rem; border-radius: 8px; border: 1.5px solid #e8ecef; padding: 0.5rem 0.75rem; }
        .checkout-form .form-control:focus,
        .checkout-form .form-select:focus { border-color: #f39c12; box-shadow: 0 0 0 3px rgba(243,156,18,0.12); outline: none; }

        .btn-finalizar {
            width: 100%; padding: 0.75rem;
            background: linear-gradient(135deg, #f39c12, #e67e22);
            border: none; border-radius: 10px;
            color: #fff; font-weight: 700; font-size: 0.95rem;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-finalizar:hover { transform: translateY(-1px); box-shadow: 0 4px 15px rgba(243,156,18,0.4); }

        .alert-sucesso {
            background: rgba(46,204,113,0.1); border: 1px solid rgba(46,204,113,0.3);
            border-left: 4px solid #2ecc71; border-radius: 10px;
            padding: 1rem 1.25rem; color: #27ae60; font-size: 0.9rem;
            display: flex; align-items: center; gap: 0.75rem;
        }
        .alert-erro {
            background: rgba(231,76,60,0.1); border: 1px solid rgba(231,76,60,0.3);
            border-left: 4px solid #e74c3c; border-radius: 10px;
            padding: 0.75rem 1.25rem; color: #e74c3c; font-size: 0.875rem;
        }

        @media (max-width: 768px) {
            .cart-panel { width: 100%; }
        }
    </style>
</head>
<body>

    <!-- HEADER -->
    <div class="page-header">
        <div class="container d-flex align-items-center justify-content-between">
            <a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none text-white d-flex align-items-center gap-2">
                <i class="fa-solid fa-arrow-left fa-sm"></i>
                <span class="fw-semibold"><i class="fa-solid fa-burger text-warning me-2"></i>Hamburgueria</span>
            </a>
            <h5 class="mb-0 text-white fw-semibold">Fazer Pedido</h5>
            <div style="position:relative; width:40px;"><!-- espaçamento --></div>
        </div>
    </div>

    <div class="container py-4">

        <!-- Alertas -->
        <c:if test="${not empty sucesso}">
            <div class="alert-sucesso mb-4">
                <i class="fa-solid fa-circle-check fa-lg"></i>
                <div>
                    <strong>Pedido confirmado!</strong><br>
                    <span>${sucesso}</span>
                </div>
            </div>
        </c:if>
        <c:if test="${not empty erro}">
            <div class="alert-erro mb-4">
                <i class="fa-solid fa-circle-exclamation me-2"></i>${erro}
            </div>
        </c:if>

        <!-- Título -->
        <div class="mb-4">
            <h4 class="fw-bold">Escolha seus itens</h4>
            <p class="text-muted small">Clique em <strong>+</strong> para adicionar, ajuste a quantidade e finalize no carrinho.</p>
        </div>

        <!-- Filtros por categoria -->
        <div class="d-flex gap-2 mb-4 flex-wrap" id="filtrosBtns">
            <button class="btn btn-warning btn-sm rounded-pill px-4 filter-btn active" data-filter="todos">Todos</button>
            <c:forEach var="cardapio" items="${cardapios}" varStatus="st">
                <%-- botão gerado para cada categoria distinta via JS abaixo --%>
            </c:forEach>
        </div>

        <!-- Grid de itens -->
        <form method="post" action="${pageContext.request.contextPath}/com/mycompany/restaurantehamburgueria/controller/PedidoClienteController" id="formPedido">

            <div class="menu-grid" id="menuGrid">
                <c:forEach var="item" items="${cardapios}">
                    <c:set var="nomeCategoria" value="${item.nomeCategoria}"/>
                    <div class="item-card" data-category="${nomeCategoria}" data-cod="${item.codCardapio}"
                         data-nome="${item.nomeComida}" data-preco="${item.valorComida}">

                        <%-- Imagem por categoria --%>
                        <c:choose>
                            <c:when test="${nomeCategoria == 'Hamburguer'}">
                                <img class="item-img" src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80" alt="${item.nomeComida}">
                            </c:when>
                            <c:when test="${nomeCategoria == 'Bebida'}">
                                <img class="item-img" src="https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400&q=80" alt="${item.nomeComida}">
                            </c:when>
                            <c:when test="${nomeCategoria == 'Sobremesa'}">
                                <img class="item-img" src="https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=400&q=80" alt="${item.nomeComida}">
                            </c:when>
                            <c:otherwise>
                                <img class="item-img" src="https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?w=400&q=80" alt="${item.nomeComida}">
                            </c:otherwise>
                        </c:choose>

                        <div class="item-body">
                            <div class="item-cat">${nomeCategoria}</div>
                            <div class="item-nome">${item.nomeComida}</div>
                            <div class="item-desc">${item.descricaoComida}</div>

                            <%-- Ingredientes --%>
                            <c:if test="${not empty ingredientes[item.codCardapio]}">
                                <div class="item-ingredientes mt-1">
                                    <i class="fa-solid fa-seedling fa-xs me-1"></i>
                                    <c:forEach var="ing" items="${ingredientes[item.codCardapio]}" varStatus="st2">
                                        ${ing}<c:if test="${!st2.last}">, </c:if>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <div class="d-flex align-items-center justify-content-between mt-3">
                                <span class="item-preco">R$ ${item.valorComida}</span>
                                <div class="qty-control">
                                    <button type="button" class="qty-btn btn-minus" data-cod="${item.codCardapio}">-</button>
                                    <input type="number" class="qty-input" name="qty_${item.codCardapio}"
                                           id="qty_${item.codCardapio}" value="0" min="0" max="20"
                                           onchange="atualizarCarrinho()">
                                    <button type="button" class="qty-btn btn-plus" data-cod="${item.codCardapio}">+</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Dados do cliente (oculto, aparece ao finalizar via carrinho) -->
            <input type="hidden" name="nomeCliente" id="hiddenNome">
            <input type="hidden" name="telefone" id="hiddenTelefone">
            <input type="hidden" name="codMesa" id="hiddenMesa">
        </form>
    </div>

    <!-- CARRINHO -->
    <div class="overlay" id="cartOverlay" onclick="fecharCarrinho()"></div>

    <div class="cart-panel" id="cartPanel">
        <div class="cart-header">
            <h6 class="mb-0 fw-bold"><i class="fa-solid fa-cart-shopping me-2 text-warning"></i>Seu Pedido</h6>
            <button onclick="fecharCarrinho()" style="background:none;border:none;font-size:1.2rem;cursor:pointer;color:#7f8c8d;">&times;</button>
        </div>

        <div class="cart-items" id="cartItems">
            <div class="cart-empty" id="cartEmpty">
                <i class="fa-solid fa-cart-shopping fa-2x mb-2 d-block opacity-25"></i>
                Nenhum item ainda
            </div>
        </div>

        <div class="cart-footer">
            <div class="d-flex justify-content-between fw-semibold mb-3">
                <span>Total estimado:</span>
                <span class="text-warning" id="cartTotal">R$ 0,00</span>
            </div>

            <!-- Dados do cliente -->
            <div class="checkout-form">
                <div class="mb-2">
                    <label class="form-label">Seu nome *</label>
                    <input type="text" class="form-control" id="inputNome" placeholder="Como devo te chamar?" required>
                </div>
                <div class="mb-2">
                    <label class="form-label">Telefone (opcional)</label>
                    <input type="text" class="form-control" id="inputTelefone" placeholder="(00) 00000-0000">
                </div>
                <div class="mb-3">
                    <label class="form-label">Mesa *</label>
                    <select class="form-select" id="inputMesa" required>
                        <option value="">Selecione sua mesa...</option>
                        <c:forEach var="m" items="${mesas}">
                            <option value="${m.codMesa}">Mesa ${m.numeroMesa} — ${m.localMesa}</option>
                        </c:forEach>
                    </select>
                </div>
                <button type="button" class="btn-finalizar" onclick="finalizarPedido()">
                    <i class="fa-solid fa-check me-2"></i>Confirmar Pedido
                </button>
            </div>
        </div>
    </div>

    <!-- Botão flutuante do carrinho -->
    <button class="btn-cart-open" onclick="abrirCarrinho()" id="btnCartOpen" style="display:none;">
        <div style="position:relative;display:inline-block;">
            <i class="fa-solid fa-cart-shopping"></i>
            <span class="cart-badge" id="cartCount">0</span>
        </div>
    </button>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const cardapioData = {};

        // Popula dados de cada card
        document.querySelectorAll('.item-card').forEach(card => {
            const cod   = card.dataset.cod;
            const nome  = card.dataset.nome;
            const preco = parseFloat(card.dataset.preco);
            cardapioData[cod] = { nome, preco };
        });

        // Gera botões de filtro por categoria
        const categorias = new Set();
        document.querySelectorAll('.item-card').forEach(c => categorias.add(c.dataset.category));
        const filtrosDiv = document.getElementById('filtrosBtns');
        categorias.forEach(cat => {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'btn btn-outline-secondary btn-sm rounded-pill px-4 filter-btn';
            btn.dataset.filter = cat;
            btn.textContent = cat;
            filtrosDiv.appendChild(btn);
        });

        // Filtros
        filtrosDiv.addEventListener('click', e => {
            const btn = e.target.closest('.filter-btn');
            if (!btn) return;
            filtrosDiv.querySelectorAll('.filter-btn').forEach(b => {
                b.classList.remove('active', 'btn-warning');
                b.classList.add('btn-outline-secondary');
            });
            btn.classList.add('active', 'btn-warning');
            btn.classList.remove('btn-outline-secondary');
            const f = btn.dataset.filter;
            document.querySelectorAll('.item-card').forEach(card => {
                card.closest('[data-category]') || (card.style.display = '');
                card.style.display = (f === 'todos' || card.dataset.category === f) ? '' : 'none';
            });
        });

        // Botões +/-
        document.querySelectorAll('.btn-plus').forEach(btn => {
            btn.addEventListener('click', () => {
                const input = document.getElementById('qty_' + btn.dataset.cod);
                input.value = parseInt(input.value || 0) + 1;
                atualizarCarrinho();
            });
        });
        document.querySelectorAll('.btn-minus').forEach(btn => {
            btn.addEventListener('click', () => {
                const input = document.getElementById('qty_' + btn.dataset.cod);
                const v = parseInt(input.value || 0);
                if (v > 0) { input.value = v - 1; atualizarCarrinho(); }
            });
        });

        function atualizarCarrinho() {
            const cartItemsDiv = document.getElementById('cartItems');
            const cartEmpty    = document.getElementById('cartEmpty');
            const cartCount    = document.getElementById('cartCount');
            const cartTotal    = document.getElementById('cartTotal');
            const btnCartOpen  = document.getElementById('btnCartOpen');

            let total = 0, count = 0;
            cartItemsDiv.innerHTML = '';

            Object.keys(cardapioData).forEach(cod => {
                const input = document.getElementById('qty_' + cod);
                if (!input) return;
                const qty = parseInt(input.value) || 0;
                if (qty > 0) {
                    const { nome, preco } = cardapioData[cod];
                    total += preco * qty;
                    count += qty;

                    const div = document.createElement('div');
                    div.className = 'cart-item';
                    div.innerHTML = `
                        <div>
                            <div class="fw-semibold" style="font-size:0.82rem">${nome}</div>
                            <div style="font-size:0.75rem;color:#7f8c8d">x${qty} &times; R$ ${preco.toFixed(2)}</div>
                        </div>
                        <span class="fw-bold text-warning" style="font-size:0.88rem">R$ ${(preco * qty).toFixed(2)}</span>
                    `;
                    cartItemsDiv.appendChild(div);

                    // Destaca card
                    document.querySelectorAll('.item-card[data-cod="' + cod + '"]').forEach(c => c.classList.add('selecionado'));
                } else {
                    document.querySelectorAll('.item-card[data-cod="' + cod + '"]').forEach(c => c.classList.remove('selecionado'));
                }
            });

            if (count === 0) {
                cartItemsDiv.innerHTML = '<div class="cart-empty"><i class="fa-solid fa-cart-shopping fa-2x mb-2 d-block opacity-25"></i>Nenhum item ainda</div>';
            }

            cartCount.textContent = count;
            cartTotal.textContent = 'R$ ' + total.toFixed(2).replace('.', ',');
            btnCartOpen.style.display = count > 0 ? 'flex' : 'none';
            btnCartOpen.style.alignItems = 'center';
            btnCartOpen.style.justifyContent = 'center';
        }

        function abrirCarrinho()  { document.getElementById('cartPanel').classList.add('open'); document.getElementById('cartOverlay').classList.add('active'); }
        function fecharCarrinho() { document.getElementById('cartPanel').classList.remove('open'); document.getElementById('cartOverlay').classList.remove('active'); }

        function finalizarPedido() {
            const nome = document.getElementById('inputNome').value.trim();
            const mesa = document.getElementById('inputMesa').value;

            if (!nome) { alert('Por favor informe seu nome.'); document.getElementById('inputNome').focus(); return; }
            if (!mesa) { alert('Por favor selecione sua mesa.'); document.getElementById('inputMesa').focus(); return; }

            // Verifica se tem item
            let temItem = false;
            Object.keys(cardapioData).forEach(cod => {
                const input = document.getElementById('qty_' + cod);
                if (input && parseInt(input.value) > 0) temItem = true;
            });
            if (!temItem) { alert('Adicione pelo menos um item ao pedido.'); return; }

            document.getElementById('hiddenNome').value     = nome;
            document.getElementById('hiddenTelefone').value = document.getElementById('inputTelefone').value.trim();
            document.getElementById('hiddenMesa').value     = mesa;

            document.getElementById('formPedido').submit();
        }
    </script>
</body>
</html>
