package com.mycompany.restaurantehamburgueria.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ConnectionFactory {

    private static final String DB_URL = "jdbc:mysql://localhost:3307/bd_restaurante?useSSL=false&serverTimezone=America/Sao_Paulo&allowPublicKeyRetrieval=true";
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";

    private static ConnectionFactory instance;

    private ConnectionFactory() {
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver do banco de dados não encontrado", e);
        }
    }

    public static ConnectionFactory getInstance() {
        if (instance == null) {
            instance = new ConnectionFactory();
        }
        return instance;
    }

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    public PreparedStatement getPreparedStatement(String sql) throws SQLException {
        Connection con = getConnection();
        return con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
    }
}
