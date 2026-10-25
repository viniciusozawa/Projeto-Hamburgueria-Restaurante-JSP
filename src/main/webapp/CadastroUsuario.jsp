<%--
    Criação de conta do cliente. Os names dos campos seguem os da tabela
    `cliente`, então o controlador de cadastro lê direto com getParameter.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Criar conta — Big Tites</title>
    <meta name="robots" content="noindex">
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
            <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=420&q=60" alt="">
            <img src="https://images.unsplash.com/photo-1607920591413-4ec007e70023?auto=format&fit=crop&w=420&q=60" alt="">
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
            <h1 class="balcao-frase">Sua conta guarda os <em>pedidos</em></h1>
            <ul class="balcao-lista">
                <li class="balcao-item">
                    <i class="fa-solid fa-receipt" aria-hidden="true"></i>
                    <span><b>Seu nome na comanda</b>O balcão puxa seus dados na hora do pedido.</span>
                </li>
                <li class="balcao-item">
                    <i class="fa-solid fa-clock-rotate-left" aria-hidden="true"></i>
                    <span><b>Histórico de pedidos</b>Veja o que você já pediu e repita em um toque.</span>
                </li>
                <li class="balcao-item">
                    <i class="fa-solid fa-bolt" aria-hidden="true"></i>
                    <span><b>Pedido mais rápido</b>Sem repetir CPF e telefone a cada visita.</span>
                </li>
            </ul>
        </div>
    </aside>

    <main class="balcao-painel">
        <%-- Controlador próprio para a criação de conta: liberar o
             ClienteController inteiro no AuthFilter deixaria opcao=listar
             aberta e a lista de clientes ficaria pública. --%>
        <form class="ficha" id="formConta" method="post"
              action="${pageContext.request.contextPath}${URL_BASE}/CadastroControlador">

            <div class="ficha-cabeca">
                <h2 class="ficha-titulo">Criar conta</h2>
                <p class="ficha-sub">BIG TITES · CLIENTE</p>
                <div class="ficha-passos" aria-hidden="true">
                    <span></span><span></span><span></span>
                </div>
                <p class="ficha-sub" id="contagem" role="status" style="margin-top:6px">0 de 3 preenchidos</p>
            </div>

            <c:if test="${not empty erro}">
                <p class="recado"><i class="fa-solid fa-circle-exclamation" aria-hidden="true"></i> ${erro}</p>
            </c:if>

            <div class="campo">
                <label for="nome"><i class="fa-solid fa-user" aria-hidden="true"></i>Nome completo</label>
                <input type="text" id="nome" name="nomeCliente" value="${nomeDigitado}"
                       placeholder="como está no documento" maxlength="150"
                       autocomplete="name" autofocus required>
            </div>

            <div class="campo">
                <label for="email"><i class="fa-solid fa-envelope" aria-hidden="true"></i>Email</label>
                <input type="email" id="email" name="email" value="${emailDigitado}"
                       placeholder="exemplo@gmail.com" maxlength="255"
                       autocomplete="email" required>
            </div>

            <div class="campo campo-senha">
                <label for="senha"><i class="fa-solid fa-lock" aria-hidden="true"></i>Senha</label>
                <input type="password" id="senha" name="senhaCliente"
                       placeholder="mínimo de 6 caracteres" minlength="6"
                       autocomplete="new-password" required>
                <button class="olho" type="button" data-alvo="senha"
                        aria-label="Mostrar a senha" aria-pressed="false">
                    <i class="fa-solid fa-eye" aria-hidden="true"></i>
                </button>
            </div>


            <button class="btn-ficha" type="submit" data-ocupado="Criando a conta…">
                <i class="fa-solid fa-user-plus" aria-hidden="true"></i>Criar conta
            </button>

            <p class="ficha-rodape">
                Já tem conta?
                <a href="${pageContext.request.contextPath}/login.jsp">Entrar</a>
            </p>
        </form>
    </main>

</div>

<script src="${pageContext.request.contextPath}/js/balcao.js?v=${VERSAO}"></script>

</body>
</html>
