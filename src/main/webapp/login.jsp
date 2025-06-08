<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Giriş / Kayıt</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="text-center mb-4">
                <h1>Kitap Değerlendirme Sistemi</h1>
                <p class="text-muted">Giriş yapın veya yeni hesap oluşturun</p>
            </div>

            <%-- Mesajlar --%>
            <% 
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="alert alert-danger"><%= error %></div>
            <% } %>

            <%
                String msg = request.getParameter("msg");
                if ("registered".equals(msg)) {
            %>
                <div class="alert alert-success">Kayıt başarılı! Lütfen giriş yapın.</div>
            <% } else if ("loggedOut".equals(msg)) { %>
                <div class="alert alert-info">Başarıyla çıkış yaptınız.</div>
            <% } %>

            <div class="row">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h4>Giriş Yap</h4>
                        </div>
                        <div class="card-body">
                            <form action="UserServlet" method="post">
                                <input type="hidden" name="action" value="login" />
                                <div class="form-group">
                                    <label for="username">Kullanıcı Adı:</label>
                                    <input type="text" id="username" name="username" class="form-control" required />
                                </div>
                                <div class="form-group">
                                    <label for="password">Şifre:</label>
                                    <input type="password" id="password" name="password" class="form-control" required />
                                </div>
                                <button type="submit" class="btn btn-primary btn-block">Giriş Yap</button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h4>Kayıt Ol</h4>
                        </div>
                        <div class="card-body">
                            <form action="UserServlet" method="post">
                                <input type="hidden" name="action" value="register" />
                                <div class="form-group">
                                    <label for="reg_username">Kullanıcı Adı:</label>
                                    <input type="text" id="reg_username" name="username" class="form-control" required />
                                </div>
                                <div class="form-group">
                                    <label for="reg_password">Şifre:</label>
                                    <input type="password" id="reg_password" name="password" class="form-control" required />
                                </div>
                                <button type="submit" class="btn btn-success btn-block">Kayıt Ol</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="text-center mt-4">
                <a href="books.jsp" class="btn btn-outline-secondary">Kitapları Görüntüle (Giriş yapmadan)</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
            