<%@ page import="java.sql.*, database.DBConnection" %>
<%@ page session="true" %>
<%
    int bookId = Integer.parseInt(request.getParameter("id"));
%>
<html>
<head>
    <title>Kitap Detay</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-3">
    <%-- Kullanıcı bilgisi ve menü --%>
    <div class="row mb-3">
        <div class="col-md-6">
            <a href="books.jsp" class="btn btn-outline-secondary">&larr; Kitap Listesine Dön</a>
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

    <%-- Mesajlar --%>
    <%
        String error = request.getParameter("error");
        if (error != null) {
    %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <%
        String msg = request.getParameter("msg");
        if ("commentDeleted".equals(msg)) {
    %>
        <div class="alert alert-success">Yorum başarıyla silindi!</div>
    <% } %>

<%
    try(Connection conn = DBConnection.getConnection()) {
        PreparedStatement psBook = conn.prepareStatement("SELECT title, author, description FROM books WHERE id = ?");
        psBook.setInt(1, bookId);
        ResultSet rsBook = psBook.executeQuery();

        if(rsBook.next()) {
            out.println("<h2>" + rsBook.getString("title") + "</h2>");
            out.println("<h4>Yazar: " + rsBook.getString("author") + "</h4>");
            out.println("<p>" + rsBook.getString("description") + "</p>");
        }

        // Yorumları ve kullanıcı bilgilerini çek
        PreparedStatement psComments = conn.prepareStatement(
            "SELECT c.id, c.comment, c.rating, c.user_id, u.username FROM comments c JOIN users u ON c.user_id = u.id WHERE c.book_id = ? ORDER BY c.id DESC");
        psComments.setInt(1, bookId);
        ResultSet rsComments = psComments.executeQuery();

        int sumRating = 0;
        int countRating = 0;
        
        // Kullanıcının ID'sini al (silme işlemi için)
        Integer currentUserId = null;
        if (user != null) {
            PreparedStatement psCurrentUser = conn.prepareStatement("SELECT id FROM users WHERE username = ?");
            psCurrentUser.setString(1, user);
            ResultSet rsCurrentUser = psCurrentUser.executeQuery();
            if (rsCurrentUser.next()) {
                currentUserId = rsCurrentUser.getInt("id");
            }
        }

        out.println("<h3>Yorumlar</h3>");
        while(rsComments.next()) {
            int commentId = rsComments.getInt("id");
            String comment = rsComments.getString("comment");
            int rating = rsComments.getInt("rating");
            String username = rsComments.getString("username");
            int commentUserId = rsComments.getInt("user_id");

            out.println("<div class='border p-3 mb-3'>");
            out.println("<div class='d-flex justify-content-between align-items-start'>");
            out.println("<div>");
            out.println("<b>" + username + "</b> - Puan: " + rating + "/5<br>");
            out.println("<p class='mt-2'>" + comment + "</p>");
            out.println("</div>");
            
            // Sadece kendi yorumunu silebilir
            if (currentUserId != null && currentUserId == commentUserId) {
                out.println("<div>");
                out.println("<form method='post' action='DeleteServlet' style='display:inline'>");
                out.println("<input type='hidden' name='action' value='deleteComment'>");
                out.println("<input type='hidden' name='commentId' value='" + commentId + "'>");
                out.println("<input type='hidden' name='bookId' value='" + bookId + "'>");
                out.println("<button type='submit' class='btn btn-sm btn-outline-danger' onclick='return confirm(\"Bu yorumu silmek istediğinizden emin misiniz?\")'>Sil</button>");
                out.println("</form>");
                out.println("</div>");
            }
            
            out.println("</div>");
            out.println("</div>");

            sumRating += rating;
            countRating++;
        }

        if(countRating > 0) {
            double avgRating = (double)sumRating / countRating;
            out.println("<div class='alert alert-info'>");
            out.println("<h4>Ortalama Puan: " + String.format("%.1f", avgRating) + "/5 (" + countRating + " değerlendirme)</h4>");
            out.println("</div>");
        } else {
            out.println("<div class='alert alert-warning'>");
            out.println("<h4>Henüz puan verilmemiş.</h4>");
            out.println("</div>");
        }

    } catch(Exception e) {
        out.println("<div class='alert alert-danger'>Hata: " + e.getMessage() + "</div>");
    }
%>

<%-- Yorum ve puan ekleme formu (giriş yapılmışsa) --%>
<%
    if(user != null) {
%>
    <div class="card mt-4">
        <div class="card-header">
            <h5>Yorum ve Puan Ekle</h5>
        </div>
        <div class="card-body">
            <form action="CommentServlet" method="post">
                <input type="hidden" name="book_id" value="<%= bookId %>">
                <div class="form-group">
                    <label>Yorumunuz:</label>
                    <textarea name="comment" class="form-control" rows="4" required></textarea>
                </div>
                <div class="form-group">
                    <label>Puan (1-5):</label>
                    <select name="rating" class="form-control" required>
                        <option value="">Puan seçiniz</option>
                        <option value="1">1 - Çok Kötü</option>
                        <option value="2">2 - Kötü</option>
                        <option value="3">3 - Orta</option>
                        <option value="4">4 - İyi</option>
                        <option value="5">5 - Mükemmel</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">Yorum Ekle</button>
            </form>
        </div>
    </div>
<%
    } else {
        out.println("<div class='alert alert-info mt-4'>");
        out.println("<p>Yorum yapabilmek için <a href='login.jsp'>giriş yapınız</a>.</p>");
        out.println("</div>");
    }
%>
</div>
</body>
</html>