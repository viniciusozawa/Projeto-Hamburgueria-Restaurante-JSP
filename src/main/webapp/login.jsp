<%--
    Entrada no sistema. O formulário já aponta para o LoginControlador
    que o AuthFilter libera — falta só escrever o servlet.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Entrar — Big Tites</title>
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
            <h1 class="balcao-frase">Quem está no balcão entra <em>por aqui</em></h1>
            <ul class="balcao-lista">
                <li class="balcao-item">
                    <i class="fa-solid fa-receipt" aria-hidden="true"></i>
                    <span><b>Comandas abertas</b>Veja o que está na chapa agora e feche a conta.</span>
                </li>
                <li class="balcao-item">
                    <i class="fa-solid fa-boxes-stacked" aria-hidden="true"></i>
                    <span><b>Cardápio e estoque</b>Preços, ingredientes e fornecedores num lugar só.</span>
                </li>
                <li class="balcao-item">
                    <i class="fa-solid fa-user-shield" aria-hidden="true"></i>
                    <span><b>Acesso por cargo</b>Os módulos que aparecem dependem da sua função.</span>
                </li>
            </ul>
        </div>
    </aside>

    <main class="balcao-painel">
        <form class="ficha" method="post"
              action="${pageContext.request.contextPath}${URL_BASE}/LoginControlador">

            <div class="ficha-cabeca">
                <h2 class="ficha-titulo">Entrar</h2>
                <p class="ficha-sub">BIG TITES · SISTEMA</p>
            </div>

            <c:if test="${not empty erro}">
                <p class="recado"><i class="fa-solid fa-circle-exclamation" aria-hidden="true"></i> ${erro}</p>
            </c:if>
            <c:if test="${not empty flash}">
                <p class="recado ok"><i class="fa-solid fa-circle-check" aria-hidden="true"></i> ${flash}</p>
                <c:remove var="flash" scope="session"/>
            </c:if>
            <c:if test="${param.saiu eq '1'}">
                <p class="recado ok"><i class="fa-solid fa-circle-check" aria-hidden="true"></i> Sessão encerrada.</p>
            </c:if>

            <div class="campo">
                <label for="email"><i class="fa-solid fa-envelope" aria-hidden="true"></i>Email</label>
                <input type="email" id="email" name="email" value="${emailDigitado}"
                       placeholder="exemplo@gmail.com" autocomplete="username"
                       autofocus required>
            </div>

            <div class="campo campo-senha">
                <label for="senha"><i class="fa-solid fa-lock" aria-hidden="true"></i>Senha</label>
                <input type="password" id="senha" name="senha"
                       placeholder="sua senha" autocomplete="current-password" required>
                <button class="olho" type="button" data-alvo="senha"
                        aria-label="Mostrar a senha" aria-pressed="false">
                    <i class="fa-solid fa-eye" aria-hidden="true"></i>
                </button>
            </div>

            <p class="campo-esqueci">
                <a href="${pageContext.request.contextPath}/esqueci-senha.jsp">Esqueci minha senha</a>
            </p>

            <button class="btn-ficha" type="submit">
                <i class="fa-solid fa-right-to-bracket" aria-hidden="true"></i>Entrar
            </button>

            <p class="ficha-rodape">
                Primeira vez aqui?
                <a href="${pageContext.request.contextPath}/CadastroUsuario.jsp">Criar conta</a>
            </p>
        </form>
    </main>

</div>

<script src="${pageContext.request.contextPath}/js/balcao.js"></script>

</body>
</html>
