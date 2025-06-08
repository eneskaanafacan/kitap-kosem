package servlets;

import database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

@WebServlet("/CommentServlet")
public class CommentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String user = (session != null) ? (String) session.getAttribute("user") : null;

        if(user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int bookId = Integer.parseInt(request.getParameter("book_id"));
        String comment = request.getParameter("comment");
        int rating = Integer.parseInt(request.getParameter("rating"));

        try (Connection conn = DBConnection.getConnection()) {
            // Kullanıcı ID'sini çek
            PreparedStatement psUser = conn.prepareStatement("SELECT id FROM users WHERE username = ?");
            psUser.setString(1, user);
            ResultSet rsUser = psUser.executeQuery();

            if(rsUser.next()) {
                int userId = rsUser.getInt("id");

                PreparedStatement psInsert = conn.prepareStatement(
                        "INSERT INTO comments (book_id, user_id, comment, rating) VALUES (?, ?, ?, ?)");
                psInsert.setInt(1, bookId);
                psInsert.setInt(2, userId);
                psInsert.setString(3, comment);
                psInsert.setInt(4, rating);

                psInsert.executeUpdate();

                response.sendRedirect("bookDetail.jsp?id=" + bookId);
            } else {
                response.sendRedirect("login.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("bookDetail.jsp?id=" + bookId + "&error=Yorum eklenemedi");
        }
    }
}
