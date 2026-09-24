package edu.ynu.p1.v04;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

public record DbConfig(String url, String user, String password) {
    public static DbConfig load() throws IOException {
        Properties properties = new Properties();
        Path path = Path.of(System.getenv().getOrDefault("DB_CONFIG", "config.properties"));
        if (Files.exists(path)) {
            try (InputStream in = Files.newInputStream(path)) {
                properties.load(in);
            }
        }
        String url = value("DB_URL", properties, "db.url", "jdbc:postgresql://localhost:5432/lesson05_demo");
        String user = value("DB_USER", properties, "db.user", System.getProperty("user.name"));
        String password = value("DB_PASSWORD", properties, "db.password", "");
        return new DbConfig(url, user, password);
    }

    private static String value(String env, Properties p, String key, String fallback) {
        String fromEnv = System.getenv(env);
        return fromEnv != null ? fromEnv : p.getProperty(key, fallback);
    }
}
