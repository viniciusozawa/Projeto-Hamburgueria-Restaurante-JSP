package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Ingrediente;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class IngredienteDao extends GenericoDAO<Ingrediente> {

    private static class IngredienteRowMapper implements RowMapper<Ingrediente> {
        @Override
        public Ingrediente mapRow(ResultSet rs) throws SQLException {
            Ingrediente obj = new Ingrediente();
            obj.setCodIngrediente(rs.getInt("codIngrediente"));
            obj.setNomeIngredientes(rs.getString("nomeIngredientes"));
            obj.setQuantiIngredientes(rs.getBigDecimal("quantiIngredientes"));
            Date dp = rs.getDate("dataProducao");
            if (dp != null) obj.setDataProducao(dp.toLocalDate());
            Date dv = rs.getDate("dataVencimento");
            if (dv != null) obj.setDataVencimento(dv.toLocalDate());
            obj.setValorIngrediente(rs.getBigDecimal("valorIngrediente"));
            obj.setDescricaoIngrediente(rs.getString("descricaoIngrediente"));
            obj.setFornecedores_codFornecedor(rs.getInt("fornecedores_codFornecedor"));
            try { obj.setNomeFornecedor(rs.getString("nomeFornecedor")); } catch (SQLException ignored) {}
            return obj;
        }
    }

    public void salvar(Ingrediente obj) {
        String sql = "INSERT INTO ingrediente(nomeIngredientes, quantiIngredientes, dataProducao, dataVencimento, valorIngrediente, descricaoIngrediente, fornecedores_codFornecedor) VALUES(?,?,?,?,?,?,?)";
        save(sql,
            obj.getNomeIngredientes(),
            obj.getQuantiIngredientes(),
            obj.getDataProducao() != null ? Date.valueOf(obj.getDataProducao()) : null,
            obj.getDataVencimento() != null ? Date.valueOf(obj.getDataVencimento()) : null,
            obj.getValorIngrediente(),
            obj.getDescricaoIngrediente(),
            obj.getFornecedores_codFornecedor()
        );
    }

    public void alterar(Ingrediente obj) {
        String sql = "UPDATE ingrediente SET nomeIngredientes=?, quantiIngredientes=?, dataProducao=?, dataVencimento=?, valorIngrediente=?, descricaoIngrediente=?, fornecedores_codFornecedor=? WHERE codIngrediente=?";
        save(sql,
            obj.getNomeIngredientes(),
            obj.getQuantiIngredientes(),
            obj.getDataProducao() != null ? Date.valueOf(obj.getDataProducao()) : null,
            obj.getDataVencimento() != null ? Date.valueOf(obj.getDataVencimento()) : null,
            obj.getValorIngrediente(),
            obj.getDescricaoIngrediente(),
            obj.getFornecedores_codFornecedor(),
            obj.getCodIngrediente()
        );
    }

    public void excluir(Ingrediente obj) {
        String sql = "DELETE FROM ingrediente WHERE codIngrediente=?";
        save(sql, obj.getCodIngrediente());
    }

    public List<Ingrediente> buscarTodos() {
        String sql = "SELECT i.*, f.nomeFornecedor FROM ingrediente i LEFT JOIN fornecedores f ON f.codFornecedor = i.fornecedores_codFornecedor ORDER BY i.nomeIngredientes";
        return buscarTodos(sql, new IngredienteRowMapper());
    }

    public Ingrediente buscarPorId(int id) {
        String sql = "SELECT i.*, f.nomeFornecedor FROM ingrediente i LEFT JOIN fornecedores f ON f.codFornecedor = i.fornecedores_codFornecedor WHERE i.codIngrediente=?";
        return buscarPorId(sql, new IngredienteRowMapper(), id);
    }
}
