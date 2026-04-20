package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Cliente;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class ClienteDao extends GenericoDAO<Cliente> {

    private static class ClienteRowMapper implements RowMapper<Cliente> {
        @Override
        public Cliente mapRow(ResultSet rs) throws SQLException {
            Cliente obj = new Cliente();
            obj.setCodCliente(rs.getInt("codCliente"));
            obj.setNomeCliente(rs.getString("nomeCliente"));
            obj.setCpfCliente(rs.getString("cpfCliente"));
            obj.setSenhaCliente(rs.getString("senhaCliente"));
            obj.setTelefone(rs.getString("telefone"));
            Timestamp ts = rs.getTimestamp("dataCadastro");
            if (ts != null) {
                obj.setDataCadastro(ts.toLocalDateTime());
            }
            System.out.println("Mapeando: " + obj);
            return obj;
        }
    }

    public void salvar(Cliente obj) {
        String sql = "INSERT INTO cliente(nomeCliente, cpfCliente, senhaCliente, telefone) VALUES(?,?,?,?)";
        save(sql, obj.getNomeCliente(), obj.getCpfCliente(), obj.getSenhaCliente(), obj.getTelefone());
    }

    public void alterar(Cliente obj) {
        String sql = "UPDATE cliente SET nomeCliente=?, cpfCliente=?, senhaCliente=?, telefone=? WHERE codCliente=?";
        save(sql, obj.getNomeCliente(), obj.getCpfCliente(), obj.getSenhaCliente(), obj.getTelefone(), obj.getCodCliente());
    }

    public void excluir(Cliente obj) {
        String sql = "DELETE FROM cliente WHERE codCliente=?";
        save(sql, obj.getCodCliente());
    }

    public List<Cliente> buscarTodos() {
        return buscarTodos("SELECT * FROM cliente", new ClienteRowMapper());
    }

    public Cliente buscarPorId(int id) {
        return buscarPorId("SELECT * FROM cliente WHERE codCliente=?", new ClienteRowMapper(), id);
    }
}
