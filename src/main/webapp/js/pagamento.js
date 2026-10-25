/* Tela de pagamento, em dois passos: escolhe o cliente, depois a comanda
   dele. Escolhida a comanda, mostra o que foi comprado e preenche o valor
   que falta. Sem JavaScript o formulário continua funcionando: a lista de
   comandas vem inteira, com o nome do cliente em cada uma. */
(function () {
    'use strict';

    var pedido  = document.getElementById('campoPedido');
    var cliente = document.getElementById('campoCliente');
    var valor   = document.getElementById('campoValor');
    var caixa   = document.getElementById('conferirPedido');
    var ajuda   = document.getElementById('ajudaComanda');
    if (!pedido || !cliente || !caixa) return;

    var reais = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' });
    var comandas = Array.prototype.slice.call(pedido.options, 1); /* sem o "Escolha" */

    /* passo 1 -> 2: deixa na lista só as comandas do cliente escolhido */
    function filtrar() {
        var dono = cliente.value;
        var visiveis = comandas.filter(function (op) {
            var mostra = !dono || op.getAttribute('data-cliente') === dono;
            op.hidden = !mostra;
            op.disabled = !mostra; /* Safari ignora hidden em <option> */
            return mostra;
        });

        var escolhida = pedido.options[pedido.selectedIndex];
        if (escolhida && escolhida.disabled) pedido.value = '';
        /* uma comanda só: já escolhe */
        if (dono && visiveis.length === 1) pedido.value = visiveis[0].value;

        if (ajuda) {
            ajuda.hidden = !dono;
            ajuda.textContent = visiveis.length === 1
                ? 'Esta é a única comanda em aberto deste cliente.'
                : visiveis.length + ' comandas em aberto deste cliente.';
        }
    }

    function mostrar(preencher) {
        var op = pedido.options[pedido.selectedIndex];
        if (!op || !op.value) {
            caixa.hidden = true;
            /* trocou de cliente: o valor da comanda anterior não vale mais */
            if (preencher && valor) valor.value = '';
            return;
        }
        var total = parseFloat(op.getAttribute('data-total')) || 0;
        var falta = parseFloat(op.getAttribute('data-falta')) || 0;

        document.getElementById('conferirItens').textContent =
            op.getAttribute('data-itens') || 'Comanda sem itens.';
        document.getElementById('conferirTotal').textContent = reais.format(total);

        /* pagamento em partes: avisa quanto já entrou */
        var aviso = document.getElementById('conferirFalta');
        var parcial = falta > 0.004 && falta < total - 0.004;
        aviso.hidden = !parcial;
        if (parcial) aviso.textContent = 'Já pago: ' + reais.format(total - falta) + '. Falta ' + reais.format(falta) + '.';
        caixa.hidden = false;

        /* ao alterar um pagamento, o valor gravado fica como está */
        if (preencher && valor && falta > 0) valor.value = falta.toFixed(2);
    }

    /* comanda escolhida direto (ou vinda do botão "Receber"):
       o passo 1 acompanha e mostra de quem ela é */
    function acompanharDono() {
        var op = pedido.options[pedido.selectedIndex];
        if (op && op.value) cliente.value = op.getAttribute('data-cliente') || '';
    }

    cliente.addEventListener('change', function () {
        filtrar();
        mostrar(true);
    });
    pedido.addEventListener('change', function () {
        acompanharDono();
        filtrar();
        mostrar(true);
    });

    var editando = !!document.querySelector('#formCadastro input[name="opcao"][value^="confirmar"]');
    acompanharDono();
    filtrar();
    mostrar(!editando && !(valor && valor.value));
})();
