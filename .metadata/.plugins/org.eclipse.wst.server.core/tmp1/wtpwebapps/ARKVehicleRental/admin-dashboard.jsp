
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("adminName");

    int vehicleCount = 0;
    int userCount = 0;
    int bookingCount = 0;
    int paymentCount = 0;

    String dbUrl = "jdbc:oracle:thin:@localhost:1521:XE";
    String dbUser = "ARK";
    String dbPassword = "Ark12345";

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        try (Connection con = DriverManager.getConnection(
                dbUrl, dbUser, dbPassword);
             Statement st = con.createStatement()) {

            try (ResultSet rs = st.executeQuery(
                    "SELECT COUNT(*) FROM ARK_VEHICLES")) {
                if (rs.next()) vehicleCount = rs.getInt(1);
            }

            try (ResultSet rs = st.executeQuery(
                    "SELECT COUNT(*) FROM ARK_USERS")) {
                if (rs.next()) userCount = rs.getInt(1);
            }

            try (ResultSet rs = st.executeQuery(
                    "SELECT COUNT(*) FROM ARK_BOOKINGS")) {
                if (rs.next()) bookingCount = rs.getInt(1);
            }

            try (ResultSet rs = st.executeQuery(
                    "SELECT COUNT(*) FROM ARK_PAYMENTS")) {
                if (rs.next()) paymentCount = rs.getInt(1);
            }
        }
    } catch (Exception e) {
        application.log("Unable to load admin dashboard counts.", e);
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>ARK | Admin Dashboard</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    background: #0b0b0b;
    color: #f5f5f5;
    font-family: Arial, sans-serif;
}

.sidebar {
    width: 250px;
    height: 100vh;
    position: fixed;
    left: 0;
    top: 0;
    background: #141414;
    border-right: 1px solid #30291a;
    padding: 30px 18px;
}

.logo {
    text-align: center;
    color: #d4af37;
    font-size: 30px;
    font-weight: bold;
    letter-spacing: 5px;
    margin-bottom: 8px;
}

.sidebar-subtitle {
    text-align: center;
    color: #777;
    font-size: 10px;
    letter-spacing: 2px;
    margin-bottom: 40px;
}

.nav-link {
    display: block;
    color: #bbb;
    text-decoration: none;
    padding: 14px 15px;
    border-radius: 8px;
    margin-bottom: 9px;
    transition: 0.2s;
}

.nav-link:hover,
.nav-link.active {
    background: #292315;
    color: #e5c75c;
}

.logout {
    position: absolute;
    bottom: 25px;
    left: 18px;
    right: 18px;
    border: 1px solid #493b24;
}

.main {
    margin-left: 250px;
    padding: 35px;
}

.topbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    flex-wrap: wrap;
    margin-bottom: 40px;
}

.topbar h1 {
    font-size: 28px;
    margin-bottom: 8px;
}

.muted {
    color: #929292;
    font-size: 14px;
}

.admin-badge {
    border: 1px solid #675326;
    background: #211c10;
    color: #e6c85b;
    border-radius: 30px;
    padding: 11px 17px;
    font-size: 13px;
}

.welcome {
    background: linear-gradient(120deg, #211d13, #151515 75%);
    border: 1px solid #493b22;
    border-radius: 15px;
    padding: 30px;
    margin-bottom: 30px;
}

.welcome h2 {
    color: #e5c75c;
    margin-bottom: 12px;
}

.welcome p {
    color: #bbb;
    line-height: 1.7;
}

.section-title {
    margin-bottom: 20px;
    font-size: 20px;
}

.stats {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 18px;
    margin-bottom: 40px;
}

.stat-card {
    background: #171717;
    border: 1px solid #303030;
    border-radius: 13px;
    padding: 24px;
    transition: 0.2s;
}

.stat-card:hover {
    border-color: #a88b36;
    transform: translateY(-3px);
}

.stat-label {
    color: #aaa;
    font-size: 14px;
    margin-bottom: 18px;
}

.stat-number {
    font-size: 34px;
    font-weight: bold;
    color: #e4c65b;
}

.management-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 20px;
}

.management-card {
    display: block;
    text-decoration: none;
    color: white;
    background: #171717;
    border: 1px solid #333;
    border-radius: 13px;
    padding: 25px;
    transition: 0.2s;
}

.management-card:hover {
    border-color: #d4af37;
    background: #1c1a15;
    transform: translateY(-3px);
}

.management-card h3 {
    color: #e5c75c;
    margin-bottom: 12px;
}

.management-card p {
    color: #aaa;
    font-size: 14px;
    line-height: 1.6;
}

.arrow {
    display: block;
    text-align: right;
    color: #d4af37;
    font-size: 22px;
    margin-top: 12px;
}

.footer {
    color: #666;
    font-size: 12px;
    text-align: center;
    margin-top: 45px;
}

@media (max-width: 1100px) {
    .stats {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}

@media (max-width: 700px) {
    .sidebar {
        width: 100%;
        height: auto;
        position: static;
        border-right: none;
        border-bottom: 1px solid #30291a;
    }

    .sidebar-subtitle {
        margin-bottom: 20px;
    }

    .logout {
        position: static;
        margin-top: 15px;
    }

    .main {
        margin-left: 0;
        padding: 22px;
    }

    .management-grid,
    .stats {
        grid-template-columns: 1fr;
    }
}
</style>
</head>

<body>
<jsp:include page="/navbar.jsp" />

<aside class="sidebar">

    <div class="logo">ARK</div>
    <div class="sidebar-subtitle">ADMIN CONTROL PANEL</div>

    <a class="nav-link active"
       href="<%= request.getContextPath() %>/admin-dashboard.jsp">
       Dashboard
    </a>

    <a class="nav-link"
       href="<%= request.getContextPath() %>/admin-vehicles.jsp">
       Manage Vehicles
    </a>

    <a class="nav-link"
       href="<%= request.getContextPath() %>/admin-users.jsp">
       Manage Customers
    </a>

    <a class="nav-link"
       href="<%= request.getContextPath() %>/admin-bookings.jsp">
       Manage Bookings
    </a>

    <a class="nav-link"
       href="<%= request.getContextPath() %>/admin-payments.jsp">
       Demo Payments
    </a>

    <a class="nav-link"
       href="<%= request.getContextPath() %>/index.jsp">
       View Website
    </a>

    <a class="nav-link logout"
       href="<%= request.getContextPath() %>/AdminLogoutServlet">
       Logout
    </a>

</aside>

<main class="main">

    <header class="topbar">
        <div>
            <h1>Admin Dashboard</h1>
            <p class="muted">Manage your vehicle rental business.</p>
        </div>

        <div class="admin-badge">
            Administrator: <%= adminName == null ? "Admin" : adminName %>
        </div>
    </header>

    <section class="welcome">
        <h2>Welcome to ARK Control Center</h2>
        <p>
            Manage your vehicles, customers, bookings, and demo payment
            records from one place. Changes made here will connect to
            your Oracle database.
        </p>
    </section>

    <h2 class="section-title">Database Overview</h2>

    <section class="stats">

        <div class="stat-card">
            <div class="stat-label">Total Vehicles</div>
            <div class="stat-number"><%= vehicleCount %></div>
        </div>

        <div class="stat-card">
            <div class="stat-label">Registered Customers</div>
            <div class="stat-number"><%= userCount %></div>
        </div>

        <div class="stat-card">
            <div class="stat-label">Total Bookings</div>
            <div class="stat-number"><%= bookingCount %></div>
        </div>

        <div class="stat-card">
            <div class="stat-label">Demo Payments</div>
            <div class="stat-number"><%= paymentCount %></div>
        </div>

    </section>

    <h2 class="section-title">Management Sections</h2>

    <section class="management-grid">

        <a class="management-card"
           href="<%= request.getContextPath() %>/admin-vehicles.jsp">
            <h3>Vehicle Management</h3>
            <p>Add new cars, edit vehicle details and rental prices,
               view inventory, and delete eligible vehicles.</p>
            <span class="arrow">→</span>
        </a>

        <a class="management-card"
           href="<%= request.getContextPath() %>/admin-users.jsp">
            <h3>Customer Management</h3>
            <p>View registered customer accounts and inspect their
               account details.</p>
            <span class="arrow">→</span>
        </a>

        <a class="management-card"
           href="<%= request.getContextPath() %>/admin-bookings.jsp">
            <h3>Booking Management</h3>
            <p>Review rental bookings and manage permitted booking
               status changes.</p>
            <span class="arrow">→</span>
        </a>

        <a class="management-card"
           href="<%= request.getContextPath() %>/admin-payments.jsp">
            <h3>Demo Payment Records</h3>
            <p>View recorded payment methods, amounts, dates,
               and demo-only transaction statuses.</p>
            <span class="arrow">→</span>
        </a>

    </section>

    <div class="footer">
        ARK Vehicle Rentals · Administration Portal
    </div>

</main>

</body>
</html>
