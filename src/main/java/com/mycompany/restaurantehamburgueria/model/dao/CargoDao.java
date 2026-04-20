package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Cargo;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class CargoDao extends GenericoDAO<Cargo> {

    private static class CargoRowMapper implements RowMapper<Cargo> {
        @Override
        public Cargo mapRow(ResultSet rs) throws SQLException {
            Cargo obj = new Cargo();
            obj.setCodCargo(rs.getInt("codCargo"));
            obj.setNomeCargo(rs.getString("nomeCargo"));
            System.out.println("Mapeando: " + obj);
            return obj;
        }
    }

    public void salvar(Cargo obj) {
        String sql = "INSERT INTO cargo(nomeCargo) VALUES(?)";
        save(sql, obj.getNomeCargo());
    }

    public void alterar(Cargo obj) {
        String sql = "UPDATE cargo SET nomeCargo=? WHERE codCargo=?";
        save(sql, obj.getNomeCargo(), obj.getCodCargo());
    }

    public void excluir(Cargo obj) {
        String sql = "DELETE FROM cargo WHERE codCargo=?";
        save(sql, obj.getCodCargo());
    }

    public List<Cargo> buscarTodos() {
        return buscarTodos("SELECT * FROM cargo", new CargoRowMapper());
    }

    public Cargo buscarPorId(int id) {
        return buscarPorId("SELECT * FROM cargo WHERE codCargo=?", new CargoRowMapper(), id);
    }
}
