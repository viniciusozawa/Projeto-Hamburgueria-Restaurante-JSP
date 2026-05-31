package com.mycompany.restaurantehamburgueria.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

public class DashboardDao {

    private final ConnectionFactory cf = ConnectionFactory.getInstance();

    private int count(String sql) {
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Map<String, Integer> getContagens() {
        Map<String, Integer> map = new LinkedHashMap<>();
        map.put("cargos",        count("SELECT COUNT(*) FROM cargo"));
        map.put("categorias",    count("SELECT COUNT(*) FROM categoria"));
        map.put("clientes",      count("SELECT COUNT(*) FROM cliente"));
        map.put("fornecedores",  count("SELECT COUNT(*) FROM fornecedores"));
        map.put("mesas",         count("SELECT COUNT(*) FROM mesa"));
        map.put("turnos",        count("SELECT COUNT(*) FROM turnos"));
        map.put("funcionarios",  count("SELECT COUNT(*) FROM funcionario"));
        map.put("cardapios",     count("SELECT COUNT(*) FROM cardapio"));
        map.put("ingredientes",  count("SELECT COUNT(*) FROM ingrediente"));
        map.put("pedidos",       count("SELECT COUNT(*) FROM pedido"));
        map.put("pagamentos",    count("SELECT COUNT(*) FROM pagamento"));
        map.put("feedbacks",     count("SELECT COUNT(*) FROM feedback"));
        return map;
    }
}
