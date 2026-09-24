package edu.ynu.p1.v04;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class ConnectionFactory {
    private final DbConfig config;
    public ConnectionFactory(DbConfig config) { this.config = config; }
    public Connection open() throws SQLException {
        return DriverManager.getConnection(config.url(), config.user(), config.password());
    }
}
