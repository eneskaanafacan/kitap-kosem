package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "";
    private static final String USER = ""; // kendi kullanıcı adını yaz
    private static final String PASSWORD = ""; // kendi şifreni yaz

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // JDBC driver'ı yükle
            return DriverManager.getConnection(URL, USER, PASSWORD); // bağlantıyı döndür
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver bulunamadı.", e);
        }
    }
}
