package com.mycompany.restaurantehamburgueria.model.dao;

import com.mycompany.restaurantehamburgueria.model.entity.Cliente;
import com.mycompany.restaurantehamburgueria.service.Senha;
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
            obj.setEmail(rs.getString("email"));
            obj.setCpfCliente(rs.getString("cpfCliente"));
            obj.setSenhaCliente(rs.getString("senhaCliente"));
            obj.setTelefone(rs.getString("telefone"));
            obj.setEmailVerificado(rs.getBoolean("emailVerificado"));
            obj.setCadastroCompleto(rs.getBoolean("cadastroCompleto"));
            Timestamp ts = rs.getTimestamp("dataCadastro");
            if (ts != null) {
                obj.setDataCadastro(ts.toLocalDateTime());
            }
            System.out.println("Mapeando: " + obj);
            return obj;
        }
    }

    /*
     * A senha passa por Senha.paraGravar: texto digitado vira hash, valor que
     * já é hash passa direto. Sem isso, editar um cliente sem mexer na senha
     * hashearia o hash de novo e travaria o acesso da conta.
     */
    public void salvar(Cliente obj) {
        String sql = "INSERT INTO cliente(nomeCliente, email, cpfCliente, senhaCliente, telefone) VALUES(?,?,?,?,?)";
        save(sql, obj.getNomeCliente(), vazioViraNulo(obj.getEmail()), obj.getCpfCliente(),
             Senha.paraGravar(obj.getSenhaCliente()), obj.getTelefone());
    }

    public void alterar(Cliente obj) {
        String sql = "UPDATE cliente SET nomeCliente=?, email=?, cpfCliente=?, senhaCliente=?, telefone=? WHERE codCliente=?";
        save(sql, obj.getNomeCliente(), vazioViraNulo(obj.getEmail()), obj.getCpfCliente(),
             Senha.paraGravar(obj.getSenhaCliente()), obj.getTelefone(), obj.getCodCliente());
    }

    /**
     * Email em branco vira NULL.
     *
     * A coluna tem índice único, e o MySQL permite vários NULL mas só uma
     * string vazia — sem isso o segundo cliente sem email seria recusado.
     */
    private String vazioViraNulo(String email) {
        return (email == null || email.trim().isEmpty()) ? null : email.trim().toLowerCase();
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

    /** Chamado quando o link do email é aberto com sucesso. */
    public void marcarEmailVerificado(int codCliente) {
        save("UPDATE cliente SET emailVerificado = 1 WHERE codCliente = ?", codCliente);
    }

    /**
     * Grava os dados da segunda tela do cadastro.
     *
     * Só aqui `cadastroCompleto` vira 1 — é o que destrava o uso da conta.
     */
    public void completarCadastro(int codCliente, String telefone, String cpf) {
        String sql = "UPDATE cliente SET telefone = ?, cpfCliente = ?, cadastroCompleto = 1 "
                   + " WHERE codCliente = ?";
        save(sql, telefone, cpf, codCliente);
    }

    /** O CPF é único na prática: duas contas com o mesmo CPF são a mesma pessoa. */
    public boolean cpfDeOutroCliente(String cpf, int codCliente) {
        if (cpf == null || cpf.trim().isEmpty()) {
            return false;
        }
        // SELECT * porque o ClienteRowMapper lê todas as colunas.
        String sql = "SELECT * FROM cliente WHERE cpfCliente = ? AND codCliente <> ?";
        return buscarPorId(sql, new ClienteRowMapper(), cpf.trim(), codCliente) != null;
    }
}
