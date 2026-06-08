package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Ingrediente;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class IngredienteDao extends GenericoDAO<Ingrediente> {

    private static class IngredienteRowMapper implements RowMapper<Ingrediente> {
        private final FornecedorDao fornecedorDao = new FornecedorDao();

        @Override
        public Ingrediente mapRow(ResultSet rs) throws SQLException {
            Ingrediente obj = new Ingrediente();
            obj.setCodIngrediente(rs.getInt("codIngrediente"));
            obj.setNomeIngredientes(rs.getString("nomeIngredientes"));
            obj.setQuantiIngredientes(rs.getDouble("quantiIngredientes"));
            if (rs.getDate("dataProducao") != null) {
                obj.setDataProducao(rs.getDate("dataProducao").toLocalDate());
            }
            if (rs.getDate("dataVencimento") != null) {
                obj.setDataVencimento(rs.getDate("dataVencimento").toLocalDate());
            }
            obj.setValorIngrediente(rs.getDouble("valorIngrediente"));
            obj.setDescricaoIngrediente(rs.getString("descricaoIngrediente"));
            obj.setFornecedorIngrediente(fornecedorDao.buscarPorId(rs.getInt("fornecedores_codFornecedor")));
            System.out.println("Mapeando: " + obj);
            return obj;
        }
    }

    public void salvar(Ingrediente obj) {
        String sql = "INSERT INTO ingrediente(nomeIngredientes, quantiIngredientes, dataProducao, dataVencimento, valorIngrediente, descricaoIngrediente, fornecedores_codFornecedor) VALUES(?,?,?,?,?,?,?)";
        save(sql,
            obj.getNomeIngredientes(),
            obj.getQuantiIngredientes(),
            obj.getDataProducao(),
            obj.getDataVencimento(),
            obj.getValorIngrediente(),
            obj.getDescricaoIngrediente(),
            obj.getFornecedorIngrediente().getCodFornecedor()
        );
    }

    public void alterar(Ingrediente obj) {
        String sql = "UPDATE ingrediente SET nomeIngredientes=?, quantiIngredientes=?, dataProducao=?, dataVencimento=?, valorIngrediente=?, descricaoIngrediente=?, fornecedores_codFornecedor=? WHERE codIngrediente=?";
        save(sql,
            obj.getNomeIngredientes(),
            obj.getQuantiIngredientes(),
            obj.getDataProducao(),
            obj.getDataVencimento(),
            obj.getValorIngrediente(),
            obj.getDescricaoIngrediente(),
            obj.getFornecedorIngrediente().getCodFornecedor(),
            obj.getCodIngrediente()
        );
    }

    public void excluir(Ingrediente obj) {
        String sql = "DELETE FROM ingrediente WHERE codIngrediente=?";
        save(sql, obj.getCodIngrediente());
    }

    public List<Ingrediente> buscarTodos() {
        return buscarTodos("SELECT * FROM ingrediente", new IngredienteRowMapper());
    }

    public Ingrediente buscarPorId(int id) {
        return buscarPorId("SELECT * FROM ingrediente WHERE codIngrediente=?", new IngredienteRowMapper(), id);
    }
}
