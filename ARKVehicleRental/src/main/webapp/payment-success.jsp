
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String bookingId = request.getParameter("bookingId");
    String paymentMethod = request.getParameter("method");

    if (bookingId == null || !bookingId.matches("\\d+")
            || paymentMethod == null
            || !paymentMethod.matches("upi|card|netbanking")) {
        response.sendRedirect(request.getContextPath() + "/my-bookings.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Payment Confirmation | ARK Rentals</title>
<style>
* { box-sizing: border-box; }

body {
    margin: 0;
    background: #101010;
    color: #f5f5f5;
    font-family: Arial, sans-serif;
    min-height: 100vh;
    display: grid;
    place-items: center;
    padding: 24px;
}

.card {
    width: min(540px, 100%);
    padding: 42px 32px;
    background: #1b1b1b;
    border: 1px solid #353535;
    border-radius: 18px;
    text-align: center;
}

.brand {
    color: #d8b15a;
    font-size: 24px;
    font-weight: bold;
    letter-spacing: 2px;
}

.check {
    width: 76px;
    height: 76px;
    margin: 28px auto 20px;
    display: grid;
    place-items: center;
    border: 2px solid #d8b15a;
    border-radius: 50%;
    color: #d8b15a;
    font-size: 38px;
}

h1 {
    font-size: 30px;
    margin-bottom: 12px;
}

p {
    color: #aaa;
    line-height: 1.7;
}

.details {
    margin: 26px 0;
    padding: 18px;
    background: #141414;
    border: 1px solid #333;
    border-radius: 10px;
    text-align: left;
}

.row {
    display: flex;
    justify-content: space-between;
    gap: 16px;
    padding: 10px 0;
}

.row span:first-child { color: #aaa; }

.row strong {
    color: #d8b15a;
    overflow-wrap: anywhere;
}

.notice {
    font-size: 12px;
    color: #e5c987;
}

.btn {
    display: inline-block;
    margin-top: 16px;
    padding: 14px 24px;
    border-radius: 8px;
    background: linear-gradient(135deg, #e6c477, #bd913d);
    color: #151515;
    text-decoration: none;
    font-weight: bold;
}

.btn:hover { filter: brightness(1.1); }
</style>
</head>
<body>
<main class="card">
    <div class="brand">ARK RENTALS</div>

    <div class="check" aria-hidden="true">✓</div>

    <h1>Payment Demo Complete</h1>
    <p>
        This is a demonstration confirmation screen.
        No real payment has been processed.
    </p>

    <div class="details">
        <div class="row">
            <span>Booking ID</span>
            <strong>#<%= bookingId %></strong>
        </div>
        <div class="row">
            <span>Selected Method</span>
            <strong>
                <%= "upi".equals(paymentMethod) ? "UPI"
                    : "card".equals(paymentMethod) ? "Credit / Debit Card"
                    : "Net Banking" %>
            </strong>
        </div>
        <div class="row">
            <span>Payment Status</span>
            <strong>DEMO ONLY</strong>
        </div>
    </div>

    <p class="notice">
        Your booking has not been marked as paid.
    </p>

    <a class="btn"
       href="<%= request.getContextPath() %>/my-bookings.jsp">
        Return to My Bookings
    </a>
</main>
</body>
</html>
