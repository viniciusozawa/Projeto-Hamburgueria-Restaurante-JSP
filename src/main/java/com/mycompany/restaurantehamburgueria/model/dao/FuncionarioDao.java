package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Funcionario;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class FuncionarioDao extends GenericoDAO<Funcionario> {

    private static class FuncionarioRowMapper implements RowMapper<Funcionario> {
        private final CargoDao cargoDao = new CargoDao();
        private final TurnosDao turnosDao = new TurnosDao();

        @Override
        public Funcionario mapRow(ResultSet rs) throws SQLException {
            Funcionario obj = new Funcionario();
            obj.setCodFuncionario(rs.getInt("codFuncionario"));
            obj.setNomeFuncionario(rs.getString("nomeFuncionario"));
            if (rs.getDate("dataNascimento") != null) {
                obj.setDataNascimento(rs.getDate("dataNascimento").toLocalDate());
            }
            obj.setSenhaFuncionario(rs.getString("senhaFuncionario"));
            obj.setCpfFuncionario(rs.getString("cpfFuncionario"));
            obj.setSalarioFuncionario(rs.getDouble("salarioFuncionario"));
            obj.setTurnosFuncionario(turnosDao.buscarPorId(rs.getInt("turnos_codTurnos")));
            obj.setCargoFuncionario(cargoDao.buscarPorId(rs.getInt("cargo_codCargo")));
            System.out.println("Mapeando: " + obj);
            return obj;
        }
    }

    public void salvar(Funcionario obj) {
        String sql = "INSERT INTO funcionario(nomeFuncionario, dataNascimento, senhaFuncionario, cpfFuncionario, salarioFuncionario, turnos_codTurnos, cargo_codCargo) VALUES(?,?,?,?,?,?,?)";
        save(sql,
            obj.getNomeFuncionario(),
            obj.getDataNascimento(),
            obj.getSenhaFuncionario(),
            obj.getCpfFuncionario(),
            obj.getSalarioFuncionario(),
            obj.getTurnosFuncionario().getCodTurnos(),
            obj.getCargoFuncionario().getCodCargo()
        );
    }

    public void alterar(Funcionario obj) {
        String sql = "UPDATE funcionario SET nomeFuncionario=?, dataNascimento=?, senhaFuncionario=?, cpfFuncionario=?, salarioFuncionario=?, turnos_codTurnos=?, cargo_codCargo=? WHERE codFuncionario=?";
        save(sql,
            obj.getNomeFuncionario(),
            obj.getDataNascimento(),
            obj.getSenhaFuncionario(),
            obj.getCpfFuncionario(),
            obj.getSalarioFuncionario(),
            obj.getTurnosFuncionario().getCodTurnos(),
            obj.getCargoFuncionario().getCodCargo(),
            obj.getCodFuncionario()
        );
    }

    public void excluir(Funcionario obj) {
        String sql = "DELETE FROM funcionario WHERE codFuncionario=?";
        save(sql, obj.getCodFuncionario());
    }

    public List<Funcionario> buscarTodos() {
        return buscarTodos("SELECT * FROM funcionario", new FuncionarioRowMapper());
    }

    public Funcionario buscarPorId(int id) {
        return buscarPorId("SELECT * FROM funcionario WHERE codFuncionario=?", new FuncionarioRowMapper(), id);
    }
}
