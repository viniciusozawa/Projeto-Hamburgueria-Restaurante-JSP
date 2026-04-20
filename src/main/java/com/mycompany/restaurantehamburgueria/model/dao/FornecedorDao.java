package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Fornecedor;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class FornecedorDao extends GenericoDAO<Fornecedor> {

    private static class FornecedorRowMapper implements RowMapper<Fornecedor> {
        @Override
        public Fornecedor mapRow(ResultSet rs) throws SQLException {
            Fornecedor obj = new Fornecedor();
            obj.setCodFornecedor(rs.getInt("codFornecedor"));
            obj.setNomeFornecedor(rs.getString("nomeFornecedor"));
            obj.setCnpj(rs.getString("cnpj"));
            obj.setEndereco(rs.getString("endereco"));
            obj.setBairro(rs.getString("bairro"));
            obj.setCidade(rs.getString("cidade"));
            obj.setEstado(rs.getString("estado"));
            System.out.println("Mapeando: " + obj);
            return obj;
        }
    }

    public void salvar(Fornecedor obj) {
        String sql = "INSERT INTO fornecedores(nomeFornecedor, cnpj, endereco, bairro, cidade, estado) VALUES(?,?,?,?,?,?)";
        save(sql, obj.getNomeFornecedor(), obj.getCnpj(), obj.getEndereco(), obj.getBairro(), obj.getCidade(), obj.getEstado());
    }

    public void alterar(Fornecedor obj) {
        String sql = "UPDATE fornecedores SET nomeFornecedor=?, cnpj=?, endereco=?, bairro=?, cidade=?, estado=? WHERE codFornecedor=?";
        save(sql, obj.getNomeFornecedor(), obj.getCnpj(), obj.getEndereco(), obj.getBairro(), obj.getCidade(), obj.getEstado(), obj.getCodFornecedor());
    }

    public void excluir(Fornecedor obj) {
        String sql = "DELETE FROM fornecedores WHERE codFornecedor=?";
        save(sql, obj.getCodFornecedor());
    }

    public List<Fornecedor> buscarTodos() {
        return buscarTodos("SELECT * FROM fornecedores", new FornecedorRowMapper());
    }

    public Fornecedor buscarPorId(int id) {
        return buscarPorId("SELECT * FROM fornecedores WHERE codFornecedor=?", new FornecedorRowMapper(), id);
    }
}
