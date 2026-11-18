
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login | ARK Vehicle Rentals</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: "Segoe UI", Arial, sans-serif;
    min-height: 100vh;
    color: white;
    background:
        linear-gradient(rgba(5,6,6,.78), rgba(5,6,6,.88)),
        url("https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=2000&q=85");
    background-position: center;
    background-size: cover;
    background-attachment: fixed;
    display: flex;
    flex-direction: column;
}

header {
    padding: 22px 7%;
    border-bottom: 1px solid #ffffff20;
    background: #00000030;
}

.brand {
    color: #d8b56d;
    font-size: 28px;
    font-weight: 900;
    letter-spacing: 5px;
}

.brand span {
    display: block;
    color: #ddd;
    font-size: 10px;
    font-weight: 400;
    letter-spacing: 2px;
}

main {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 35px 20px;
}

.login-card {
    width: 100%;
    max-width: 440px;
    padding: 38px;
    border: 1px solid #d8b56d60;
    border-radius: 18px;
    background: #111111c9;
    backdrop-filter: blur(12px);
    box-shadow: 0 25px 70px #0008;
    transition: .3s;
}

.login-card:hover {
    transform: translateY(-4px);
    border-color: #d8b56d;
}

.eyebrow {
    color: #d8b56d;
    font-size: 11px;
    font-weight: bold;
    letter-spacing: 3px;
}

h1 {
    font-size: 34px;
    margin: 12px 0;
}

.subtitle {
    color: #c5c5c5;
    font-size: 14px;
    line-height: 1.7;
    margin-bottom: 25px;
}

.success {
    color: #9de6ad;
    background: #174b2b70;
    padding: 12px;
    border-radius: 7px;
    font-size: 13px;
    margin-bottom: 18px;
}

label {
    display: block;
    font-size: 13px;
    margin-bottom: 8px;
}

input {
    width: 100%;
    padding: 13px;
    margin-bottom: 20px;
    border: 1px solid #454545;
    border-radius: 7px;
    background: #ffffff0d;
    color: white;
    font-size: 14px;
    outline: none;
}

input:focus {
    border-color: #d8b56d;
    box-shadow: 0 0 0 3px #d8b56d20;
}

input::placeholder {
    color: #999;
}

button {
    width: 100%;
    padding: 14px;
    background: #d8b56d;
    border: none;
    border-radius: 7px;
    color: #111;
    font-weight: 800;
    cursor: pointer;
    transition: .3s;
}

button:hover {
    background: #f0d397;
    transform: translateY(-2px);
}

.register-link {
    text-align: center;
    margin-top: 22px;
    color: #c5c5c5;
    font-size: 13px;
}

a {
    color: #e6c77f;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

footer {
    padding: 18px;
    text-align: center;
    color: #aaa;
    font-size: 11px;
    letter-spacing: 1px;
}

@media(max-width:480px) {
    .login-card {
        padding: 27px 22px;
    }
}
</style>
</head>

<body>

<header>
    <div class="brand">
        ARK
        <span>PREMIUM VEHICLE RENTALS</span>
    </div>
</header>

<main>
    <section class="login-card">

        <div class="eyebrow">WELCOME BACK</div>

        <h1>Sign In</h1>

        <p class="subtitle">
            Sign in to continue your journey with ARK.
        </p>

        <% if ("1".equals(request.getParameter("registered"))) { %>
            <div class="success">
                Account created successfully! Please sign in.
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/LoginServlet"
      method="post">

            <label for="email">Email</label>
            <input type="email" id="email" name="email"
                   placeholder="Enter Your Email"
                   autocomplete="username"
                   required maxlength="150">

            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   placeholder="Enter your password"
                   autocomplete="current-password"
                   required>

            <button type="submit">SIGN IN &rarr;</button>
        </form>

        <div class="register-link">
            Don't have an account?
            <a href="register.jsp">Create Account</a>
        </div>
        <div>
            <center><a href="index.jsp">Back to home</a><center>
        </div>

    </section>
</main>

<footer>
    EXPERIENCE THE DIFFERENCE | ARK VEHICLE RENTALS
</footer>

</body>
</html>