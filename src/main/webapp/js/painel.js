/* Interações do painel: tickets de aviso, confirmação de exclusão,
   "Salvando…" e busca nas tabelas.

   Carregado pelo menu.jsp com defer, então roda depois do bootstrap.bundle
   que cada tela traz no fim do <body>. Tudo aqui é melhoria: sem JavaScript
   as telas continuam funcionando do jeito antigo (mensagem fixa no topo e
   exclusão em duas etapas). */
(function () {
    'use strict';

    var temBootstrap = typeof window.bootstrap !== 'undefined';

    /* Em modo de edição ou de exclusão a mensagem é instrução para o
       formulário ("Edite os dados e clique em Salvar") e fica onde está. */
    function emModoFormulario() {
        var opcao = document.querySelector('#formCadastro input[name="opcao"]');
        return !!opcao && /^confirmar/.test(opcao.value);
    }

    /* ------------------------------------------------------------------
       1. TICKET: o aviso de "salvo" sai da impressora, como a comanda.
       ------------------------------------------------------------------ */
    var pilha = null;

    function hora() {
        var d = new Date();
        return ('0' + d.getHours()).slice(-2) + ':' + ('0' + d.getMinutes()).slice(-2);
    }

    function ticket(texto, tipo) {
        if (!temBootstrap) return false;

        if (!pilha) {
            pilha = document.createElement('div');
            pilha.className = 'ticket-pilha';
            /* polite: o leitor de tela anuncia sem interromper */
            pilha.setAttribute('aria-live', 'polite');
            /* A posição vai também aqui, e não só no CSS: com a folha de
               estilo antiga no cache do navegador o ticket caía no pé da
               página, depois do rodapé. */
            pilha.style.position = 'fixed';
            pilha.style.top = window.innerWidth <= 576 ? '70px' : '78px';
            pilha.style.right = window.innerWidth <= 576 ? '16px' : '24px';
            pilha.style.zIndex = '1090';
            document.body.appendChild(pilha);
        }

        var boca = document.createElement('div');
        boca.className = 'ticket-boca';

        var el = document.createElement('div');
        el.className = 'toast ticket' + (tipo === 'alerta' ? ' ticket-alerta' : '');
        el.setAttribute('role', 'status');
        el.innerHTML =
            '<p class="ticket-meta"><span>Big Tites</span><span></span></p>' +
            '<p class="ticket-texto"><i aria-hidden="true"></i><span></span></p>' +
            '<button type="button" class="ticket-fechar" data-bs-dismiss="toast" aria-label="Fechar aviso">' +
            '<i class="fa-solid fa-xmark" aria-hidden="true"></i></button>';
        el.querySelector('.ticket-meta span:last-child').textContent = hora();
        el.querySelector('.ticket-texto i').className = tipo === 'alerta'
            ? 'fa-solid fa-triangle-exclamation' : 'fa-solid fa-check';
        el.querySelector('.ticket-texto span').textContent = texto;

        boca.appendChild(el);
        pilha.appendChild(boca);

        /* erro fica até a pessoa fechar: precisa de tempo para ler o motivo */
        var t = new bootstrap.Toast(el, { delay: 5000, autohide: tipo !== 'alerta', animation: false });
        el.addEventListener('hidden.bs.toast', function () { boca.remove(); });
        t.show();
        return true;
    }

    /* As mensagens que as telas já imprimem viram ticket. O tipo vem do
       controlador (menu.jsp imprime #flashTipo); sem ele, é um "feito". */
    var marcaTipo = document.getElementById('flashTipo');
    var tipoDoAviso = marcaTipo ? marcaTipo.getAttribute('data-tipo') : 'ok';

    if (!emModoFormulario()) {
        document.querySelectorAll('.mensagem, [data-ticket]').forEach(function (msg) {
            var texto = msg.textContent.trim();
            if (!texto) return;
            var tipo = tipoDoAviso;
            if (ticket(texto, tipo)) msg.hidden = true;
        });
    }

    /* ------------------------------------------------------------------
       2. CONFIRMAR antes de apagar, sem a tela intermediária.
       ------------------------------------------------------------------ */
    var modal = null, modalEl = null, formPendente = null;

    function montarModal() {
        modalEl = document.createElement('div');
        modalEl.className = 'modal fade modal-comanda';
        modalEl.id = 'modalExcluir';
        modalEl.tabIndex = -1;
        modalEl.setAttribute('aria-labelledby', 'modalExcluirTitulo');
        modalEl.setAttribute('aria-hidden', 'true');
        modalEl.innerHTML =
            '<div class="modal-dialog modal-dialog-centered">' +
              '<div class="modal-content">' +
                '<div class="modal-body">' +
                  '<h2 class="modal-titulo" id="modalExcluirTitulo"></h2>' +
                  '<dl class="modal-alvo"></dl>' +
                  '<p class="modal-cascata"></p>' +
                  '<p class="modal-aviso"><i class="fa-solid fa-triangle-exclamation" aria-hidden="true"></i> ' +
                  'Isso não pode ser desfeito.</p>' +
                '</div>' +
                '<div class="modal-footer">' +
                  '<button type="button" class="btn-cancelar" data-bs-dismiss="modal">Cancelar</button>' +
                  '<button type="button" class="btn-excluir btn-confirmar">' +
                    '<i class="fa-solid fa-trash" aria-hidden="true"></i> <span></span></button>' +
                '</div>' +
              '</div>' +
            '</div>';
        document.body.appendChild(modalEl);
        modal = new bootstrap.Modal(modalEl);

        modalEl.querySelector('.btn-confirmar').addEventListener('click', function () {
            if (!formPendente) return;
            var f = formPendente;
            formPendente = null;
            var opcao = f.querySelector('input[name="opcao"]');
            /* pula a tela "Confirme a exclusão clicando em Salvar" */
            if (opcao.value === 'enviarExcluir') opcao.value = 'confirmarExcluir';
            this.disabled = true;
            f.submit();
        });
    }

    /* O que o banco apaga junto (ON DELETE CASCADE, conferido em
       information_schema em 2026-10-24). Avisar antes é o mínimo: excluir
       uma mesa leva embora o histórico de pedidos dela. */
    var CASCATA = {
        'mesa':        'Os pedidos feitos nesta mesa também serão apagados.',
        'funcionário': 'Os pedidos lançados por este funcionário também serão apagados.',
        'cardápio':    'O prato também sai dos pedidos em que já foi vendido.',
        'pedido':      'Os itens deste pedido também serão apagados.',
        'cliente':     'Os pedidos dele continuam, mas sem cliente.'
    };

    /* "Cadastro de Mesa" -> "mesa", para o título dizer o que se apaga. */
    function entidade() {
        var h = document.querySelector('.card-header h4');
        var nome = h ? h.textContent.trim().replace(/^Cadastro de\s+/i, '') : '';
        return nome ? nome.charAt(0).toLowerCase() + nome.slice(1) : '';
    }

    /* As colunas da linha, com o nome do cabeçalho: "Número 3", "Local Varanda". */
    function resumoDaLinha(form) {
        var linha = form.closest('tr');
        var tabela = form.closest('table');
        var pares = [];
        if (!linha || !tabela) return pares;

        var cabecas = tabela.querySelectorAll('thead th');
        linha.querySelectorAll('td').forEach(function (td, i) {
            var rotulo = cabecas[i] ? cabecas[i].textContent.trim() : '';
            var valor = td.textContent.replace(/\s+/g, ' ').trim();
            if (!valor || td.querySelector('form, button') || rotulo === '#' || /^aç(ão|ões)$/i.test(rotulo)) return;
            pares.push([rotulo, valor]);
        });
        return pares.slice(0, 4);
    }

    function confirmar(form, acao) {
        if (!modal) montarModal();

        var ent = entidade();
        var titulo, botao;
        if (acao === 'removerItem') {
            titulo = 'Tirar este item do pedido?';
            botao = 'Tirar do pedido';
        } else {
            titulo = ent ? 'Excluir do cadastro de ' + ent + '?' : 'Excluir este registro?';
            botao = 'Excluir';
        }
        modalEl.querySelector('.modal-titulo').textContent = titulo;
        var cascata = acao === 'removerItem' ? '' : (CASCATA[ent] || '');
        modalEl.querySelector('.modal-cascata').textContent = cascata;
        modalEl.querySelector('.modal-cascata').hidden = !cascata;
        modalEl.querySelector('.btn-confirmar span').textContent = botao;
        modalEl.querySelector('.btn-confirmar').disabled = false;

        var alvo = modalEl.querySelector('.modal-alvo');
        alvo.innerHTML = '';
        resumoDaLinha(form).forEach(function (par) {
            var dt = document.createElement('dt'); dt.textContent = par[0];
            var dd = document.createElement('dd'); dd.textContent = par[1];
            alvo.appendChild(dt); alvo.appendChild(dd);
        });
        alvo.hidden = !alvo.children.length;

        formPendente = form;
        modal.show();
    }

    if (temBootstrap) {
        document.addEventListener('submit', function (e) {
            var form = e.target;
            var opcao = form.querySelector && form.querySelector('input[name="opcao"]');
            if (!opcao) return;
            if (opcao.value === 'enviarExcluir' || opcao.value === 'removerItem') {
                e.preventDefault();
                confirmar(form, opcao.value);
            }
        });
    }

    /* ------------------------------------------------------------------
       3. "SALVANDO…": trava o botão para não gravar duas vezes.
       ------------------------------------------------------------------ */
    document.addEventListener('submit', function (e) {
        if (e.defaultPrevented) return;
        var form = e.target;
        var botoes = [];
        if (form.id) {
            document.querySelectorAll('button[type="submit"][form="' + form.id + '"]')
                .forEach(function (b) { botoes.push(b); });
        }
        form.querySelectorAll('button[type="submit"]').forEach(function (b) { botoes.push(b); });

        botoes.forEach(function (b) {
            if (!/salvar|adicionar/i.test(b.textContent)) return;
            var rotulo = /adicionar/i.test(b.textContent) ? 'Adicionando…' : 'Salvando…';
            /* deixa o clique sair antes de desabilitar, senão alguns
               navegadores cancelam o envio */
            setTimeout(function () {
                b.disabled = true;
                b.setAttribute('aria-busy', 'true');
                b.innerHTML = '<span class="spinner-border spinner-border-sm" aria-hidden="true"></span> ' + rotulo;
            }, 0);
        });
    });

    /* ------------------------------------------------------------------
       4. PROCURAR NA LISTA: filtra as linhas enquanto a pessoa digita.
       ------------------------------------------------------------------ */
    var LINHAS_MINIMAS = 6; /* lista curta se lê de olho, não precisa de busca */

    document.querySelectorAll('.table-wrapper').forEach(function (embrulho, n) {
        var tabela = embrulho.querySelector('table');
        if (!tabela || !tabela.tBodies[0]) return;
        var linhas = Array.prototype.slice.call(tabela.tBodies[0].rows);
        if (linhas.length < LINHAS_MINIMAS) return;

        var id = 'procurar' + n;
        var caixa = document.createElement('div');
        caixa.className = 'procurar';
        caixa.innerHTML =
            '<label for="' + id + '" class="visually-hidden">Procurar na lista</label>' +
            '<i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i>' +
            '<input type="search" id="' + id + '" class="form-control" placeholder="Procurar na lista" autocomplete="off">' +
            '<span class="procurar-conta" aria-live="polite"></span>';
        embrulho.parentNode.insertBefore(caixa, embrulho);

        var vazio = document.createElement('tr');
        vazio.className = 'procurar-vazio';
        vazio.hidden = true;
        vazio.innerHTML = '<td colspan="' + (tabela.tHead ? tabela.tHead.rows[0].cells.length : 1) + '"></td>';
        tabela.tBodies[0].appendChild(vazio);

        var campo = caixa.querySelector('input');
        var conta = caixa.querySelector('.procurar-conta');

        function semAcento(s) {
            return s.normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase();
        }
        var textos = linhas.map(function (tr) { return semAcento(tr.textContent); });

        campo.addEventListener('input', function () {
            var busca = semAcento(campo.value.trim());
            var achadas = 0;
            linhas.forEach(function (tr, i) {
                var mostra = !busca || textos[i].indexOf(busca) !== -1;
                tr.hidden = !mostra;
                if (mostra) achadas++;
            });
            conta.textContent = busca ? achadas + ' de ' + linhas.length : '';
            vazio.hidden = achadas > 0;
            vazio.cells[0].textContent = 'Nada na lista com "' + campo.value.trim() + '".';
        });
    });
})();
