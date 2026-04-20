package com.mycompany.restaurantehamburgueria.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class GenericoDAO<T> {

    private int lastId;

    public int getLastId() {
        return lastId;
    }

    private final ConnectionFactory connectionFactory = ConnectionFactory.getInstance();

    public void save(String comandoSql, Object... parametros) {
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            con = connectionFactory.getConnection();
            pstmt = con.prepareStatement(comandoSql, PreparedStatement.RETURN_GENERATED_KEYS);
            for (int i = 0; i < parametros.length; i++) {
                if (parametros[i] instanceof Calendar calendar) {
                    pstmt.setTimestamp(i + 1, new java.sql.Timestamp(calendar.getTimeInMillis()));
                } else {
                    pstmt.setObject(i + 1, parametros[i]);
                }
            }
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    lastId = rs.getInt(1);
                    System.out.println("Ultimo id gerado: " + lastId);
                }
                System.out.println("SAVE SUCESSO!");
            } else {
                System.out.println("SAVE NÃO EXECUTOU!");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<T> buscarTodos(String comandoSql, RowMapper<T> rowMapper) {
        List<T> entidades = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = connectionFactory.getConnection();
            pstmt = con.prepareStatement(comandoSql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                entidades.add(rowMapper.mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return entidades;
    }

    public T buscarPorId(String comandoSql, RowMapper<T> rowMapper, Object... parametros) {
        T entidade = null;
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = connectionFactory.getConnection();
            pstmt = con.prepareStatement(comandoSql);
            for (int i = 0; i < parametros.length; i++) {
                pstmt.setObject(i + 1, parametros[i]);
            }
            rs = pstmt.executeQuery();
            if (rs.next()) {
                entidade = rowMapper.mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return entidade;
    }
}
