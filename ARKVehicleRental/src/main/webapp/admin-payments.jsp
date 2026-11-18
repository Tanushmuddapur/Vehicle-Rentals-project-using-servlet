
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    List<Map<String, Object>> payments =
        (List<Map<String, Object>>) request.getAttribute("payments");

    String search = (String) request.getAttribute("search");

    if (search == null) search = "";

    String safeSearch = search.replace("&", "&amp;")
                              .replace("<", "&lt;")
                              .replace(">", "&gt;")
                              .replace("\"", "&quot;")
                              .replace("'", "&#39;");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Demo Payments | ARK Vehicle Rentals</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

:root {
    --gold: #d4af37;
    --gold-light: #f1d879;
    --bg: #101010;
    --panel: #1b1b1b;
    --border: #353535;
    --muted: #a5a5a5;
}

body {
    font-family: Arial, sans-serif;
    background: var(--bg);
    color: #f5f5f5;
    min-height: 100vh;
}

.navbar {
    min-height: 76px;
    padding: 18px 5%;
    display: flex;
    align-items: center;
    justify-content: space-between;
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
    max-width: 1450px;
    margin: auto;
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

.notice {
    background: #292619;
    border: 1px solid #6e5a1b;
    color: var(--gold-light);
    padding: 15px 18px;
    border-radius: 9px;
    margin-bottom: 24px;
    line-height: 1.6;
    font-size: 13px;
}

.stat-card {
    background: var(--panel);
    border: 1px solid var(--border);
    border-left: 4px solid var(--gold);
    border-radius: 10px;
    padding: 20px 24px;
    margin-bottom: 24px;
    display: inline-block;
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
    border: none;
    cursor: pointer;
    text-decoration: none;
    text-align: center;
    font-size: 14px;
    font-weight: bold;
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
    min-width: 950px;
    border-collapse: collapse;
}

thead {
    background: #252525;
}

th, td {
    padding: 16px 14px;
    border-bottom: 1px solid var(--border);
    text-align: left;
    font-size: 13px;
    vertical-align: middle;
}

th {
    color: var(--gold-light);
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: .5px;
}

tbody tr:hover {
    background: #222;
}

.payment-id {
    color: var(--gold);
    font-weight: bold;
}

.customer-name {
    font-weight: bold;
    margin-bottom: 5px;
}

.email {
    color: var(--muted);
    font-size: 12px;
    overflow-wrap: anywhere;
}

.method {
    text-transform: capitalize;
}

.amount {
    white-space: nowrap;
    font-weight: bold;
}

.status {
    display: inline-block;
    padding: 7px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: bold;
    white-space: nowrap;
}

.demo-status {
    background: #292619;
    color: var(--gold-light);
    border: 1px solid #6e5a1b;
}

.empty {
    padding: 35px;
    text-align: center;
    color: var(--muted);
}

.footer {
    text-align: center;
    padding: 25px;
    color: #777;
    border-top: 1px solid var(--border);
    font-size: 12px;
}

@media (max-width: 600px) {
    .navbar {
        padding: 18px 4%;
    }

    .container {
        padding: 26px 4%;
    }

    .panel {
        padding: 16px;
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
        <a href="<%= request.getContextPath() %>/AdminBookingsServlet">Bookings</a>
        <a href="<%= request.getContextPath() %>/AdminPaymentsServlet">Payments</a>
        <a href="<%= request.getContextPath() %>/AdminLogoutServlet">Logout</a>
    </nav>
</header>

<main class="container">

    <section class="heading">
        <h1>Demo Payment Management</h1>
        <p>Review payment records generated by the ARK Vehicle Rentals demo checkout.</p>
    </section>

    <div class="notice">
        <strong>DEMO MODE ONLY:</strong>
        These records are for academic project testing. No real money is
        collected or transferred. A demo record must not be treated as a
        successful real-world payment.
    </div>

    <section class="stat-card">
        <p>Matching Payment Records</p>
        <h2><%= payments == null ? 0 : payments.size() %></h2>
    </section>

    <section class="panel">
        <h2>Search Payment Records</h2>

        <form class="search-form"
              action="<%= request.getContextPath() %>/AdminPaymentsServlet"
              method="get">

            <input type="search"
                   name="search"
                   value="<%= safeSearch %>"
                   placeholder="Payment ID, booking ID, customer or email">

            <button type="submit" class="btn btn-gold">Search</button>

            <a class="btn btn-outline"
               href="<%= request.getContextPath() %>/AdminPaymentsServlet">
                Reset
            </a>
        </form>
    </section>

    <section class="panel">
        <h2>Payment Records</h2>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Payment ID</th>
                        <th>Booking ID</th>
                        <th>Customer</th>
                        <th>Method</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Payment Date</th>
                    </tr>
                </thead>

                <tbody>
                <% if (payments == null || payments.isEmpty()) { %>
                    <tr>
                        <td colspan="7" class="empty">
                            No payment records found. Complete a demo checkout
                            or try another search.
                        </td>
                    </tr>
                <% } else {
                    for (Map<String, Object> p : payments) {
                        Object customer = p.get("customerName");
                        Object email = p.get("email");
                        Object method = p.get("method");
                        Object amount = p.get("amount");
                        Object status = p.get("status");
                        Object paymentDate = p.get("paymentDate");

                        String safeCustomer = customer == null ? "" :
                            customer.toString().replace("&", "&amp;")
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

                        String safeMethod = method == null ? "—" :
                            method.toString().replace("&", "&amp;")
                                             .replace("<", "&lt;")
                                             .replace(">", "&gt;");

                        String safeStatus = status == null ? "UNKNOWN" :
                            status.toString().replace("&", "&amp;")
                                              .replace("<", "&lt;")
                                              .replace(">", "&gt;");
                %>
                    <tr>
                        <td class="payment-id">
                            #<%= p.get("paymentId") %>
                        </td>

                        <td>#<%= p.get("bookingId") %></td>

                        <td>
                            <div class="customer-name"><%= safeCustomer %></div>
                            <div class="email"><%= safeEmail %></div>
                        </td>

                        <td class="method"><%= safeMethod %></td>

                        <td class="amount">
                            &#8377;<%= amount == null ? "0.00" : amount %>
                        </td>

                        <td>
                            <span class="status demo-status">
                                <%= safeStatus %>
                            </span>
                        </td>

                        <td>
                            <%= paymentDate == null ? "—" : paymentDate %>
                        </td>
                    </tr>
                <%  }
                   }
                %>
                </tbody>
            </table>
        </div>
    </section>

</main>

<footer class="footer">
    ARK VEHICLE RENTALS &copy; 2026 | DEMO PAYMENT MANAGEMENT
</footer>

</body>
</html>
