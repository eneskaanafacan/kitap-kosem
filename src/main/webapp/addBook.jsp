<!DOCTYPE html>
<html>
<head>
    <title>Yeni Kitap Ekle</title>
</head>
<body>
    <h2>Yeni Kitap Ekle</h2>
    <form action="${pageContext.request.contextPath}/BookServlet" method="post">

        <label>Baslik:</label>
        <input type="text" name="title" required /><br/>
        
        <label>Yazar:</label>
        <input type="text" name="author" required /><br/>
        
        <label>Aciklama:</label>
        <textarea name="description" required></textarea><br/>
        
        <button type="submit">Ekle</button>
    </form>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <p style="color:red;"><%= error %></p>
    <% } %>

    <%
        String msg = request.getParameter("msg");
        if ("added".equals(msg)) {
    %>
        <p style="color:green;">Kitap basarıyla eklendi</p>
    <% } %>
</body>
</html>
