package com.mycompany.restaurantehamburgueria.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class CardapioIngredienteDao {

    private final ConnectionFactory cf = ConnectionFactory.getInstance();

    /**
     * Retorna um mapa de codCardapio → lista de nomes dos ingredientes.
     * Usado para exibir ingredientes no cardápio (tela cliente e admin).
     */
    public Map<Integer, List<String>> buscarIngredientesPorTodosCardapios() {
        Map<Integer, List<String>> map = new LinkedHashMap<>();
        String sql = "SELECT cpi.cardapio_codCardapio, i.nomeIngredientes " +
                     "FROM cardapio_por_ingrediente cpi " +
                     "JOIN ingrediente i ON i.codIngrediente = cpi.ingrediente_codIngrediente " +
                     "ORDER BY cpi.cardapio_codCardapio, i.nomeIngredientes";
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int cod = rs.getInt("cardapio_codCardapio");
                String nome = rs.getString("nomeIngredientes");
                map.computeIfAbsent(cod, k -> new ArrayList<>()).add(nome);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    /** Retorna a lista de ingredientes de um item específico do cardápio. */
    public List<String> buscarIngredientesPorCardapio(int codCardapio) {
        List<String> lista = new ArrayList<>();
        String sql = "SELECT i.nomeIngredientes " +
                     "FROM cardapio_por_ingrediente cpi " +
                     "JOIN ingrediente i ON i.codIngrediente = cpi.ingrediente_codIngrediente " +
                     "WHERE cpi.cardapio_codCardapio = ? " +
                     "ORDER BY i.nomeIngredientes";
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, codCardapio);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(rs.getString("nomeIngredientes"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
