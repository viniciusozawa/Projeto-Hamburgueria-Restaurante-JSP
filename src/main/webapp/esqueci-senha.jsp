<%--
    Etapa 1 de "esqueci minha senha": pedir o link por email.

    Serve cliente e funcionário. Fica liberada no AuthFilter — quem esqueceu
    a senha, por definição, não consegue entrar.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Esqueci minha senha — Big Tites</title>
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
            <img src="https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1586190848861-99aa4a171e90?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1610614819513-58e34989848b?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1581636625402-29b2a704ef13?auto=format&fit=crop&w=420&q=60" alt="">
        </div>

        <div class="balcao-topo">
            <a class="marca" href="${pageContext.request.contextPath}/index.jsp">
                <i class="fa-solid fa-burger" aria-hidden="true"></i>Big Tites<span class="ponto">.</span>
            </a>
            <a class="balcao-volta" href="${pageContext.request.contextPath}/login.jsp">
                <i class="fa-solid fa-arrow-left" aria-hidden="true"></i>Voltar ao login
            </a>
        </div>

        <div>
            <h1 class="balcao-frase">Acontece com <em>todo mundo</em></h1>
            <ul class="balcao-lista">
                <li class="balcao-item">
                    <i class="fa-solid fa-envelope" aria-hidden="true"></i>
                    <span><b>Informe seu email</b>Mandamos um link para criar uma senha nova.</span>
                </li>
                <li class="balcao-item">
                    <i class="fa-solid fa-hourglass-half" aria-hidden="true"></i>
                    <span><b>Vale 1 hora</b>E só funciona uma vez, por segurança.</span>
                </li>
                <li class="balcao-item">
                    <i class="fa-solid fa-shield-halved" aria-hidden="true"></i>
                    <span><b>Sua senha continua a mesma</b>Ela só muda quando você abrir o link.</span>
                </li>
            </ul>
        </div>
    </aside>

    <main class="balcao-painel">
        <form class="ficha" method="post"
              action="${pageContext.request.contextPath}${URL_BASE}/SenhaControlador">

            <div class="ficha-cabeca">
                <p class="ficha-selo" aria-hidden="true"><i class="fa-solid fa-key"></i></p>
                <h2 class="ficha-titulo">Esqueci minha senha</h2>
                <p class="ficha-sub">BIG TITES · RECUPERAÇÃO</p>
            </div>

            <c:if test="${not empty erro}">
                <p class="recado"><i class="fa-solid fa-circle-exclamation" aria-hidden="true"></i> ${erro}</p>
            </c:if>
            <c:if test="${not empty aviso}">
                <p class="recado ok"><i class="fa-solid fa-circle-check" aria-hidden="true"></i> ${aviso}</p>
            </c:if>

            <p class="ficha-texto">
                Digite o email da sua conta. Se ela existir, você recebe um link para
                criar uma senha nova.
            </p>

            <input type="hidden" name="opcao" value="pedir"/>

            <div class="campo">
                <label for="email"><i class="fa-solid fa-envelope" aria-hidden="true"></i>Email da conta</label>
                <input type="email" id="email" name="email" value="${emailDigitado}"
                       placeholder="exemplo@gmail.com" autocomplete="email"
                       autofocus required>
            </div>

            <button class="btn-ficha" type="submit">
                <i class="fa-solid fa-paper-plane" aria-hidden="true"></i>Mandar o link
            </button>

            <p class="ficha-rodape">
                Lembrou a senha?
                <a href="${pageContext.request.contextPath}/login.jsp">Entrar</a>
            </p>
        </form>
    </main>

</div>

</body>
</html>
