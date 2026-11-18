
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    List<Map<String, Object>> customers =
        (List<Map<String, Object>>) request.getAttribute("customers");

    String search = (String) request.getAttribute("search");

    if (search == null) {
        search = "";
    }

    String safeSearch = search.replace("&", "&amp;")
                              .replace("<", "&lt;")
                              .replace(">", "&gt;")
                              .replace("\"", "&quot;")
                              .replace("'", "&#39;");

    String adminName = (String) session.getAttribute("adminName");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Customer Management | ARK Vehicle Rentals</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    background: #101010;
    color: #f5f5f5;
    min-height: 100vh;
}

:root {
    --gold: #d4af37;
    --gold-light: #f1d879;
    --panel: #1b1b1b;
    --border: #353535;
    --muted: #a5a5a5;
}

.navbar {
    min-height: 76px;
    padding: 18px 5%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 16px;
    flex-wrap: wrap;
    background: #080808;
    border-bottom: 1px solid var(--border);
}

.brand {
    color: var(--gold);
    font-size: 23px;
    font-weight: 800;
    letter-spacing: 2px;
}

.nav-links {
    display: flex;
    align-items: center;
    gap: 20px;
    flex-wrap: wrap;
}

.nav-links a {
    color: #eee;
    text-decoration: none;
    font-size: 14px;
}

.nav-links a:hover {
    color: var(--gold);
}

.container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 38px 5%;
}

.heading {
    margin-bottom: 28px;
}

.heading h1 {
    color: var(--gold);
    font-size: clamp(25px, 4vw, 34px);
    margin-bottom: 10px;
}

.heading p {
    color: var(--muted);
    line-height: 1.6;
}

.summary {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 18px;
    flex-wrap: wrap;
    margin-bottom: 24px;
}

.stat-card {
    background: var(--panel);
    border: 1px solid var(--border);
    border-left: 4px solid var(--gold);
    border-radius: 10px;
    padding: 20px 24px;
    min-width: 210px;
}

.stat-card p {
    color: var(--muted);
    font-size: 13px;
    margin-bottom: 10px;
}

.stat-card h2 {
    color: var(--gold-light);
    font-size: 29px;
}

.panel {
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: 12px;
    padding: 24px;
    margin-bottom: 24px;
}

.panel h2 {
    font-size: 19px;
    margin-bottom: 18px;
}

.search-form {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
}

.search-form input {
    flex: 1;
    min-width: 220px;
    background: #101010;
    border: 1px solid #444;
    border-radius: 7px;
    padding: 13px 15px;
    color: white;
    outline: none;
}

.search-form input:focus {
    border-color: var(--gold);
}

.btn {
    display: inline-block;
    padding: 12px 18px;
    border-radius: 7px;
    text-decoration: none;
    border: none;
    cursor: pointer;
    font-size: 14px;
    font-weight: bold;
    text-align: center;
}

.btn-gold {
    background: var(--gold);
    color: #111;
}

.btn-gold:hover {
    background: var(--gold-light);
}

.btn-outline {
    background: transparent;
    border: 1px solid var(--gold);
    color: var(--gold);
}

.btn-outline:hover {
    background: var(--gold);
    color: #111;
}

.table-wrapper {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 720px;
}

thead {
    background: #252525;
}

th, td {
    text-align: left;
    padding: 16px 14px;
    border-bottom: 1px solid var(--border);
    font-size: 14px;
}

th {
    color: var(--gold-light);
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 0.7px;
}

td {
    color: #e5e5e5;
}

tbody tr:hover {
    background: #222;
}

.customer-id {
    color: var(--gold);
    font-weight: bold;
}

.role {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 20px;
    background: #292619;
    color: var(--gold-light);
    font-size: 12px;
    text-transform: capitalize;
}

.empty {
    text-align: center;
    color: var(--muted);
    padding: 36px 15px;
}

.footer {
    text-align: center;
    padding: 25px;
    color: #777;
    border-top: 1px solid var(--border);
    font-size: 12px;
}

@media (max-width: 600px) {
    .container {
        padding: 26px 4%;
    }

    .panel {
        padding: 16px;
    }

    .navbar {
        padding: 18px 4%;
    }
}
</style>
</head>

<body>
<jsp:include page="/navbar.jsp" />

<header class="navbar">
    <div class="brand">ARK <span style="color:#fff;">ADMIN</span></div>

    <nav class="nav-links">
        <a href="<%= request.getContextPath() %>/admin-dashboard.jsp">Dashboard</a>
        <a href="<%= request.getContextPath() %>/admin-vehicles.jsp">Vehicles</a>
        <a href="<%= request.getContextPath() %>/AdminUsersServlet">Customers</a>
        <a href="<%= request.getContextPath() %>/AdminLogoutServlet">Logout</a>
    </nav>
</header>

<main class="container">

    <section class="heading">
        <h1>Customer Management</h1>
        <p>
            Welcome, <%= adminName == null ? "Admin" :
                adminName.replace("&", "&amp;")
                         .replace("<", "&lt;")
                         .replace(">", "&gt;") %>.
            View and search registered ARK Vehicle Rentals customers.
        </p>
    </section>

    <section class="summary">
        <div class="stat-card">
            <p>
                <%= safeSearch.isEmpty() ?
                    "Registered Customers" : "Matching Customers" %>
            </p>
            <h2><%= customers == null ? 0 : customers.size() %></h2>
        </div>
    </section>

    <section class="panel">
        <h2>Search Customers</h2>

        <form class="search-form"
              action="<%= request.getContextPath() %>/AdminUsersServlet"
              method="get">

            <input type="search"
                   name="search"
                   value="<%= safeSearch %>"
                   placeholder="Search by name, email or customer ID">

            <button type="submit" class="btn btn-gold">
                Search
            </button>

            <a class="btn btn-outline"
               href="<%= request.getContextPath() %>/AdminUsersServlet">
                Reset
            </a>
        </form>
    </section>

    <section class="panel">
        <h2>Customer Records</h2>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Customer ID</th>
                        <th>Full Name</th>
                        <th>Email Address</th>
                        <th>Role</th>
                        <th>Registration Date</th>
                    </tr>
                </thead>

                <tbody>
                <% if (customers == null || customers.isEmpty()) { %>
                    <tr>
                        <td colspan="5" class="empty">
                            No customers found. Try another search.
                        </td>
                    </tr>
                <% } else {
                       for (Map<String, Object> customer : customers) {
                           Object name = customer.get("fullName");
                           Object email = customer.get("email");
                           Object role = customer.get("role");
                           Object createdAt = customer.get("createdAt");

                           String safeName = name == null ? "" :
                               name.toString().replace("&", "&amp;")
                                              .replace("<", "&lt;")
                                              .replace(">", "&gt;")
                                              .replace("\"", "&quot;")
                                              .replace("'", "&#39;");

                           String safeEmail = email == null ? "" :
                               email.toString().replace("&", "&amp;")
                                                .replace("<", "&lt;")
                                                .replace(">", "&gt;")
                                                .replace("\"", "&quot;")
                                                .replace("'", "&#39;");

                           String safeRole = role == null ? "Customer" :
                               role.toString().replace("&", "&amp;")
                                              .replace("<", "&lt;")
                                              .replace(">", "&gt;");
                %>
                    <tr>
                        <td class="customer-id">
                            #<%= customer.get("userId") %>
                        </td>

                        <td><%= safeName %></td>

                        <td><%= safeEmail %></td>

                        <td>
                            <span class="role"><%= safeRole %></span>
                        </td>

                        <td>
                            <%= createdAt == null ? "—" : createdAt %>
                        </td>
                    </tr>
                <%     }
                   }
                %>
                </tbody>
            </table>
        </div>
    </section>

</main>

<footer class="footer">
    ARK VEHICLE RENTALS &copy; 2026 | CUSTOMER MANAGEMENT
</footer>

</body>
</html>
