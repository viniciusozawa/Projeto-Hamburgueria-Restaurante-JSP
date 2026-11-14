/* Tela de relatórios (Relatorios.jsp).

   1. Atalhos de período: preenchem o "De" e o "Até".
   2. No envio de um cartão com período, copia as datas do topo para ele
      e confere se o "De" não ficou depois do "Até".

   Sem JavaScript os cartões ainda funcionam, só que com todo o período. */
(function () {
    'use strict';

    var inicio = document.getElementById('dataInicio');
    var fim = document.getElementById('dataFim');
    var aviso = document.getElementById('avisoPeriodo');
    if (!inicio || !fim) return;

    /* aaaa-mm-dd na data LOCAL (toISOString usaria UTC e erraria o dia à noite) */
    function iso(d) {
        var m = String(d.getMonth() + 1).padStart(2, '0');
        var dia = String(d.getDate()).padStart(2, '0');
        return d.getFullYear() + '-' + m + '-' + dia;
    }

    function avisar(texto) {
        aviso.textContent = texto || '';
        aviso.hidden = !texto;
    }

    /* ---------- 1. atalhos ---------- */
    document.querySelectorAll('[data-periodo]').forEach(function (botao) {
        botao.addEventListener('click', function () {
            var hoje = new Date();
            var de = '', ate = '';
            switch (botao.dataset.periodo) {
                case 'mes':
                    de = iso(new Date(hoje.getFullYear(), hoje.getMonth(), 1));
                    ate = iso(hoje);
                    break;
                case 'mes-passado':
                    de = iso(new Date(hoje.getFullYear(), hoje.getMonth() - 1, 1));
                    ate = iso(new Date(hoje.getFullYear(), hoje.getMonth(), 0)); /* dia 0 = último do mês anterior */
                    break;
                case '30':
                    var antes = new Date(hoje);
                    antes.setDate(hoje.getDate() - 29);
                    de = iso(antes);
                    ate = iso(hoje);
                    break;
                default: /* tudo: campos vazios = sem limite */
                    break;
            }
            inicio.value = de;
            fim.value = ate;
            avisar('');
        });
    });

    [inicio, fim].forEach(function (campo) {
        campo.addEventListener('change', function () { avisar(''); });
    });

    /* ---------- 2. envio ---------- */
    document.querySelectorAll('.rel-form[data-filtro="PERIODO"]').forEach(function (form) {
        form.addEventListener('submit', function (e) {
            if (inicio.value && fim.value && inicio.value > fim.value) {
                e.preventDefault();
                avisar('A data "De" está depois da data "Até". Corrija o período e tente de novo.');
                inicio.focus();
                return;
            }
            form.querySelector('input[name="dataInicio"]').value = inicio.value;
            form.querySelector('input[name="dataFim"]').value = fim.value;
        });
    });
})();
