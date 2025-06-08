package servlets;

import database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/DeleteServlet")
public class DeleteServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String user = (session != null) ? (String) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("deleteBook".equals(action)) {
            deleteBook(request, response, user);
        } else if ("deleteComment".equals(action)) {
            deleteComment(request, response, user);
        }
    }

    private void deleteBook(HttpServletRequest request, HttpServletResponse response, String username) throws IOException {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        
        try (Connection conn = DBConnection.getConnection()) {
            // Kullanıcı ID'sini al
            PreparedStatement psUser = conn.prepareStatement("SELECT id FROM users WHERE username = ?");
            psUser.setString(1, username);
            ResultSet rsUser = psUser.executeQuery();
            
            if (rsUser.next()) {
                int userId = rsUser.getInt("id");
                
                // Kitabın sahibi olup olmadığını kontrol et (opsiyonel: bu kontrolü eklemek isteyebilirsiniz)
                // Önce kitapla ilgili yorumları sil
                PreparedStatement psDeleteComments = conn.prepareStatement("DELETE FROM comments WHERE book_id = ?");
                psDeleteComments.setInt(1, bookId);
                psDeleteComments.executeUpdate();
                
                // Sonra kitabı sil
                PreparedStatement psDeleteBook = conn.prepareStatement("DELETE FROM books WHERE id = ?");
                psDeleteBook.setInt(1, bookId);
                int deletedRows = psDeleteBook.executeUpdate();
                
                if (deletedRows > 0) {
                    response.sendRedirect("books.jsp?msg=bookDeleted");
                } else {
                    response.sendRedirect("books.jsp?error=Kitap silinemedi");
                }
            } else {
                response.sendRedirect("login.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("books.jsp?error=Silme işlemi sırasında hata oluştu");
        }
    }

    private void deleteComment(HttpServletRequest request, HttpServletResponse response, String username) throws IOException {
        int commentId = Integer.parseInt(request.getParameter("commentId"));
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        
        try (Connection conn = DBConnection.getConnection()) {
            // Kullanıcı ID'sini al
            PreparedStatement psUser = conn.prepareStatement("SELECT id FROM users WHERE username = ?");
            psUser.setString(1, username);
            ResultSet rsUser = psUser.executeQuery();
            
            if (rsUser.next()) {
                int userId = rsUser.getInt("id");
                
                // Sadece kendi yorumunu silebilir
                PreparedStatement psDelete = conn.prepareStatement("DELETE FROM comments WHERE id = ? AND user_id = ?");
                psDelete.setInt(1, commentId);
                psDelete.setInt(2, userId);
                int deletedRows = psDelete.executeUpdate();
                
                if (deletedRows > 0) {
                    response.sendRedirect("bookDetail.jsp?id=" + bookId + "&msg=commentDeleted");
                } else {
                    response.sendRedirect("bookDetail.jsp?id=" + bookId + "&error=Yorum silinemedi");
                }
            } else {
                response.sendRedirect("login.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("bookDetail.jsp?id=" + bookId + "&error=Silme işlemi sırasında hata oluştu");
        }
    }
}