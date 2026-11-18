
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    String context = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Create Account | ARK Vehicle Rentals</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: "Segoe UI", Arial, sans-serif;
    min-height: 100vh;
    background:
        linear-gradient(rgba(5, 6, 6, 0.78), rgba(5, 6, 6, 0.88)),
        url("https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=2000&q=85");
    background-size: cover;
    background-position: center;
    background-attachment: fixed;
    color: white;
    display: flex;
    flex-direction: column;
}

.navbar {
    padding: 22px 7%;
    border-bottom: 1px solid rgba(255,255,255,0.12);
    background: rgba(0,0,0,0.2);
}

.brand {
    font-size: 28px;
    font-weight: 900;
    letter-spacing: 5px;
    color: #d8b56d;
}

.brand span {
    display: block;
    color: #ddd;
    font-size: 10px;
    letter-spacing: 2px;
    font-weight: 500;
}

main {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 40px 20px;
}

.register-card {
    width: 100%;
    max-width: 460px;
    padding: 38px;
    background: rgba(15, 15, 15, 0.76);
    border: 1px solid rgba(216,181,109,0.35);
    border-radius: 18px;
    box-shadow: 0 25px 70px rgba(0,0,0,0.45);
    backdrop-filter: blur(12px);
    transition: transform 0.3s, border-color 0.3s;
}

.register-card:hover {
    transform: translateY(-4px);
    border-color: #d8b56d;
}

.eyebrow {
    color: #d8b56d;
    font-size: 11px;
    letter-spacing: 3px;
    font-weight: bold;
    text-transform: uppercase;
}

h1 {
    font-size: 32px;
    margin: 12px 0;
}

.subtitle {
    color: #c5c5c5;
    font-size: 14px;
    line-height: 1.6;
    margin-bottom: 26px;
}

label {
    display: block;
    font-size: 13px;
    margin-bottom: 8px;
    color: #eee;
}

input {
    width: 100%;
    padding: 13px 14px;
    margin-bottom: 18px;
    border: 1px solid #454545;
    border-radius: 7px;
    background: rgba(255,255,255,0.06);
    color: white;
    outline: none;
    font-size: 14px;
    transition: border-color 0.3s, box-shadow 0.3s;
}

input:focus {
    border-color: #d8b56d;
    box-shadow: 0 0 0 3px rgba(216,181,109,0.12);
}

input::placeholder {
    color: #999;
}

button {
    width: 100%;
    padding: 14px;
    border: none;
    border-radius: 7px;
    background: #d8b56d;
    color: #111;
    font-size: 14px;
    font-weight: 800;
    cursor: pointer;
    transition: background 0.3s, transform 0.3s;
}

button:hover {
    background: #f0d397;
    transform: translateY(-2px);
}

.message {
    min-height: 18px;
    color: #ffb5a9;
    font-size: 12px;
    margin: -8px 0 14px;
}

.success-message {
    color: #d8b56d;
    text-align: center;
    font-size: 13px;
    margin-bottom: 18px;
}

.login-link {
    text-align: center;
    margin-top: 22px;
    font-size: 13px;
    color: #c5c5c5;
}

a {
    color: #e6c77f;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

.home-link {
    text-align: center;
    margin-top: 15px;
    font-size: 13px;
}

footer {
    padding: 18px;
    text-align: center;
    color: #aaa;
    font-size: 11px;
    letter-spacing: 1px;
}

@media (max-width: 480px) {
    .register-card {
        padding: 26px 22px;
    }

    h1 {
        font-size: 27px;
    }
}
</style>
</head>

<body>

<header class="navbar">
    <div class="brand">
        ARK
        <span>PREMIUM VEHICLE RENTALS</span>
    </div>
</header>

<main>

    <section class="register-card">

        <div class="eyebrow">Welcome to ARK</div>

        <h1>Create Account</h1>

        <p class="subtitle">
            Create your account to discover vehicles and
            begin your next journey.
        </p>

        <% if ("1".equals(request.getParameter("registered"))) { %>
            <p class="success-message">
                Account created successfully! Please sign in.
            </p>
        <% } %>

        <form id="registerForm"
              action="<%= context %>/RegisterServlet"
              method="post">

            <label for="fullName">Full Name</label>

            <input
                type="text"
                id="fullName"
                name="fullName"
                placeholder="Enter your full name"
                autocomplete="name"
                required
                maxlength="100">

            <label for="email">Email Address</label>

            <input
                type="email"
                id="email"
                name="email"
                placeholder="Enter your email address"
                autocomplete="email"
                required
                maxlength="150">

            <label for="password">Password</label>

            <input
                type="password"
                id="password"
                name="password"
                placeholder="Create a strong password"
                autocomplete="new-password"
                required
                minlength="8"
                maxlength="72">

            <label for="confirmPassword">Confirm Password</label>

            <input
                type="password"
                id="confirmPassword"
                name="confirmPassword"
                placeholder="Re-enter your password"
                autocomplete="new-password"
                required
                minlength="8"
                maxlength="72">

            <div class="message"
                 id="formMessage"
                 aria-live="polite"></div>

            <button type="submit">
                CREATE ACCOUNT &rarr;
            </button>

        </form>

        <div class="login-link">
            Already have an account?
            <a href="<%= context %>/login.jsp">Sign in</a>
        </div>

        <div class="home-link">
            <a href="<%= context %>/index.jsp">
                Back to home
            </a>
        </div>

    </section>

</main>

<footer>
    EXPERIENCE THE DIFFERENCE | ARK VEHICLE RENTALS
</footer>

<script>
document.getElementById("registerForm").addEventListener(
    "submit", function(event) {

        const email =
            document.getElementById("email").value.trim();

        const password =
            document.getElementById("password").value;

        const confirmPassword =
            document.getElementById("confirmPassword").value;

        const message =
            document.getElementById("formMessage");

        message.textContent = "";

        if (email.length > 150) {
            event.preventDefault();
            message.textContent =
                "Email address is too long.";
            return;
        }

        if (password.length < 8 || password.length > 72) {
            event.preventDefault();
            message.textContent =
                "Password must be between 8 and 72 characters.";
            return;
        }

        if (password !== confirmPassword) {
            event.preventDefault();
            message.textContent =
                "Passwords do not match.";
            return;
        }
    }
);
</script>

</body>
</html>