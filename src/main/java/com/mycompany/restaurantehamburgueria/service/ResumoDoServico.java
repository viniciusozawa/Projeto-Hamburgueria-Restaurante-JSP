package com.mycompany.restaurantehamburgueria.service;

import com.mycompany.restaurantehamburgueria.model.dao.PedidoDao;
import com.mycompany.restaurantehamburgueria.model.entity.Pedido;
import java.util.ArrayList;
import java.util.List;

/**
 * O que está acontecendo no serviço de hoje, para o topo do painel.
 *
 * É um bean usado direto pela JSP (<jsp:useBean> no painel.jsp) porque o
 * painel é aberto pela URL /painel.jsp em vários lugares — login, menu,
 * vitrine — e um controlador na frente obrigaria a mudar todos esses links.
 *
 * Consulta uma vez só: a lista fica guardada para o total e a contagem.
 */
public class ResumoDoServico {

    private List<Pedido> comandas;

    /** As de hoje ainda não pagas. A paga sai do trilho (deu baixa), mas continua salva. */
    public List<Pedido> getComandasDeHoje() {
        if (comandas == null) {
            comandas = new ArrayList<>();
            for (Pedido p : new PedidoDao().buscarDoDia()) {
                if (!p.isFinalizado()) {
                    comandas.add(p);
                }
            }
        }
        return comandas;
    }

    public double getTotalDeHoje() {
        double soma = 0;
        for (Pedido p : getComandasDeHoje()) {
            soma += p.getFalta(); // o que ainda falta receber das comandas abertas
        }
        return soma;
    }
}
