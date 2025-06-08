<%@ page import="java.sql.*, database.DBConnection" %>
<%@ page session="true" %>
<html>
<head>
    <title>Kitap Listesi</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-3">
    <%-- Kullanıcı bilgisi ve menü --%>
    <div class="row mb-3">
        <div class="col-md-6">
            <h1>Kitap Listesi</h1>
        </div>
        <div class="col-md-6 text-right">
            <%
                String user = (String) session.getAttribute("user");
                if (user != null) {
            %>
                <span>Hoş geldin, <strong><%= user %></strong>!</span>
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

    <%-- Arama formu --%>
    <div class="row mb-3">
        <div class="col-md-12">
            <form action="BookSearchServlet" method="get" class="form-inline">
                <input type="text" name="search" class="form-control mr-2" placeholder="Kitap ara..." 
                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <select name="searchType" class="form-control mr-2">
                    <option value="both">Başlık ve Yazar</option>
                    <option value="title">Sadece Başlık</option>
                    <option value="author">Sadece Yazar</option>
                </select>
                <button type="submit" class="btn btn-outline-primary mr-2">Ara</button>
                <a href="books.jsp" class="btn btn-outline-secondary">Tümünü Göster</a>
            </form>
        </div>
    </div>

    <a href="addBook.jsp" class="btn btn-primary mb-3">Yeni Kitap Ekle</a>
    
    <%-- Mesajlar --%>
    <%
        String error = request.getParameter("error");
        if (error != null) {
    %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <%
        String msg = request.getParameter("msg");
        if ("bookDeleted".equals(msg)) {
    %>
        <div class="alert alert-success">Kitap başarıyla silindi!</div>
    <% } %>

    <table class="table table-striped">
        <thead>
            <tr>
                <th>Başlık</th>
                <th>Yazar</th>
                <th>Detay</th>
                <th>İşlemler</th>
            </tr>
        </thead>
        <tbody>
        <%
            try(Connection conn = DBConnection.getConnection()) {
                PreparedStatement ps = conn.prepareStatement("SELECT id, title, author FROM books ORDER BY title");
                ResultSet rs = ps.executeQuery();
                while(rs.next()) {
                    int id = rs.getInt("id");
                    String title = rs.getString("title");
                    String author = rs.getString("author");
        %>
            <tr>
                <td><%= title %></td>
                <td><%= author %></td>
                <td><a href="bookDetail.jsp?id=<%= id %>" class="btn btn-sm btn-info">Detay</a></td>
                <td>
                    <%-- Herkes kitap silebilir (isteğe bağlı olarak sadece ekleyen kişi silebilir yapılabilir) --%>
                    <% if (user != null) { %>
                        <form method="post" action="DeleteServlet" style="display:inline">
                            <input type="hidden" name="action" value="deleteBook">
                            <input type="hidden" name="bookId" value="<%= id %>">
                            <button type="submit" class="btn btn-sm btn-danger" 
                                    onclick="return confirm('Bu kitabı silmek istediğinizden emin misiniz?')">Sil</button>
                        </form>
                    <% } %>
                </td>
            </tr>
        <%
                }
            } catch(Exception e) {
                out.println("<tr><td colspan='4'>Hata: " + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>