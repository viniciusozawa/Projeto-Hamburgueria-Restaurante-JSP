package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Cardapio;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class CardapioDao extends GenericoDAO<Cardapio> {

    private static class CardapioRowMapper implements RowMapper<Cardapio> {
        private final CategoriaDao categoriaDao = new CategoriaDao();

        @Override
        public Cardapio mapRow(ResultSet rs) throws SQLException {
            Cardapio obj = new Cardapio();
            obj.setCodCardapio(rs.getInt("codCardapio"));
            obj.setNomeComida(rs.getString("nomeComida"));
            obj.setValorComida(rs.getDouble("valorComida"));
            obj.setDescricaoComida(rs.getString("descricaoComida"));
            obj.setCategoriaCardapio(categoriaDao.buscarPorId(rs.getInt("categoria_codCategoria")));
            System.out.println("Mapeando: " + obj);
            return obj;
        }
    }

    public void salvar(Cardapio obj) {
        String sql = "INSERT INTO cardapio(nomeComida, valorComida, descricaoComida, categoria_codCategoria) VALUES(?,?,?,?)";
        save(sql,
            obj.getNomeComida(),
            obj.getValorComida(),
            obj.getDescricaoComida(),
            obj.getCategoriaCardapio().getCodCategoria()
        );
    }

    public void alterar(Cardapio obj) {
        String sql = "UPDATE cardapio SET nomeComida=?, valorComida=?, descricaoComida=?, categoria_codCategoria=? WHERE codCardapio=?";
        save(sql,
            obj.getNomeComida(),
            obj.getValorComida(),
            obj.getDescricaoComida(),
            obj.getCategoriaCardapio().getCodCategoria(),
            obj.getCodCardapio()
        );
    }

    public void excluir(Cardapio obj) {
        String sql = "DELETE FROM cardapio WHERE codCardapio=?";
        save(sql, obj.getCodCardapio());
    }

    public List<Cardapio> buscarTodos() {
        return buscarTodos("SELECT * FROM cardapio", new CardapioRowMapper());
    }

    public Cardapio buscarPorId(int id) {
        return buscarPorId("SELECT * FROM cardapio WHERE codCardapio=?", new CardapioRowMapper(), id);
    }
}
