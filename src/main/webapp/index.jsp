<%--
    Vitrine pública da Big Tites.
    O painel de gerenciamento fica em painel.jsp, atrás do login.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Big Tites — hambúrguer na chapa em Pouso Alegre</title>
    <meta name="description" content="Balcão de hambúrguer artesanal em Pouso Alegre. Blend de 100 g prensado na chapa, pão brioche e cardápio curto. Aberto de terça a domingo, a partir das 18h.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&family=Rubik:wght@400;500;600;700&family=Courier+Prime:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css">
</head>
<body class="vitrine">

<%@include file="MenuPublic.jsp" %>

<!-- ===== CHAPA ===== -->
<section class="chapa">
    <div class="faixa chapa-grade">
        <div>
            <p class="selo"><span class="luz" aria-hidden="true"></span>Aberto hoje até 23h30</p>

            <h1 class="chapa-titulo">Prensado na chapa até criar <em>casca</em></h1>

            <p class="chapa-lede">
                Blend de 100&nbsp;g prensado na chapa a 250&nbsp;°C, pão brioche e cheddar
                que derrete de verdade. Dez itens no cardápio, montados na hora do pedido.
            </p>

            <div class="chapa-acoes">
                <a class="btn-mostarda" href="#cardapio"><i class="fa-solid fa-burger" aria-hidden="true"></i>Ver o cardápio</a>
                <a class="btn-contorno" href="#onde"><i class="fa-solid fa-map-location-dot" aria-hidden="true"></i>Como chegar</a>
            </div>
        </div>

        <div class="chapa-palco">
            <img class="chapa-foto"
                 src="https://images.unsplash.com/photo-1607013251379-e6eecfffe234?auto=format&fit=crop&w=900&q=75"
                 alt="Smash duplo com duas carnes prensadas, cheddar derretido e picles no pão brioche.">

            <!-- A comanda: o artefato real do sistema (pedido, itens, mesa).
                 Ilustra um pedido de exemplo, por isso fica fora da leitura de tela. -->
            <div class="comanda" aria-hidden="true">
                <div class="comanda-corpo">
                    <p class="comanda-linha comanda-cabeca">BIG TITES — COZINHA</p>
                    <p class="comanda-linha comanda-meta"><span>MESA 04</span><span>19:42</span></p>
                    <hr class="comanda-linha comanda-regua">
                    <p class="comanda-linha comanda-item"><span>2x SMASH DUPLO</span><span>53,80</span></p>
                    <p class="comanda-linha comanda-item"><span>1x BATATA CHEDDAR</span><span>18,00</span></p>
                    <hr class="comanda-linha comanda-regua">
                    <p class="comanda-linha comanda-total"><span>TOTAL</span><span>R$ 71,80</span></p>
                    <p class="comanda-linha comanda-pe">PEDIDO #1042 · BALCÃO</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ===== VANTAGENS ===== -->
<section class="vantagens">
    <div class="faixa vantagens-grade">
        <div class="vantagem">
            <i class="fa-solid fa-fire-burner" aria-hidden="true"></i>
            <span><b>Carne moída no dia</b><span>Blend de 100 g, nunca congelado</span></span>
        </div>
        <div class="vantagem">
            <i class="fa-solid fa-bag-shopping" aria-hidden="true"></i>
            <span><b>Pronto em 15 min</b><span>Peça no balcão ou por telefone</span></span>
        </div>
        <div class="vantagem">
            <i class="fa-solid fa-clock" aria-hidden="true"></i>
            <span><b>Aberto até 23h30</b><span>De terça a domingo</span></span>
        </div>
        <div class="vantagem">
            <i class="fa-solid fa-credit-card" aria-hidden="true"></i>
            <span><b>Pix, cartão ou dinheiro</b><span>Pagamento no balcão</span></span>
        </div>
    </div>
</section>

<!-- ===== CARDÁPIO ===== -->
<section class="quadro" id="cardapio">
    <div class="faixa">
        <div class="secao-cabeca">
            <div>
                <p class="secao-etiqueta"><i class="fa-solid fa-utensils" aria-hidden="true"></i>Cardápio</p>
                <h2 class="secao-titulo">O que sai da chapa</h2>
            </div>
            <p class="secao-nota">Preços em real · setembro de 2026</p>
        </div>

        <div class="atalhos" role="group" aria-label="Filtrar o cardápio por categoria">
            <button class="atalho" type="button" data-filtro="tudo" aria-pressed="true"><i class="fa-solid fa-bars-staggered" aria-hidden="true"></i>Tudo <b>10</b></button>
            <button class="atalho" type="button" data-filtro="hamburguer" aria-pressed="false"><i class="fa-solid fa-burger" aria-hidden="true"></i>Hambúrguer <b>4</b></button>
            <button class="atalho" type="button" data-filtro="petiscos" aria-pressed="false"><i class="fa-solid fa-bowl-food" aria-hidden="true"></i>Petiscos <b>2</b></button>
            <button class="atalho" type="button" data-filtro="bebida" aria-pressed="false"><i class="fa-solid fa-bottle-water" aria-hidden="true"></i>Bebida <b>1</b></button>
            <button class="atalho" type="button" data-filtro="sobremesa" aria-pressed="false"><i class="fa-solid fa-ice-cream" aria-hidden="true"></i>Sobremesa <b>3</b></button>
        </div>

        <div class="pratos" id="pratos">
                <article class="prato" data-cat="hamburguer">
                    <div class="prato-capa">
                        <img class="prato-foto" loading="lazy"
                             src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=560&q=70"
                             alt="Hambúrguer da casa com cheddar derretido, picles, tomate e alface.">
                        <span class="prato-tag">O da casa</span>
                        <span class="prato-preco"><small>R$</small>10,20</span>
                    </div>
                    <div class="prato-corpo">
                        <p class="prato-cat">Hambúrguer</p>
                        <h3 class="prato-nome">Big Tites</h3>
                        <p class="prato-desc">Blend de 100&nbsp;g, cheddar derretido na chapa e molho da casa no pão brioche.</p>
                    </div>
                </article>

                <article class="prato" data-cat="hamburguer">
                    <div class="prato-capa">
                        <img class="prato-foto" loading="lazy"
                             src="https://images.unsplash.com/photo-1586816001966-79b736744398?auto=format&fit=crop&w=560&q=70"
                             alt="Cheeseburger clássico com queijo prato, alface e tomate.">
                        <span class="prato-preco"><small>R$</small>7,99</span>
                    </div>
                    <div class="prato-corpo">
                        <p class="prato-cat">Hambúrguer</p>
                        <h3 class="prato-nome">Cheeseburger clássico</h3>
                        <p class="prato-desc">Pão, hambúrguer artesanal, queijo prato, alface, tomate e molho especial.</p>
                    </div>
                </article>

                <article class="prato" data-cat="hamburguer">
                    <div class="prato-capa">
                        <img class="prato-foto" loading="lazy"
                             src="https://images.unsplash.com/photo-1586190848861-99aa4a171e90?auto=format&fit=crop&w=560&q=70"
                             alt="Cheesebacon com bacon crocante, cheddar e alface no pão de gergelim.">
                        <span class="prato-preco"><small>R$</small>22,50</span>
                    </div>
                    <div class="prato-corpo">
                        <p class="prato-cat">Hambúrguer</p>
                        <h3 class="prato-nome">Cheesebacon</h3>
                        <p class="prato-desc">Hambúrguer artesanal, queijo cheddar, bacon crocante e maionese da casa.</p>
                    </div>
                </article>

                <article class="prato" data-cat="hamburguer">
                    <div class="prato-capa">
                        <img class="prato-foto" loading="lazy"
                             src="https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?auto=format&fit=crop&w=560&q=70"
                             alt="Smash duplo com duas carnes, cheddar e cebola caramelizada.">
                        <span class="prato-tag">Mais pedido</span>
                        <span class="prato-preco"><small>R$</small>26,90</span>
                    </div>
                    <div class="prato-corpo">
                        <p class="prato-cat">Hambúrguer</p>
                        <h3 class="prato-nome">Smash duplo</h3>
                        <p class="prato-desc">Dois hambúrgueres smash de 100&nbsp;g, queijo cheddar, cebola caramelizada e pão brioche.</p>
                    </div>
                </article>

                <article class="prato" data-cat="petiscos">
                    <div class="prato-capa">
                        <img class="prato-foto" loading="lazy"
                             src="https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?auto=format&fit=crop&w=560&q=70"
                             alt="Porção de batata frita crocante na cesta de fritura.">
                        <span class="prato-preco"><small>R$</small>7,98</span>
                    </div>
                    <div class="prato-corpo">
                        <p class="prato-cat">Petiscos</p>
                        <h3 class="prato-nome">Batata frita tradicional</h3>
                        <p class="prato-desc">Porção média de batata frita crocante.</p>
                    </div>
                </article>

                <article class="prato" data-cat="petiscos">
                    <div class="prato-capa">
                        <img class="prato-foto" loading="lazy"
                             src="https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=560&q=70"
                             alt="Cesta de batata frita coberta com cheddar cremoso e cubos de bacon.">
                        <span class="prato-preco"><small>R$</small>18,00</span>
                    </div>
                    <div class="prato-corpo">
                        <p class="prato-cat">Petiscos</p>
                        <h3 class="prato-nome">Batata com cheddar e bacon</h3>
                        <p class="prato-desc">Batata frita coberta com cheddar cremoso e bacon em cubos.</p>
                    </div>
                </article>

                <article class="prato" data-cat="bebida">
                    <div class="prato-capa">
                        <img class="prato-foto" loading="lazy"
                             src="https://images.unsplash.com/photo-1581636625402-29b2a704ef13?auto=format&fit=crop&w=560&q=70"
                             alt="Copo de refrigerante gelado com gelo e limão.">
                        <span class="prato-preco"><small>R$</small>6,00</span>
                    </div>
                    <div class="prato-corpo">
                        <p class="prato-cat">Bebida</p>
                        <h3 class="prato-nome">Refrigerante lata</h3>
                        <p class="prato-desc">Coca-Cola, Guaraná ou Fanta, 350&nbsp;ml.</p>
                    </div>
                </article>

                <article class="prato" data-cat="sobremesa">
                    <div class="prato-capa">
                        <img class="prato-foto" loading="lazy"
                             src="https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=560&q=70"
                             alt="Milkshake de chocolate com calda e biscoito.">
                        <span class="prato-preco"><small>R$</small>15,00</span>
                    </div>
                    <div class="prato-corpo">
                        <p class="prato-cat">Sobremesa</p>
                        <h3 class="prato-nome">Milkshake de chocolate</h3>
                        <p class="prato-desc">Milkshake cremoso com calda de chocolate.</p>
                    </div>
                </article>

                <article class="prato" data-cat="sobremesa">
                    <div class="prato-capa">
                        <img class="prato-foto" loading="lazy"
                             src="https://images.unsplash.com/photo-1607920591413-4ec007e70023?auto=format&fit=crop&w=560&q=70"
                             alt="Fatias de brownie caseiro com calda.">
                        <span class="prato-preco"><small>R$</small>16,50</span>
                    </div>
                    <div class="prato-corpo">
                        <p class="prato-cat">Sobremesa</p>
                        <h3 class="prato-nome">Brownie com sorvete</h3>
                        <p class="prato-desc">Brownie caseiro com bola de sorvete de creme e calda de chocolate.</p>
                    </div>
                </article>

                <article class="prato" data-cat="sobremesa">
                    <div class="prato-capa">
                        <img class="prato-foto" loading="lazy"
                             src="https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=560&q=70"
                             alt="Taça de sorvete de chocolate com calda e biscoito.">
                        <span class="prato-preco"><small>R$</small>20,00</span>
                    </div>
                    <div class="prato-corpo">
                        <p class="prato-cat">Sobremesa</p>
                        <h3 class="prato-nome">Sorvete</h3>
                        <p class="prato-desc">Duas bolas de sorvete de chocolate.</p>
                    </div>
                </article>
        </div>

        <p class="pratos-vazio" id="pratosVazio" hidden>Nenhum item nessa categoria.</p>
    </div>
</section>

<!-- ===== COMBO ===== -->
<section class="combo">
    <div class="combo-grade">
        <img class="combo-foto" loading="lazy"
             src="https://images.unsplash.com/photo-1610614819513-58e34989848b?auto=format&fit=crop&w=800&q=75"
             alt="Bandeja com hambúrgueres, batata frita e molho.">
        <div class="combo-texto">
            <p class="combo-tag"><i class="fa-solid fa-fire" aria-hidden="true"></i>Combo do balcão</p>
            <h2 class="combo-titulo">Smash duplo<br>+ batata + bebida</h2>
            <p class="combo-desc">
                O smash duplo com a porção tradicional de batata e um refrigerante lata.
                Só no balcão, de terça a domingo.
            </p>
            <div class="combo-valor">
                <span class="combo-de">R$ 40,88</span>
                <span class="combo-por"><small>R$</small>35,90</span>
                <span class="combo-economia">Economize R$ 4,98</span>
            </div>
            <a class="btn-mostarda" href="#onde"><i class="fa-solid fa-location-dot" aria-hidden="true"></i>Peça no balcão</a>
        </div>
    </div>
</section>

<!-- ===== A CASA ===== -->
<section class="casa" id="casa">
    <div class="faixa casa-grade">
        <img class="casa-foto" loading="lazy"
             src="https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=800&q=75"
             alt="Dois hambúrgueres servidos na tábua de madeira do balcão, com refrigerantes ao fundo.">
        <div class="casa-texto">
            <p class="secao-etiqueta"><i class="fa-solid fa-store" aria-hidden="true"></i>A casa</p>
            <h2 class="secao-titulo" style="margin-bottom:22px">Um balcão,<br>uma chapa,<br>dez itens</h2>
            <p>
                A <strong>Big Tites</strong> é um balcão de esquina em Pouso Alegre. Uma chapa,
                oito banquetas e um cardápio curto de propósito — dá para fazer bem o que é pouco.
            </p>
            <p>
                Abrimos às 18h porque a carne é moída no dia e o pão chega da padaria no fim da
                tarde. <strong>Quando acaba, acabou.</strong>
            </p>
            <p>
                Atendemos no balcão e nas mesas. Para viagem, é só pedir na hora — a comanda vai
                direto para a cozinha.
            </p>
        </div>
    </div>
</section>

<!-- ===== ONDE ACHAR ===== -->
<section class="onde" id="onde">
    <div class="faixa">
        <div class="secao-cabeca">
            <div>
                <p class="secao-etiqueta"><i class="fa-solid fa-location-dot" aria-hidden="true"></i>Onde achar</p>
                <h2 class="secao-titulo">Rua e horário</h2>
            </div>
            <p class="secao-nota">Segunda-feira a chapa descansa</p>
        </div>

        <div class="onde-grade">
            <div class="placa">
                <h3 class="placa-titulo"><i class="fa-solid fa-location-dot" aria-hidden="true"></i>Endereço</h3>
                <p>Rua Dr. João Beraldo, 412</p>
                <p class="secundario">Centro — Pouso Alegre, MG</p>
                <p class="secundario">Em frente à praça, porta verde.</p>
            </div>

            <div class="placa">
                <h3 class="placa-titulo"><i class="fa-solid fa-clock" aria-hidden="true"></i>Horário</h3>
                <div class="horario">
                    <div><span>Terça a quinta</span><b>18h — 23h</b></div>
                    <div><span>Sexta e sábado</span><b>18h — 00h</b></div>
                    <div><span>Domingo</span><b>18h — 22h30</b></div>
                    <div class="fechado"><span>Segunda</span><b>fechado</b></div>
                </div>
            </div>

            <div class="placa">
                <h3 class="placa-titulo"><i class="fa-solid fa-phone" aria-hidden="true"></i>Falar com a gente</h3>
                <p><a href="tel:+553599999000">(35) 9 9999-9000</a></p>
                <p class="secundario">Reserva de mesa só para grupos acima de seis pessoas.</p>
            </div>
        </div>
    </div>
</section>

<!-- ===== RODAPÉ ===== -->
<footer class="rodape-pub">
    <div class="faixa rodape-grade">
        <a class="marca" href="#"><i class="fa-solid fa-burger" aria-hidden="true"></i>Big Tites<span class="ponto">.</span></a>

        <p class="fina">Rua Dr. João Beraldo, 412 · Pouso Alegre, MG</p>

        <div class="rodape-social">
            <a href="#" aria-label="Instagram da Big Tites"><i class="fa-brands fa-instagram" aria-hidden="true"></i></a>
            <a href="#" aria-label="WhatsApp da Big Tites"><i class="fa-brands fa-whatsapp" aria-hidden="true"></i></a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/painel.jsp" aria-label="Abrir o painel"><i class="fa-solid fa-table-cells-large" aria-hidden="true"></i></a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login.jsp" aria-label="Entrar no sistema"><i class="fa-solid fa-right-to-bracket" aria-hidden="true"></i></a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</footer>

<script>
    /* Filtro do cardápio. Sem categoria selecionada o padrão é "Tudo",
       então a grade nunca abre com buracos. */
    (function () {
        var grade   = document.getElementById('pratos');
        var vazio   = document.getElementById('pratosVazio');
        var botoes  = document.querySelectorAll('.atalho');
        if (!grade) return;

        var cartoes = grade.querySelectorAll('.prato');

        botoes.forEach(function (botao) {
            botao.addEventListener('click', function () {
                var alvo = botao.getAttribute('data-filtro');
                var visiveis = 0;

                cartoes.forEach(function (c) {
                    var mostra = (alvo === 'tudo' || c.getAttribute('data-cat') === alvo);
                    c.hidden = !mostra;
                    if (mostra) visiveis++;
                });

                botoes.forEach(function (b) {
                    b.setAttribute('aria-pressed', b === botao ? 'true' : 'false');
                });

                vazio.hidden = visiveis > 0;
            });
        });
    })();
</script>

</body>
</html>
