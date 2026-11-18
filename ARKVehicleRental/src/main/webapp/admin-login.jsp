
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("adminId") != null) {
        response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ARK | Admin Login</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #0b0b0b;
    color: #ffffff;
    font-family: Arial, sans-serif;
    padding: 20px;
}

.login-card {
    width: 100%;
    max-width: 420px;
    padding: 38px;
    background: #171717;
    border: 1px solid #383020;
    border-radius: 16px;
    box-shadow: 0 15px 50px rgba(0, 0, 0, 0.5);
}

.logo {
    color: #d4af37;
    font-size: 30px;
    font-weight: bold;
    letter-spacing: 5px;
    text-align: center;
    margin-bottom: 8px;
}

.subtitle {
    text-align: center;
    color: #aaa;
    margin-bottom: 30px;
    font-size: 14px;
}

h2 {
    text-align: center;
    margin-bottom: 25px;
    font-size: 23px;
}

label {
    display: block;
    margin-bottom: 8px;
    color: #ddd;
    font-size: 14px;
}

input {
    width: 100%;
    padding: 13px;
    margin-bottom: 20px;
    border: 1px solid #444;
    border-radius: 7px;
    background: #101010;
    color: white;
    outline: none;
}

input:focus {
    border-color: #d4af37;
}

button {
    width: 100%;
    padding: 14px;
    border: none;
    border-radius: 7px;
    background: linear-gradient(135deg, #f0d878, #b88a19);
    color: #111;
    font-weight: bold;
    font-size: 15px;
    cursor: pointer;
    transition: 0.2s;
}

button:hover {
    filter: brightness(1.12);
    transform: translateY(-1px);
}

.error {
    color: #ff7777;
    text-align: center;
    font-size: 14px;
    margin-bottom: 16px;
}

.back {
    display: block;
    text-align: center;
    margin-top: 24px;
    color: #d4af37;
    text-decoration: none;
    font-size: 13px;
}
</style>
</head>

<body>
<jsp:include page="/navbar.jsp" />

<div class="login-card">

    <div class="logo">ARK</div>
    <div class="subtitle">VEHICLE RENTALS · ADMIN PORTAL</div>

    <h2>Administrator Login</h2>

    <% if ("invalid".equals(request.getParameter("error"))) { %>
        <div class="error">Invalid administrator email or password.</div>
    <% } %>

    <form action="<%= request.getContextPath() %>/AdminLoginServlet"
          method="post">

        <label for="adminEmail">Administrator Email</label>
        <input type="email"
               id="adminEmail"
               name="adminEmail"
               placeholder="Enter admin email"
               required>

        <label for="adminPassword">Password</label>
        <input type="password"
               id="adminPassword"
               name="adminPassword"
               placeholder="Enter password"
               required>

        <button type="submit">SIGN IN TO ADMIN</button>
    </form>

    <a class="back"
       href="<%= request.getContextPath() %>/index.jsp">
       ← Back to ARK Website
    </a>

</div>
</body>
</html>
