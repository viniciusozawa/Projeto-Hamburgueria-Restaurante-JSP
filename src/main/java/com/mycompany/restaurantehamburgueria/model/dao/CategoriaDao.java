package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Categoria;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class CategoriaDao extends GenericoDAO<Categoria> {

    private static class CategoriaRowMapper implements RowMapper<Categoria> {
        @Override
        public Categoria mapRow(ResultSet rs) throws SQLException {
            Categoria obj = new Categoria();
            obj.setCodCategoria(rs.getInt("codCategoria"));
            obj.setNomeCategoria(rs.getString("nomeCategoria"));
            System.out.println("Mapeando: " + obj);
            return obj;
        }
    }

    public void salvar(Categoria obj) {
        String sql = "INSERT INTO categoria(nomeCategoria) VALUES(?)";
        save(sql, obj.getNomeCategoria());
    }

    public void alterar(Categoria obj) {
        String sql = "UPDATE categoria SET nomeCategoria=? WHERE codCategoria=?";
        save(sql, obj.getNomeCategoria(), obj.getCodCategoria());
    }

    public void excluir(Categoria obj) {
        String sql = "DELETE FROM categoria WHERE codCategoria=?";
        save(sql, obj.getCodCategoria());
    }

    public List<Categoria> buscarTodos() {
        return buscarTodos("SELECT * FROM categoria", new CategoriaRowMapper());
    }

    public Categoria buscarPorId(int id) {
        return buscarPorId("SELECT * FROM categoria WHERE codCategoria=?", new CategoriaRowMapper(), id);
    }
}
