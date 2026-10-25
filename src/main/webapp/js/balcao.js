/* Comportamento das telas de login e criação de conta.
   Arquivo único porque as duas compartilham os mesmos controles. */
(function () {
    'use strict';

    /* --- mostrar/esconder senha --- */
    document.querySelectorAll('.olho').forEach(function (botao) {
        botao.addEventListener('click', function () {
            var campo = document.getElementById(botao.getAttribute('data-alvo'));
            if (!campo) return;

            var revelando = campo.type === 'password';
            campo.type = revelando ? 'text' : 'password';

            botao.setAttribute('aria-pressed', revelando ? 'true' : 'false');
            botao.setAttribute('aria-label', revelando ? 'Esconder a senha' : 'Mostrar a senha');
            botao.querySelector('i').className = revelando
                ? 'fa-solid fa-eye-slash'
                : 'fa-solid fa-eye';
        });
    });

    /* --- botão avisa que está trabalhando ---
       Login e envio de email levam alguns segundos; sem retorno a pessoa
       clica de novo. O texto vem de data-ocupado ("Entrando…"). */
    document.querySelectorAll('form').forEach(function (f) {
        f.addEventListener('submit', function (e) {
            if (e.defaultPrevented || !f.checkValidity()) return;
            var botao = f.querySelector('.btn-ficha[type="submit"]');
            if (!botao) return;
            var texto = botao.getAttribute('data-ocupado') || 'Um instante…';
            /* deixa o envio sair antes de desabilitar */
            setTimeout(function () {
                botao.disabled = true;
                botao.setAttribute('aria-busy', 'true');
                botao.innerHTML = '<i class="fa-solid fa-circle-notch fa-spin" aria-hidden="true"></i>' + texto;
            }, 0);
        });
    });

    /* --- criação de conta: quantos campos ainda faltam --- */
    var form = document.getElementById('formConta');
    if (!form) return;

    var contagem  = document.getElementById('contagem');
    var barras    = form.querySelectorAll('.ficha-passos span');
    var campos    = form.querySelectorAll('input[required]');
    var senha     = document.getElementById('senha');
    var confirmar = document.getElementById('confirmar');   // pode não existir
    var dica      = document.getElementById('dicaSenha');

    function conferir() {
        /* O "repetir senha" é opcional no formulário: só confere se os dois
           campos existirem. Referenciar um campo ausente derrubava o script
           inteiro e levava junto o contador. */
        if (senha && confirmar) {
            var divergem = confirmar.value && confirmar.value !== senha.value;
            confirmar.setCustomValidity(divergem ? 'As senhas estão diferentes.' : '');
            if (dica) {
                dica.textContent = divergem
                    ? 'As senhas estão diferentes. Repita a mesma senha do campo acima.'
                    : '';
            }
        }

        var prontos = 0;
        campos.forEach(function (c) {
            if (c.value.trim() && c.checkValidity()) prontos++;
        });

        barras.forEach(function (b, i) { b.classList.toggle('ok', i < prontos); });
        if (contagem) {
            contagem.textContent = prontos + ' de ' + campos.length + ' preenchidos';
        }
    }

    campos.forEach(function (c) { c.addEventListener('input', conferir); });
    conferir();
})();
