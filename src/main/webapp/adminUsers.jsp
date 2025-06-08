<%@ page import="java.sql.*,database.DBConnection" %>
<%@ page session="true" %>
<html>
<head>
    <title>Kullanıcı Yönetimi</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-3">
    <%-- Kullanıcı bilgisi ve menü --%>
    <div class="row mb-3">
        <div class="col-md-6">
            <h2>Kullanıcı Yönetimi</h2>
        </div>
        <div class="col-md-6 text-right">
            <%
                String user = (String) session.getAttribute("user");
                if (user != null) {
            %>
                <span>Hoş geldin, <strong><%= user %></strong>!</span>
                <a href="books.jsp" class="btn btn-sm btn-outline-primary ml-2">Kitaplara Dön</a>
                <a href="LogoutServlet" class="btn btn-sm btn-outline-danger ml-2">Çıkış</a>
            <%
                } else {
            %>
                <a href="login.jsp" class="btn btn-sm btn-primary">Giriş Yap</a>
            <%
                }
            %>
        </div>
    </div>

    <%-- Mesajlar --%>
    <%
        String error = request.getParameter("error");
        if (error != null) {
    %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <%
        String msg = request.getParameter("msg");
        if ("userAdded".equals(msg)) {
    %>
        <div class="alert alert-success">Kullanıcı başarıyla eklendi! (Varsayılan şifre: 123456)</div>
    <% } else if ("userDeleted".equals(msg)) { %>
        <div class="alert alert-success">Kullanıcı başarıyla silindi!</div>
    <% } %>

    <div class="card mb-4">
        <div class="card-header">
            <h4>Yeni Kullanıcı Ekle</h4>
        </div>
        <div class="card-body">
            <form method="post" action="UserServlet" class="form-inline">
                <div class="form-group mr-3">
                    <label for="username" class="mr-2">Kullanıcı Adı:</label>
                    <input type="text" id="username" name="username" class="form-control" required />
                </div>
                <button type="submit" name="action" value="Ekle" class="btn btn-primary">Ekle</button>
                <small class="form-text text-muted ml-3">Varsayılan şifre: 123456</small>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h4>Kullanıcı Listesi</h4>
        </div>
        <div class="card-body">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Kullanıcı Adı</th>
                        <th>Kayıt Tarihi</th>
                        <th>Yorum Sayısı</th>
                        <th>İşlemler</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        // Kullanıcıları ve yorum sayılarını çek
                        String sql = "SELECT u.id, u.username, u.created_at, COUNT(c.id) as comment_count " +
                                   "FROM users u LEFT JOIN comments c ON u.id = c.user_id " +
                                   "GROUP BY u.id, u.username, u.created_at ORDER BY u.id";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();
                        
                        while (rs.next()) {
                            int id = rs.getInt("id");
                            String username = rs.getString("username");
                            Timestamp createdAt = rs.getTimestamp("created_at");
                            int commentCount = rs.getInt("comment_count");
                %>
                <tr>
                    <td><%= id %></td>
                    <td><%= username %></td>
                    <td><%= createdAt != null ? createdAt.toString().substring(0, 19) : "N/A" %></td>
                    <td><%= commentCount %></td>
                    <td>
                        <form method="post" action="UserServlet" style="display:inline">
                            <input type="hidden" name="deleteId" value="<%= id %>"/>
                            <button type="submit" class="btn btn-sm btn-danger" 
                                    onclick="return confirm('Bu kullanıcıyı silmek istediğinizden emin misiniz? Tüm yorumları da silinecektir!')">
                                Sil
                            </button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='5'>Hata: " + e.getMessage() + "</td></tr>");
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>