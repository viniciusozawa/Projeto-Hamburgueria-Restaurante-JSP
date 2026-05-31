package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Funcionario;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class FuncionarioDao extends GenericoDAO<Funcionario> {

    private static class FuncionarioRowMapper implements RowMapper<Funcionario> {
        @Override
        public Funcionario mapRow(ResultSet rs) throws SQLException {
            Funcionario obj = new Funcionario();
            obj.setCodFuncionario(rs.getInt("codFuncionario"));
            obj.setNomeFuncionario(rs.getString("nomeFuncionario"));
            Date d = rs.getDate("dataNascimento");
            if (d != null) obj.setDataNascimento(d.toLocalDate());
            obj.setSenhaFuncionario(rs.getString("senhaFuncionario"));
            obj.setCpfFuncionario(rs.getString("cpfFuncionario"));
            obj.setSalarioFuncionario(rs.getBigDecimal("salarioFuncionario"));
            obj.setTurnos_codTurnos(rs.getInt("turnos_codTurnos"));
            obj.setCargo_codCargo(rs.getInt("cargo_codCargo"));
            obj.setDisponivel(rs.getInt("disponivel"));
            try { obj.setNomeCargo(rs.getString("nomeCargo")); } catch (SQLException ignored) {}
            try { obj.setHorarioTurno(rs.getString("horarioTurno")); } catch (SQLException ignored) {}
            return obj;
        }
    }

    public void salvar(Funcionario obj) {
        String sql = "INSERT INTO funcionario(nomeFuncionario, dataNascimento, senhaFuncionario, cpfFuncionario, salarioFuncionario, turnos_codTurnos, cargo_codCargo, disponivel) VALUES(?,?,?,?,?,?,?,1)";
        save(sql,
            obj.getNomeFuncionario(),
            obj.getDataNascimento() != null ? Date.valueOf(obj.getDataNascimento()) : null,
            obj.getSenhaFuncionario(),
            obj.getCpfFuncionario(),
            obj.getSalarioFuncionario(),
            obj.getTurnos_codTurnos(),
            obj.getCargo_codCargo()
        );
    }

    public void alterar(Funcionario obj) {
        String sql = "UPDATE funcionario SET nomeFuncionario=?, dataNascimento=?, senhaFuncionario=?, cpfFuncionario=?, salarioFuncionario=?, turnos_codTurnos=?, cargo_codCargo=? WHERE codFuncionario=?";
        save(sql,
            obj.getNomeFuncionario(),
            obj.getDataNascimento() != null ? Date.valueOf(obj.getDataNascimento()) : null,
            obj.getSenhaFuncionario(),
            obj.getCpfFuncionario(),
            obj.getSalarioFuncionario(),
            obj.getTurnos_codTurnos(),
            obj.getCargo_codCargo(),
            obj.getCodFuncionario()
        );
    }

    public void excluir(Funcionario obj) {
        String sql = "DELETE FROM funcionario WHERE codFuncionario=?";
        save(sql, obj.getCodFuncionario());
    }

    public List<Funcionario> buscarTodos() {
        String sql = "SELECT f.*, c.nomeCargo, CONCAT(t.horarioInicio,' - ',t.horarioFinal) AS horarioTurno " +
                     "FROM funcionario f " +
                     "LEFT JOIN cargo c ON c.codCargo = f.cargo_codCargo " +
                     "LEFT JOIN turnos t ON t.codTurnos = f.turnos_codTurnos";
        return buscarTodos(sql, new FuncionarioRowMapper());
    }

    public Funcionario buscarPorId(int id) {
        String sql = "SELECT f.*, c.nomeCargo, CONCAT(t.horarioInicio,' - ',t.horarioFinal) AS horarioTurno " +
                     "FROM funcionario f " +
                     "LEFT JOIN cargo c ON c.codCargo = f.cargo_codCargo " +
                     "LEFT JOIN turnos t ON t.codTurnos = f.turnos_codTurnos " +
                     "WHERE f.codFuncionario=?";
        return buscarPorId(sql, new FuncionarioRowMapper(), id);
    }
}
