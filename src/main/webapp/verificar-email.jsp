<%--
    Confirmação de email do cliente.

    Serve a três momentos: logo após criar a conta, ao tentar entrar sem ter
    confirmado, e como resposta de um link aberto (válido, vencido ou já usado).
    Fica liberada no AuthFilter — quem chega aqui ainda não conseguiu entrar.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirme seu email — Big Tites</title>
    <meta name="robots" content="noindex">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&family=Rubik:wght@400;500;600;700&family=Courier+Prime:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css">
</head>
<body class="vitrine balcao">

<div class="balcao-grade">

    <aside class="balcao-palco">
        <div class="balcao-mosaico" aria-hidden="true">
            <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1581636625402-29b2a704ef13?auto=format&fit=crop&w=420&q=60" alt="">
        </div>

        <div class="balcao-topo">
            <a class="marca" href="${pageContext.request.contextPath}/index.jsp">
                <i class="fa-solid fa-burger" aria-hidden="true"></i>Big Tites<span class="ponto">.</span>
            </a>
            <a class="balcao-volta" href="${pageContext.request.contextPath}/index.jsp">
                <i class="fa-solid fa-arrow-left" aria-hidden="true"></i>Ver o cardápio
            </a>
        </div>

        <div>
            <h1 class="balcao-frase">Falta um passo <em>só</em></h1>
            <ul class="balcao-lista">
                <li class="balcao-item">
                    <i class="fa-solid fa-envelope" aria-hidden="true"></i>
                    <span><b>Mandamos um link</b>Abra o email e clique para confirmar a conta.</span>
                </li>
                <li class="balcao-item">
                    <i class="fa-solid fa-shield-halved" aria-hidden="true"></i>
                    <span><b>Por que confirmar</b>Garante que o email é seu antes de liberar a conta.</span>
                </li>
                <li class="balcao-item">
                    <i class="fa-solid fa-clock" aria-hidden="true"></i>
                    <span><b>Vale por 24 horas</b>Passou do prazo? Peça outro aqui do lado.</span>
                </li>
            </ul>
        </div>
    </aside>

    <main class="balcao-painel">
        <div class="ficha">

            <div class="ficha-cabeca">
                <p class="ficha-selo" aria-hidden="true"><i class="fa-solid fa-envelope-circle-check"></i></p>
                <h2 class="ficha-titulo">
                    <c:choose>
                        <c:when test="${situacao eq 'jafeito'}">Já confirmado</c:when>
                        <c:when test="${situacao eq 'expirado'}">Link vencido</c:when>
                        <c:when test="${situacao eq 'invalido'}">Link inválido</c:when>
                        <c:otherwise>Confirme seu email</c:otherwise>
                    </c:choose>
                </h2>
                <p class="ficha-sub">BIG TITES · CLIENTE</p>
            </div>

            <c:if test="${not empty mensagem}">
                <p class="recado"><i class="fa-solid fa-circle-exclamation" aria-hidden="true"></i> ${mensagem}</p>
            </c:if>
            <c:if test="${not empty erro}">
                <p class="recado"><i class="fa-solid fa-circle-exclamation" aria-hidden="true"></i> ${erro}</p>
            </c:if>
            <c:if test="${not empty aviso}">
                <p class="recado ok"><i class="fa-solid fa-circle-check" aria-hidden="true"></i> ${aviso}</p>
            </c:if>
            <c:if test="${not empty sessionScope.flash}">
                <p class="recado ok"><i class="fa-solid fa-circle-check" aria-hidden="true"></i> ${sessionScope.flash}</p>
                <c:remove var="flash" scope="session"/>
            </c:if>
            <%-- Sem sessão (link salvo, sessão expirada) não há email para citar.
                 Antes saía "O link foi para ." com o endereço em branco. --%>
            <c:if test="${param.pendente eq '1'}">
                <p class="recado"><i class="fa-solid fa-circle-exclamation" aria-hidden="true"></i>
                    <c:choose>
                        <c:when test="${not empty sessionScope.emailPendente}">
                            Confirme seu email antes de entrar. O link foi para
                            <b>${sessionScope.emailPendente}</b>.
                        </c:when>
                        <c:otherwise>
                            Confirme seu email antes de entrar. Informe seu endereço abaixo
                            para receber o link de novo.
                        </c:otherwise>
                    </c:choose>
                </p>
            </c:if>

            <p class="ficha-texto">
                Abra sua caixa de entrada e clique no link. Ele vale por 24&nbsp;horas.
                Se não chegou, confira o spam ou peça outro aqui.
            </p>

            <form method="post"
                  action="${pageContext.request.contextPath}${URL_BASE}/VerificacaoControlador">
                <div class="campo">
                    <label for="email"><i class="fa-solid fa-envelope" aria-hidden="true"></i>Seu email</label>
                    <input type="email" id="email" name="email"
                           value="${not empty emailDigitado ? emailDigitado : sessionScope.emailPendente}"
                           placeholder="exemplo@gmail.com" autocomplete="email" required>
                </div>

                <button class="btn-ficha" type="submit">
                    <i class="fa-solid fa-paper-plane" aria-hidden="true"></i>Reenviar o link
                </button>
            </form>

            <p class="ficha-rodape">
                Já confirmou?
                <a href="${pageContext.request.contextPath}/login.jsp">Entrar</a>
            </p>
        </div>
    </main>

</div>

</body>
</html>
