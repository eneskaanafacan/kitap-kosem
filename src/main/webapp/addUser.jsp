<%@ page import="java.sql.*,database.DBConnection" %>
<html>
<head><title>Kullanici Yönetimi</title></head>
<body>
    <h2>Kullanici Ekle</h2>
    <form method="post" action="UserServlet">
        Kullanici adi: <input type="text" name="username" required />
        <input type="submit" name="action" value="Ekle" />
    </form>

    <h2>Kullanici Listesi</h2>
    <table border="1">
        <tr><th>ID</th><th>Username</th><th>Sil</th></tr>
        <%
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT * FROM users")) {
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("username") %></td>
            <td>
                <form method="post" action="UserServlet" style="display:inline">
                    <input type="hidden" name="deleteId" value="<%= rs.getInt("id") %>"/>
                    <input type="submit" value="Sil"/>
                </form>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("Hata: " + e.getMessage());
            }
        %>
    </table>
</body>
</html>
