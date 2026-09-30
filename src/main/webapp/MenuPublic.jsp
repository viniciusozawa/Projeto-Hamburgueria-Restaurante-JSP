<%-- Cabeçalho da vitrine pública.

     ATENÇÃO: isto é um FRAGMENTO. Não pode ter <!DOCTYPE>, <html>, <head>,
     <body> nem diretiva <%@page%>, porque ele é colado dentro do index.jsp
     por <%@include%>. Se voltar a ser um documento completo, ele fecha
     </body></html> no meio da home e quebra a página inteira.
--%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<header class="topo">
    <div class="faixa topo-grade">
        <a class="marca" href="${pageContext.request.contextPath}/index.jsp">Big Tites<span class="ponto">.</span></a>

        <button class="topo-botao" type="button" aria-expanded="false" aria-controls="topoLinks" aria-label="Abrir o menu">
            <span aria-hidden="true"></span>
            <span aria-hidden="true"></span>
            <span aria-hidden="true"></span>
        </button>

        <ul class="topo-links" id="topoLinks">
            <li><a href="${pageContext.request.contextPath}/index.jsp#cardapio">Cardápio</a></li>
            <li><a href="${pageContext.request.contextPath}/index.jsp#casa">A casa</a></li>
            <li><a href="${pageContext.request.contextPath}/index.jsp#onde">Onde achar</a></li>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <li><a class="topo-entrar" href="${pageContext.request.contextPath}/painel.jsp">Abrir o painel</a></li>
                </c:when>
                <c:otherwise>
                    <li><a class="topo-entrar" href="${pageContext.request.contextPath}/login.jsp">Entrar</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</header>

<script>
    /* Menu do celular: o botão controla a lista e mantém aria-expanded honesto. */
    (function () {
        var botao = document.querySelector('.topo-botao');
        var lista = document.getElementById('topoLinks');
        if (!botao || !lista) return;

        botao.addEventListener('click', function () {
            var aberto = lista.classList.toggle('aberto');
            botao.setAttribute('aria-expanded', aberto ? 'true' : 'false');
            botao.setAttribute('aria-label', aberto ? 'Fechar o menu' : 'Abrir o menu');
        });
    })();
</script>
