<%--
    Etapa 2 de "esqueci minha senha": criar a senha nova.

    Só é exibida depois que o SenhaControlador conferiu o token. Ele viaja
    num campo escondido, e não na URL: URL vai para o histórico do navegador
    e para o cabeçalho Referer.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Criar senha nova — Big Tites</title>
    <meta name="robots" content="noindex">
    <meta name="referrer" content="no-referrer">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&family=Rubik:wght@400;500;600;700&family=Courier+Prime:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/estilo.css?v=${VERSAO}">
</head>
<body class="vitrine balcao">

<div class="balcao-grade">

    <aside class="balcao-palco">
        <div class="balcao-mosaico" aria-hidden="true">
            <img src="https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1607920591413-4ec007e70023?auto=format&fit=crop&w=420&q=60" alt="">
        </div>

        <div class="balcao-topo">
            <a class="marca" href="${pageContext.request.contextPath}/index.jsp">
                <i class="fa-solid fa-burger" aria-hidden="true"></i>Big Tites<span class="ponto">.</span>
            </a>
        </div>

        <div>
            <h1 class="balcao-frase">Escolha uma senha <em>nova</em></h1>
            <ul class="balcao-lista">
                <li class="balcao-item">
                    <i class="fa-solid fa-circle-check" aria-hidden="true"></i>
                    <span><b>Link conferido</b>É você mesmo. Agora é só escolher a senha.</span>
                </li>
                <li class="balcao-item">
                    <i class="fa-solid fa-lock" aria-hidden="true"></i>
                    <span><b>Mínimo de 6 caracteres</b>Evite a mesma senha de outros sites.</span>
                </li>
                <li class="balcao-item">
                    <i class="fa-solid fa-right-to-bracket" aria-hidden="true"></i>
                    <span><b>Depois é só entrar</b>Levamos você para o login com a senha nova.</span>
                </li>
            </ul>
        </div>
    </aside>

    <main class="balcao-painel">
        <form class="ficha" id="formConta" method="post"
              action="${pageContext.request.contextPath}${URL_BASE}/SenhaControlador">

            <div class="ficha-cabeca">
                <p class="ficha-selo" aria-hidden="true"><i class="fa-solid fa-lock-open"></i></p>
                <h2 class="ficha-titulo">Criar senha nova</h2>
                <p class="ficha-sub">BIG TITES · RECUPERAÇÃO</p>
                <div class="ficha-passos" aria-hidden="true">
                    <span></span><span></span>
                </div>
                <p class="ficha-sub" id="contagem" role="status" style="margin-top:6px">0 de 2 preenchidos</p>
            </div>

            <c:if test="${not empty erro}">
                <p class="recado"><i class="fa-solid fa-circle-exclamation" aria-hidden="true"></i> ${erro}</p>
            </c:if>

            <input type="hidden" name="opcao" value="redefinir"/>
            <input type="hidden" name="token" value="${token}"/>

            <div class="campo campo-senha">
                <label for="senha"><i class="fa-solid fa-lock" aria-hidden="true"></i>Senha nova</label>
                <input type="password" id="senha" name="senha"
                       placeholder="mínimo de 6 caracteres" minlength="6"
                       autocomplete="new-password" autofocus required>
                <button class="olho" type="button" data-alvo="senha"
                        aria-label="Mostrar a senha" aria-pressed="false">
                    <i class="fa-solid fa-eye" aria-hidden="true"></i>
                </button>
            </div>

            <div class="campo campo-senha">
                <label for="confirmar"><i class="fa-solid fa-lock" aria-hidden="true"></i>Repetir a senha</label>
                <input type="password" id="confirmar" name="confirmar"
                       placeholder="a mesma senha de cima" minlength="6"
                       autocomplete="new-password" required>
                <button class="olho" type="button" data-alvo="confirmar"
                        aria-label="Mostrar a senha" aria-pressed="false">
                    <i class="fa-solid fa-eye" aria-hidden="true"></i>
                </button>
                <p class="campo-dica" id="dicaSenha" role="status"></p>
            </div>

            <button class="btn-ficha" type="submit" data-ocupado="Salvando a senha…">
                <i class="fa-solid fa-check" aria-hidden="true"></i>Salvar senha nova
            </button>

            <p class="ficha-rodape">
                Mudou de ideia?
                <a href="${pageContext.request.contextPath}/login.jsp">Voltar ao login</a>
            </p>
        </form>
    </main>

</div>

<script src="${pageContext.request.contextPath}/js/balcao.js?v=${VERSAO}"></script>

</body>
</html>
