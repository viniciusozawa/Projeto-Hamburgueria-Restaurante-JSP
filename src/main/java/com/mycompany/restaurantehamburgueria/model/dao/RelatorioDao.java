package com.mycompany.restaurantehamburgueria.model.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Consultas dos relatórios em Excel (abordagem 3, Apache POI).
 *
 * Os relatórios do Jasper têm o SQL dentro do .jrxml; os do POI precisam
 * buscar os dados em Java, e é aqui que isso fica. Cada método devolve uma
 * lista de linhas, e cada linha é um mapa "nome da coluna -> valor".
 * Para um relatório (que só lê e mostra), isso basta: não vale criar uma
 * entidade nova para cada resultado.
 *
 * As regras de dinheiro são as mesmas do painel e dos relatórios Jasper:
 * total do pedido = soma de quantidade x preço; recebido = soma dos
 * pagamentos daquele pedido (sempre por subconsulta, para não contar o
 * pagamento uma vez por item); pedido em aberto = tem itens e recebido < total.
 *
 * Período: datas nulas = sem limite daquele lado.
 */
public class RelatorioDao {

    /** Filtro de período sobre uma coluna de data, com os 4 "?" que ele usa. */
    private static String periodo(String coluna) {
        return " (? IS NULL OR DATE(" + coluna + ") >= ?) AND (? IS NULL OR DATE(" + coluna + ") <= ?) ";
    }

    /** Total e itens de CADA pedido, com o recebido. Base de vários relatórios. */
    private static final String PEDIDOS_COM_TOTAL =
        "SELECT p.codpedido, p.datahoraPedido, p.cliente_codCliente, p.mesa_codMesa, p.funcionario_codFuncionario, "
      + "       COALESCE(SUM(pc.quantidade), 0)                 AS itens, "
      + "       COALESCE(SUM(pc.quantidade * c.valorComida), 0) AS total, "
      + "       (SELECT COALESCE(SUM(pg.valorPago), 0) FROM pagamento pg "
      + "         WHERE pg.pedido_codpedido = p.codpedido)      AS recebido "
      + "  FROM pedido p "
      + "  LEFT JOIN pedido_por_cardapio pc ON pc.pedido_idpedido = p.codpedido "
      + "  LEFT JOIN cardapio c             ON c.codCardapio = pc.cardapio_codCardapio "
      + " WHERE " + periodo("p.datahoraPedido")
      + " GROUP BY p.codpedido, p.datahoraPedido, p.cliente_codCliente, p.mesa_codMesa, p.funcionario_codFuncionario ";

    /** 07 - Contas a receber: pedidos com itens e ainda não pagos por completo, do mais antigo ao mais novo. */
    public List<Map<String, Object>> contasAReceber(LocalDate inicio, LocalDate fim) throws SQLException {
        String sql =
            "SELECT t.codpedido, t.datahoraPedido, cl.nomeCliente, cl.telefone, m.numeroMesa, "
          + "       f.nomeFuncionario, t.itens, t.total, t.recebido "
          + "  FROM (" + PEDIDOS_COM_TOTAL + ") t "
          + "  LEFT JOIN cliente cl    ON cl.codCliente = t.cliente_codCliente "
          + "  LEFT JOIN mesa m        ON m.codMesa = t.mesa_codMesa "
          + "  LEFT JOIN funcionario f ON f.codFuncionario = t.funcionario_codFuncionario "
          + " WHERE t.itens > 0 AND t.recebido < t.total "
          + " ORDER BY t.datahoraPedido, t.codpedido";
        return consultar(sql, datas(inicio, fim));
    }

    /**
     * 08 - Recebimentos agrupados pela forma de pagamento. A forma é texto
     * livre no banco ("pix", "Dinheiro", "dinheiro", vazio): agrupa sem
     * diferenciar maiúscula nem espaço, e o vazio vira "Não informada".
     */
    public List<Map<String, Object>> recebimentosPorForma(LocalDate inicio, LocalDate fim) throws SQLException {
        String sql =
            "SELECT COALESCE(NULLIF(LOWER(TRIM(pg.formaPagamento)), ''), 'não informada') AS forma, "
          + "       COUNT(*)                     AS pagamentos, "
          + "       COALESCE(SUM(pg.valorPago), 0) AS valor "
          + "  FROM pagamento pg "
          + " WHERE " + periodo("pg.dataPagamento")
          + " GROUP BY forma "
          + " ORDER BY valor DESC";
        return consultar(sql, datas(inicio, fim));
    }

    /** 08 - Cada pagamento do período, para a aba "Lançamentos". */
    public List<Map<String, Object>> pagamentos(LocalDate inicio, LocalDate fim) throws SQLException {
        String sql =
            "SELECT pg.dataPagamento, pg.pedido_codpedido, cl.nomeCliente, "
          + "       COALESCE(NULLIF(LOWER(TRIM(pg.formaPagamento)), ''), 'não informada') AS forma, "
          + "       pg.valorPago "
          + "  FROM pagamento pg "
          + "  LEFT JOIN cliente cl ON cl.codCliente = pg.cliente_codCliente "
          + " WHERE " + periodo("pg.dataPagamento")
          + " ORDER BY pg.dataPagamento, pg.codPagamento";
        return consultar(sql, datas(inicio, fim));
    }

    /** 09 - Clientes com pedido no período, de quem gastou mais para quem gastou menos. */
    public List<Map<String, Object>> melhoresClientes(LocalDate inicio, LocalDate fim) throws SQLException {
        String sql =
            "SELECT cl.nomeCliente, cl.telefone, "
          + "       COUNT(*)                  AS pedidos, "
          + "       SUM(t.itens)              AS itens, "
          + "       SUM(t.total)              AS gasto, "
          + "       MIN(t.datahoraPedido)     AS primeiro, "
          + "       MAX(t.datahoraPedido)     AS ultimo "
          + "  FROM (" + PEDIDOS_COM_TOTAL + ") t "
          + "  JOIN cliente cl ON cl.codCliente = t.cliente_codCliente "
          + " GROUP BY cl.codCliente, cl.nomeCliente, cl.telefone "
          + " ORDER BY gasto DESC, pedidos DESC, cl.nomeCliente";
        return consultar(sql, datas(inicio, fim));
    }

    /** 10 - Todos os funcionários, com cargo, perfil, turno e salário (situação de agora). */
    public List<Map<String, Object>> folha() throws SQLException {
        String sql =
            "SELECT f.nomeFuncionario, TRIM(cg.nomeCargo) AS cargo, cg.perfil, "
          + "       CONCAT(COALESCE(TIME_FORMAT(t.horarioInicio, '%H:%i'), '?'), ' às ', "
          + "              COALESCE(TIME_FORMAT(t.horarioFinal,  '%H:%i'), '?')) AS turno, "
          + "       f.salarioFuncionario "
          + "  FROM funcionario f "
          + "  JOIN cargo cg     ON cg.codCargo = f.cargo_codCargo "
          + "  LEFT JOIN turnos t ON t.codTurnos = f.turnos_codTurnos "
          + " ORDER BY cargo, f.nomeFuncionario";
        return consultar(sql);
    }

    /** 11 - Todas as mesas, com o movimento do período (mesa parada também aparece). */
    public List<Map<String, Object>> usoDasMesas(LocalDate inicio, LocalDate fim) throws SQLException {
        String sql =
            "SELECT m.numeroMesa, m.localMesa, "
          + "       COUNT(t.codpedido)        AS pedidos, "
          + "       COALESCE(SUM(t.itens), 0) AS itens, "
          + "       COALESCE(SUM(t.total), 0) AS faturamento, "
          + "       MAX(t.datahoraPedido)     AS ultimo "
          + "  FROM mesa m "
          + "  LEFT JOIN (" + PEDIDOS_COM_TOTAL + ") t ON t.mesa_codMesa = m.codMesa "
          + " GROUP BY m.codMesa, m.numeroMesa, m.localMesa "
          + " ORDER BY pedidos DESC, faturamento DESC, m.numeroMesa";
        return consultar(sql, datas(inicio, fim));
    }

    // ------------------------------------------------------------------

    /** Os 4 parâmetros do filtro de período: início, início, fim, fim. */
    private static Object[] datas(LocalDate inicio, LocalDate fim) {
        Date i = inicio == null ? null : Date.valueOf(inicio);
        Date f = fim == null ? null : Date.valueOf(fim);
        return new Object[]{i, i, f, f};
    }

    private List<Map<String, Object>> consultar(String sql, Object... parametros) throws SQLException {
        try (Connection con = ConnectionFactory.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < parametros.length; i++) {
                if (parametros[i] == null) {
                    ps.setNull(i + 1, java.sql.Types.DATE);
                } else {
                    ps.setObject(i + 1, parametros[i]);
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData meta = rs.getMetaData();
                List<Map<String, Object>> linhas = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> linha = new LinkedHashMap<>();
                    for (int c = 1; c <= meta.getColumnCount(); c++) {
                        linha.put(meta.getColumnLabel(c), rs.getObject(c));
                    }
                    linhas.add(linha);
                }
                return linhas;
            }
        }
    }
}
