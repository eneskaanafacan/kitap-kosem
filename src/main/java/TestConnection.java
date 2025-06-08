import database.DBConnection;
import java.sql.Connection;

public class TestConnection {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("✅ Bağlantı başarılı!");
        } catch (Exception e) {
            System.out.println("❌ Bağlantı hatası: " + e.getMessage());
        }
    }
}
