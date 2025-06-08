package servlets;

import database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.MessageDigest;
import java.sql.*;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("register".equals(action)) {
            registerUser(request, response);
        } else if ("login".equals(action)) {
            loginUser(request, response);
        } else if ("Ekle".equals(action)) {
            addUserByAdmin(request, response);
        } else if (request.getParameter("deleteId") != null) {
            deleteUser(request, response);
        }
    }

    private void registerUser(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Kullanıcı adı ve şifre boş olamaz!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        String hashedPassword = hashPassword(password);

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (username, password) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username.trim());
            ps.setString(2, hashedPassword);
            ps.executeUpdate();

            response.sendRedirect("login.jsp?msg=registered");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Kayıt başarısız! Kullanıcı adı zaten var olabilir.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void loginUser(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Kullanıcı adı ve şifre boş olamaz!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        String hashedPassword = hashPassword(password);

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username.trim());
            ps.setString(2, hashedPassword);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("user", username.trim());
                response.sendRedirect("books.jsp");
            } else {
                request.setAttribute("error", "Kullanıcı adı veya şifre hatalı!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Giriş sırasında hata oluştu.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void addUserByAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String username = request.getParameter("username");
        
        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect("adminUsers.jsp?error=Kullanıcı adı boş olamaz!");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (username, password) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username.trim());
            ps.setString(2, hashPassword("123456")); // Varsayılan şifre
            ps.executeUpdate();

            response.sendRedirect("adminUsers.jsp?msg=userAdded");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("adminUsers.jsp?error=Kullanıcı eklenemedi! Kullanıcı adı zaten var olabilir.");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String deleteIdStr = request.getParameter("deleteId");
        
        try {
            int deleteId = Integer.parseInt(deleteIdStr);
            
            try (Connection conn = DBConnection.getConnection()) {
                // Önce kullanıcının yorumlarını sil
                PreparedStatement psComments = conn.prepareStatement("DELETE FROM comments WHERE user_id = ?");
                psComments.setInt(1, deleteId);
                psComments.executeUpdate();
                
                // Sonra kullanıcıyı sil
                PreparedStatement psUser = conn.prepareStatement("DELETE FROM users WHERE id = ?");
                psUser.setInt(1, deleteId);
                int deletedRows = psUser.executeUpdate();
                
                if (deletedRows > 0) {
                    response.sendRedirect("adminUsers.jsp?msg=userDeleted");
                } else {
                    response.sendRedirect("adminUsers.jsp?error=Kullanıcı silinemedi!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminUsers.jsp?error=Silme işlemi sırasında hata oluştu!");
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}