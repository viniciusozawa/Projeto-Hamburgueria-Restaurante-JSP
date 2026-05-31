package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Cardapio;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class CardapioDao extends GenericoDAO<Cardapio> {

    private static class CardapioRowMapper implements RowMapper<Cardapio> {
        @Override
        public Cardapio mapRow(ResultSet rs) throws SQLException {
            Cardapio obj = new Cardapio();
            obj.setCodCardapio(rs.getInt("codCardapio"));
            obj.setNomeComida(rs.getString("nomeComida"));
            obj.setValorComida(rs.getBigDecimal("valorComida"));
            obj.setDescricaoComida(rs.getString("descricaoComida"));
            obj.setCategoria_codCategoria(rs.getInt("categoria_codCategoria"));
            try { obj.setNomeCategoria(rs.getString("nomeCategoria")); } catch (SQLException ignored) {}
            return obj;
        }
    }

    public void salvar(Cardapio obj) {
        String sql = "INSERT INTO cardapio(nomeComida, valorComida, descricaoComida, categoria_codCategoria) VALUES(?,?,?,?)";
        save(sql, obj.getNomeComida(), obj.getValorComida(), obj.getDescricaoComida(), obj.getCategoria_codCategoria());
    }

    public void alterar(Cardapio obj) {
        String sql = "UPDATE cardapio SET nomeComida=?, valorComida=?, descricaoComida=?, categoria_codCategoria=? WHERE codCardapio=?";
        save(sql, obj.getNomeComida(), obj.getValorComida(), obj.getDescricaoComida(), obj.getCategoria_codCategoria(), obj.getCodCardapio());
    }

    public void excluir(Cardapio obj) {
        String sql = "DELETE FROM cardapio WHERE codCardapio=?";
        save(sql, obj.getCodCardapio());
    }

    public List<Cardapio> buscarTodos() {
        String sql = "SELECT c.*, cat.nomeCategoria FROM cardapio c LEFT JOIN categoria cat ON cat.codCategoria = c.categoria_codCategoria ORDER BY c.nomeComida";
        return buscarTodos(sql, new CardapioRowMapper());
    }

    public Cardapio buscarPorId(int id) {
        String sql = "SELECT c.*, cat.nomeCategoria FROM cardapio c LEFT JOIN categoria cat ON cat.codCategoria = c.categoria_codCategoria WHERE c.codCardapio=?";
        return buscarPorId(sql, new CardapioRowMapper(), id);
    }
}
