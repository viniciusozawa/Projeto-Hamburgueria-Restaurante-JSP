<%--
    Segunda etapa do cadastro do cliente: telefone e CPF.

    Só chega aqui quem já confirmou o email. Enquanto cadastroCompleto for 0,
    o LoginControlador manda para cá em vez da vitrine.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Completar cadastro — Big Tites</title>
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
            <img src="https://images.unsplash.com/photo-1610614819513-58e34989848b?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1607920591413-4ec007e70023?auto=format&fit=crop&w=420&q=60" alt="">
        </div>

        <div class="balcao-topo">
            <a class="marca" href="${pageContext.request.contextPath}/index.jsp">
                <i class="fa-solid fa-burger" aria-hidden="true"></i>Big Tites<span class="ponto">.</span>
            </a>
        </div>

        <div>
            <h1 class="balcao-frase">Email confirmado. Agora o <em>resto</em></h1>
            <ul class="balcao-lista">
                <li class="balcao-item">
                    <i class="fa-solid fa-phone" aria-hidden="true"></i>
                    <span><b>Telefone</b>A gente avisa quando o pedido sai da chapa.</span>
                </li>
                <li class="balcao-item">
                    <i class="fa-solid fa-receipt" aria-hidden="true"></i>
                    <span><b>CPF</b>Vai na nota quando você pedir no balcão.</span>
                </li>
                <li class="balcao-item">
                    <i class="fa-solid fa-lock" aria-hidden="true"></i>
                    <span><b>Fica com você</b>Não mandamos seus dados para ninguém.</span>
                </li>
            </ul>
        </div>
    </aside>

    <main class="balcao-painel">
        <form class="ficha" id="formConta" method="post"
              action="${pageContext.request.contextPath}${URL_BASE}/PerfilControlador">

            <div class="ficha-cabeca">
                <h2 class="ficha-titulo">Quase lá</h2>
                <p class="ficha-sub">BIG TITES · PASSO 2 DE 2</p>
                <div class="ficha-passos" aria-hidden="true">
                    <span></span><span></span>
                </div>
                <p class="ficha-sub" id="contagem" role="status" style="margin-top:6px">0 de 2 preenchidos</p>
            </div>

            <c:if test="${not empty erro}">
                <p class="recado"><i class="fa-solid fa-circle-exclamation" aria-hidden="true"></i> ${erro}</p>
            </c:if>
            <c:if test="${not empty sessionScope.flash}">
                <p class="recado ok"><i class="fa-solid fa-circle-check" aria-hidden="true"></i> ${sessionScope.flash}</p>
                <c:remove var="flash" scope="session"/>
            </c:if>

            <p class="ficha-texto">
                Só mais dois dados, <b>${sessionScope.usuario.primeiroNome}</b>. O telefone é para
                avisarmos quando o pedido sair; o CPF, para a nota.
            </p>

            <div class="campo">
                <label for="telefone"><i class="fa-solid fa-phone" aria-hidden="true"></i>Telefone</label>
                <input type="tel" id="telefone" name="telefone" value="${telefoneDigitado}"
                       placeholder="(35) 9 0000-0000" inputmode="tel"
                       autocomplete="tel" autofocus required>
            </div>

            <div class="campo">
                <label for="cpf"><i class="fa-solid fa-id-card" aria-hidden="true"></i>CPF</label>
                <input type="text" id="cpf" name="cpfCliente" value="${cpfDigitado}"
                       placeholder="000.000.000-00" inputmode="numeric"
                       maxlength="14" required>
                <p class="campo-dica">Pode digitar só os números.</p>
            </div>

            <button class="btn-ficha" type="submit">
                <i class="fa-solid fa-check" aria-hidden="true"></i>Concluir cadastro
            </button>

            <p class="ficha-rodape">
                <a href="${pageContext.request.contextPath}${URL_BASE}/LoginControlador?opcao=sair">Sair da conta</a>
            </p>
        </form>
    </main>

</div>

<script src="${pageContext.request.contextPath}/js/balcao.js"></script>

</body>
</html>
