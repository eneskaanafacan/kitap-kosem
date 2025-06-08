<%@ page import="java.util.*, java.sql.*, database.DBConnection" %>
<%@ page session="true" %>
<html>
<head>
    <title>Arama Sonuçları</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-3">
    <%-- Kullanıcı bilgisi ve menü --%>
    <div class="row mb-3">
        <div class="col-md-6">
            <h1>Arama Sonuçları</h1>
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

    <%-- Arama bilgisi --%>
    <%
        String searchQuery = (String) request.getAttribute("searchQuery");
        String searchType = (String) request.getAttribute("searchType");
        List<Map<String, Object>> searchResults = (List<Map<String, Object>>) request.getAttribute("searchResults");
    %>
    
    <div class="alert alert-info">
        <strong>"<%= searchQuery %>"</strong> için arama sonuçları 
        <% if (searchResults != null) { %>
            (<%= searchResults.size() %> sonuç bulundu)
        <% } %>
    </div>

    <%-- Yeni arama formu --%>
    <div class="row mb-3">
        <div class="col-md-12">
            <form action="BookSearchServlet" method="get" class="form-inline">
                <input type="text" name="search" class="form-control mr-2" placeholder="Kitap ara..." 
                       value="<%= searchQuery != null ? searchQuery : "" %>">
                <select name="searchType" class="form-control mr-2">
                    <option value="both" <%= "both".equals(searchType) ? "selected" : "" %>>Başlık ve Yazar</option>
                    <option value="title" <%= "title".equals(searchType) ? "selected" : "" %>>Sadece Başlık</option>
                    <option value="author" <%= "author".equals(searchType) ? "selected" : "" %>>Sadece Yazar</option>
                </select>
                <button type="submit" class="btn btn-outline-primary mr-2">Ara</button>
                <a href="books.jsp" class="btn btn-outline-secondary">Tümünü Göster</a>
            </form>
        </div>
    </div>

    <% if (searchResults != null && !searchResults.isEmpty()) { %>
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
            <% for (Map<String, Object> book : searchResults) { %>
                <tr>
                    <td><%= book.get("title") %></td>
                    <td><%= book.get("author") %></td>
                    <td><a href="bookDetail.jsp?id=<%= book.get("id") %>" class="btn btn-sm btn-info">Detay</a></td>
                    <td>
                        <% if (user != null) { %>
                            <form method="post" action="DeleteServlet" style="display:inline">
                                <input type="hidden" name="action" value="deleteBook">
                                <input type="hidden" name="bookId" value="<%= book.get("id") %>">
                                <button type="submit" class="btn btn-sm btn-danger" 
                                        onclick="return confirm('Bu kitabı silmek istediğinizden emin misiniz?')">Sil</button>
                            </form>
                        <% } %>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } else { %>
        <div class="alert alert-warning">
            Aradığınız kriterlere uygun kitap bulunamadı.
        </div>
    <% } %>

    <a href="addBook.jsp" class="btn btn-primary">Yeni Kitap Ekle</a>
</div>
</body>
</html>