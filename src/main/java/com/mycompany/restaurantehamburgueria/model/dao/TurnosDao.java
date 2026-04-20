package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Turnos;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.List;

public class TurnosDao extends GenericoDAO<Turnos> {

    private static class TurnosRowMapper implements RowMapper<Turnos> {
        @Override
        public Turnos mapRow(ResultSet rs) throws SQLException {
            Turnos obj = new Turnos();
            obj.setCodTurnos(rs.getInt("codTurnos"));
            Time inicio = rs.getTime("horarioInicio");
            Time final_ = rs.getTime("horarioFinal");
            if (inicio != null) obj.setHorarioInicio(inicio.toLocalTime());
            if (final_ != null) obj.setHorarioFinal(final_.toLocalTime());
            System.out.println("Mapeando: " + obj);
            return obj;
        }
    }

    public void salvar(Turnos obj) {
        String sql = "INSERT INTO turnos(horarioInicio, horarioFinal) VALUES(?,?)";
        save(sql,
            obj.getHorarioInicio() != null ? Time.valueOf(obj.getHorarioInicio()) : null,
            obj.getHorarioFinal() != null ? Time.valueOf(obj.getHorarioFinal()) : null
        );
    }

    public void alterar(Turnos obj) {
        String sql = "UPDATE turnos SET horarioInicio=?, horarioFinal=? WHERE codTurnos=?";
        save(sql,
            obj.getHorarioInicio() != null ? Time.valueOf(obj.getHorarioInicio()) : null,
            obj.getHorarioFinal() != null ? Time.valueOf(obj.getHorarioFinal()) : null,
            obj.getCodTurnos()
        );
    }

    public void excluir(Turnos obj) {
        String sql = "DELETE FROM turnos WHERE codTurnos=?";
        save(sql, obj.getCodTurnos());
    }

    public List<Turnos> buscarTodos() {
        return buscarTodos("SELECT * FROM turnos", new TurnosRowMapper());
    }

    public Turnos buscarPorId(int id) {
        return buscarPorId("SELECT * FROM turnos WHERE codTurnos=?", new TurnosRowMapper(), id);
    }
}
