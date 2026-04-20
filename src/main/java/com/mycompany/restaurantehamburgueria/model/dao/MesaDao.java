package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Mesa;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class MesaDao extends GenericoDAO<Mesa> {

    private static class MesaRowMapper implements RowMapper<Mesa> {
        @Override
        public Mesa mapRow(ResultSet rs) throws SQLException {
            Mesa obj = new Mesa();
            obj.setCodMesa(rs.getInt("codMesa"));
            obj.setNumeroMesa(rs.getInt("numeroMesa"));
            obj.setLocalMesa(rs.getString("localMesa"));
            System.out.println("Mapeando: " + obj);
            return obj;
        }
    }

    public void salvar(Mesa obj) {
        String sql = "INSERT INTO mesa(numeroMesa, localMesa) VALUES(?,?)";
        save(sql, obj.getNumeroMesa(), obj.getLocalMesa());
    }

    public void alterar(Mesa obj) {
        String sql = "UPDATE mesa SET numeroMesa=?, localMesa=? WHERE codMesa=?";
        save(sql, obj.getNumeroMesa(), obj.getLocalMesa(), obj.getCodMesa());
    }

    public void excluir(Mesa obj) {
        String sql = "DELETE FROM mesa WHERE codMesa=?";
        save(sql, obj.getCodMesa());
    }

    public List<Mesa> buscarTodos() {
        return buscarTodos("SELECT * FROM mesa", new MesaRowMapper());
    }

    public Mesa buscarPorId(int id) {
        return buscarPorId("SELECT * FROM mesa WHERE codMesa=?", new MesaRowMapper(), id);
    }
}
