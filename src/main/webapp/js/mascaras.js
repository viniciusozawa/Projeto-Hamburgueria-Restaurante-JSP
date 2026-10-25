/* Máscaras de CPF e celular.

   Uso: data-mascara="cpf" ou data-mascara="celular" no elemento.
   - Em <input>, formata enquanto a pessoa digita: ela digita só os números
     e os pontos, traço e espaço aparecem sozinhos.
   - Em qualquer outro elemento (ex.: <td>), formata o texto já gravado.

   O servidor guarda só os dígitos: a máscara é assunto da tela. */
(function () {
    'use strict';

    var FORMATOS = {
        /* 123.123.123-02 */
        cpf: {
            max: 11,
            formatar: function (d) {
                return d.replace(/^(\d{3})(\d)/, '$1.$2')
                        .replace(/^(\d{3})\.(\d{3})(\d)/, '$1.$2.$3')
                        .replace(/\.(\d{3})(\d{1,2})$/, '.$1-$2');
            }
        },
        /* 35 99999-9999 (celular) ou 35 9999-9999 (fixo) */
        celular: {
            max: 11,
            formatar: function (d) {
                if (d.length <= 2) return d;
                var ddd = d.slice(0, 2), resto = d.slice(2);
                /* com 9 dígitos o traço vem depois do quinto; com 8, do quarto */
                var corte = resto.length > 8 ? 5 : 4;
                if (resto.length > corte) {
                    resto = resto.slice(0, corte) + '-' + resto.slice(corte);
                }
                return ddd + ' ' + resto;
            }
        }
    };

    function digitos(texto) {
        return (texto || '').replace(/\D/g, '');
    }

    /* Posição no texto formatado logo depois do n-ésimo dígito. Mantém o
       cursor no lugar quando a pessoa corrige um número no meio do campo. */
    function posicaoDepoisDe(formatado, n) {
        if (n === 0) return 0;
        for (var i = 0, vistos = 0; i < formatado.length; i++) {
            if (/\d/.test(formatado[i]) && ++vistos === n) return i + 1;
        }
        return formatado.length;
    }

    function aplicar(campo, formato) {
        var antes = campo.value.slice(0, campo.selectionStart || 0);
        var digitosAntes = digitos(antes).length;

        var d = digitos(campo.value).slice(0, formato.max);
        var formatado = formato.formatar(d);
        campo.value = formatado;

        /* só mexe no cursor se o campo estiver em foco, senão alguns
           navegadores roubam o foco para ele */
        if (document.activeElement === campo) {
            var pos = posicaoDepoisDe(formatado, Math.min(digitosAntes, d.length));
            campo.setSelectionRange(pos, pos);
        }
    }

    document.querySelectorAll('[data-mascara]').forEach(function (el) {
        var formato = FORMATOS[el.getAttribute('data-mascara')];
        if (!formato) return;

        if (el.tagName !== 'INPUT') {
            var d = digitos(el.textContent);
            /* não mexe em valor antigo que não tenha o tamanho certo */
            if (d.length >= 10 && d.length <= formato.max) {
                el.textContent = formato.formatar(d);
            }
            return;
        }

        el.setAttribute('inputmode', 'numeric');
        /* o limite de dígitos já é da máscara; um maxlength cortaria um valor
           colado com parênteses antes de a máscara limpar */
        el.removeAttribute('maxlength');
        el.addEventListener('input', function () { aplicar(el, formato); });
        /* valor que veio do servidor (ex.: ao editar ou ao voltar com erro) */
        if (el.value) aplicar(el, formato);
    });
})();
