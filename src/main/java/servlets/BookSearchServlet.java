package servlets;

import database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/BookSearchServlet")
public class BookSearchServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("search");
        String searchType = request.getParameter("searchType"); // title, author, both
        
        if (searchQuery == null || searchQuery.trim().isEmpty()) {
            response.sendRedirect("books.jsp");
            return;
        }

        List<Map<String, Object>> searchResults = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql;
            PreparedStatement ps;
            
            if ("title".equals(searchType)) {
                sql = "SELECT id, title, author FROM books WHERE LOWER(title) LIKE LOWER(?)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, "%" + searchQuery + "%");
            } else if ("author".equals(searchType)) {
                sql = "SELECT id, title, author FROM books WHERE LOWER(author) LIKE LOWER(?)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, "%" + searchQuery + "%");
            } else { // both
                sql = "SELECT id, title, author FROM books WHERE LOWER(title) LIKE LOWER(?) OR LOWER(author) LIKE LOWER(?)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, "%" + searchQuery + "%");
                ps.setString(2, "%" + searchQuery + "%");
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> book = new HashMap<>();
                book.put("id", rs.getInt("id"));
                book.put("title", rs.getString("title"));
                book.put("author", rs.getString("author"));
                searchResults.add(book);
            }
            
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("searchQuery", searchQuery);
            request.setAttribute("searchType", searchType);
            request.getRequestDispatcher("searchResults.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Arama sırasında hata oluştu: " + e.getMessage());
            request.getRequestDispatcher("books.jsp").forward(request, response);
        }
    }
}