<%--
    Área do cliente: os pedidos dele e os dados que ele pode alterar.

    Só chega aqui por forward do PerfilControlador, que carrega o cliente da
    sessão. Aberta direto pela URL, o AuthFilter recusa.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Minha conta — Big Tites</title>
    <meta name="robots" content="noindex">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&family=Rubik:wght@400;500;600;700&family=Courier+Prime:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css?v=${VERSAO}">
</head>
<body class="vitrine">

<%@include file="MenuPublic.jsp" %>

<main class="conta">
    <div class="faixa">

        <div class="secao-cabeca">
            <div>
                <p class="secao-etiqueta"><i class="fa-solid fa-user" aria-hidden="true"></i>Minha conta</p>
                <h1 class="secao-titulo">Oi, ${sessionScope.usuario.primeiroNome}</h1>
            </div>
            <p class="secao-nota">Seus pedidos e seus dados, num lugar só.</p>
        </div>

        <div class="conta-grade">

            <%-- ===== PEDIDOS ===== --%>
            <section aria-labelledby="tituloPedidos">
                <h2 class="conta-subtitulo" id="tituloPedidos">
                    <i class="fa-solid fa-receipt" aria-hidden="true"></i>Meus pedidos
                </h2>

                <c:choose>
                    <c:when test="${empty pedidos}">
                        <div class="conta-vazio">
                            <i class="fa-solid fa-burger" aria-hidden="true"></i>
                            <p>Você ainda não fez nenhum pedido. Quando pedir no balcão ou na mesa, ele aparece aqui.</p>
                            <a class="conta-link" href="${pageContext.request.contextPath}/index.jsp#cardapio">Ver o cardápio</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <%-- Em aberto: a comanda inteira, como sai da cozinha.
                             Pago o total, o pedido dá baixa e desce para o histórico. --%>
                        <h3 class="conta-grupo">Em aberto</h3>
                        <c:choose>
                            <c:when test="${empty pedidosAbertos}">
                                <p class="conta-nada">Nenhum pedido em aberto. Tudo pago por aqui.</p>
                            </c:when>
                            <c:otherwise>
                                <ul class="conta-pedidos">
                                    <c:forEach var="p" items="${pedidosAbertos}">
                                        <li class="conta-comanda">
                                            <p class="comanda-cabeca">BIG TITES · PEDIDO #${p.codpedido}</p>
                                            <p class="comanda-meta">
                                                <span>${p.datahoraFormatada}</span>
                                                <span>Mesa ${p.mesaPedido.numeroMesa}</span>
                                            </p>
                                            <hr class="comanda-regua">

                                            <c:set var="itensDoPedido" value="${itensPorPedido[p.codpedido]}"/>
                                            <c:choose>
                                                <c:when test="${empty itensDoPedido}">
                                                    <p class="comanda-item"><span>(comanda ainda sem itens)</span><span></span></p>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="it" items="${itensDoPedido}">
                                                        <p class="comanda-item">
                                                            <span>${it.quantidade}x ${it.cardapioItem.nomeComida}</span>
                                                            <span><fmt:formatNumber value="${it.subtotal}" pattern="#,##0.00"/></span>
                                                        </p>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>

                                            <hr class="comanda-regua">
                                            <p class="comanda-total">
                                                <span>TOTAL</span>
                                                <span>R$ <fmt:formatNumber value="${p.total}" pattern="#,##0.00"/></span>
                                            </p>
                                            <c:if test="${p.valorRecebido > 0}">
                                                <p class="comanda-item">
                                                    <span>JÁ PAGO</span>
                                                    <span><fmt:formatNumber value="${p.valorRecebido}" pattern="#,##0.00"/></span>
                                                </p>
                                                <p class="comanda-total">
                                                    <span>FALTA</span>
                                                    <span>R$ <fmt:formatNumber value="${p.falta}" pattern="#,##0.00"/></span>
                                                </p>
                                            </c:if>
                                            <p class="comanda-pe">EM ABERTO</p>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:otherwise>
                        </c:choose>

                        <%-- Histórico: os pagos ficam guardados, só saem da frente. --%>
                        <c:if test="${not empty pedidosPagos}">
                            <details class="conta-historico">
                                <summary>
                                    <span>Pedidos pagos</span>
                                    <span class="conta-historico-conta">${fn:length(pedidosPagos)}</span>
                                </summary>
                                <ul class="conta-pagos">
                                    <c:forEach var="p" items="${pedidosPagos}">
                                        <li>
                                            <p class="conta-pago-linha">
                                                <b>#${p.codpedido}</b>
                                                <span>${p.datahoraFormatada}</span>
                                                <b>R$ <fmt:formatNumber value="${p.total}" pattern="#,##0.00"/></b>
                                            </p>
                                            <p class="conta-pago-itens"><c:out value="${p.resumoItens}"/></p>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </details>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </section>

            <%-- ===== DADOS ===== --%>
            <section aria-labelledby="tituloDados">
                <h2 class="conta-subtitulo" id="tituloDados">
                    <i class="fa-solid fa-id-card" aria-hidden="true"></i>Meus dados
                </h2>

                <form class="ficha conta-ficha" method="post"
                      action="${pageContext.request.contextPath}${URL_BASE}/PerfilControlador">
                    <input type="hidden" name="opcao" value="atualizar">

                    <c:if test="${not empty erro}">
                        <p class="recado"><i class="fa-solid fa-circle-exclamation" aria-hidden="true"></i> ${erro}</p>
                    </c:if>
                    <c:if test="${not empty sessionScope.flash}">
                        <p class="recado ok"><i class="fa-solid fa-circle-check" aria-hidden="true"></i> ${sessionScope.flash}</p>
                        <c:remove var="flash" scope="session"/>
                    </c:if>

                    <div class="campo">
                        <label for="nome"><i class="fa-solid fa-user" aria-hidden="true"></i>Nome</label>
                        <input type="text" id="nome" name="nomeCliente" value="<c:out value='${cliente.nomeCliente}'/>"
                               autocomplete="name" maxlength="150" required>
                    </div>

                    <div class="campo">
                        <label for="email"><i class="fa-solid fa-envelope" aria-hidden="true"></i>Email</label>
                        <input type="email" id="email" value="<c:out value='${cliente.email}'/>" readonly>
                        <p class="campo-dica">O email é o seu login e não muda por aqui.</p>
                    </div>

                    <div class="campo">
                        <label for="telefone"><i class="fa-solid fa-phone" aria-hidden="true"></i>Telefone</label>
                        <input type="tel" id="telefone" name="telefone" value="<c:out value='${cliente.telefone}'/>"
                               placeholder="35 99999-9999" data-mascara="celular" autocomplete="tel" required>
                    </div>

                    <div class="campo">
                        <label for="cpf"><i class="fa-solid fa-id-card" aria-hidden="true"></i>CPF</label>
                        <input type="text" id="cpf" name="cpfCliente" value="<c:out value='${cliente.cpfCliente}'/>"
                               placeholder="000.000.000-00" data-mascara="cpf" required>
                    </div>

                    <button class="btn-ficha" type="submit" data-ocupado="Salvando…">
                        <i class="fa-solid fa-floppy-disk" aria-hidden="true"></i>Salvar meus dados
                    </button>

                    <p class="ficha-rodape">
                        Quer trocar a senha?
                        <a href="${pageContext.request.contextPath}/esqueci-senha.jsp">Receba um link por email</a>
                        <br>
                        <a href="${pageContext.request.contextPath}${URL_BASE}/LoginControlador?opcao=sair">Sair da conta</a>
                    </p>
                </form>
            </section>

        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/js/mascaras.js?v=${VERSAO}"></script>
<script src="${pageContext.request.contextPath}/js/balcao.js?v=${VERSAO}"></script>
</body>
</html>
