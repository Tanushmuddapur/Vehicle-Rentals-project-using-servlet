
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String bookingId = request.getParameter("bookingId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Payment | ARK Rentals</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    background: #101010;
    color: #f5f5f5;
    font-family: Arial, sans-serif;
}

.navbar {
    min-height: 82px;
    padding: 22px 7%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #191919;
    border-bottom: 1px solid #333;
}

.brand {
    color: #d8b15a;
    font-size: 27px;
    font-weight: bold;
    letter-spacing: 1px;
}

.navbar a {
    color: #f5f5f5;
    text-decoration: none;
    margin-left: 22px;
}

.navbar a:hover {
    color: #d8b15a;
}

.container {
    width: min(900px, 90%);
    margin: 55px auto;
}

.eyebrow {
    color: #d8b15a;
    letter-spacing: 4px;
    font-size: 13px;
}

h1 {
    font-size: 38px;
    margin: 12px 0;
}

.subtitle {
    color: #aaa;
    line-height: 1.6;
}

.payment-layout {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 24px;
    margin-top: 32px;
}

.card {
    background: #1b1b1b;
    border: 1px solid #353535;
    border-radius: 14px;
    padding: 26px;
}

.card h2 {
    font-size: 20px;
    margin-top: 0;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    gap: 12px;
    padding: 16px 0;
    border-bottom: 1px solid #333;
}

.muted {
    color: #aaa;
}

.total {
    color: #d8b15a;
    font-size: 22px;
    font-weight: bold;
}

.payment-option {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 16px;
    margin-top: 14px;
    border: 1px solid #444;
    border-radius: 10px;
    cursor: pointer;
    transition: border-color 0.2s;
}

.payment-option:hover {
    border-color: #d8b15a;
}

.payment-option input {
    accent-color: #d8b15a;
}

.option-title {
    font-weight: bold;
}

.option-description {
    color: #aaa;
    font-size: 13px;
    margin-top: 5px;
}

.pay-button {
    width: 100%;
    border: none;
    border-radius: 8px;
    padding: 15px;
    margin-top: 24px;
    background: linear-gradient(135deg, #e6c477, #bd913d);
    color: #151515;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
}

.pay-button:hover {
    filter: brightness(1.08);
}

.notice {
    color: #aaa;
    font-size: 12px;
    line-height: 1.6;
    margin-top: 16px;
}

@media (max-width: 650px) {
    .navbar {
        padding: 18px 5%;
        flex-wrap: wrap;
        gap: 16px;
    }

    .brand {
        font-size: 22px;
    }

    .navbar a {
        margin-left: 0;
        margin-right: 14px;
    }

    .payment-layout {
        grid-template-columns: 1fr;
    }

    h1 {
        font-size: 31px;
    }
}
</style>
</head>

<body>
<jsp:include page="/navbar.jsp" />

<header class="navbar">
    <div class="brand">ARK RENTALS</div>
    <nav>
        <a href="<%= request.getContextPath() %>/vehicles.jsp">Vehicles</a>
        <a href="<%= request.getContextPath() %>/my-bookings.jsp">My Bookings</a>
    </nav>
</header>

<main class="container">
    <div class="eyebrow">SECURE CHECKOUT</div>
    <h1>Complete Your Payment</h1>
    <p class="subtitle">
        Review your reservation and choose your preferred payment method.
    </p>

    <div class="payment-layout">
        <section class="card">
            <h2>Booking Summary</h2>
            
<%
    String vehicleName = "";
    String startDate = "";
    String endDate = "";
    String totalAmount = "";
    boolean bookingFound = false;

    if (bookingId != null && bookingId.matches("\\d+")) {
        String bookingSql =
            "SELECT v.VEHICLE_NAME, b.START_DATE, b.END_DATE, " +
            "b.TOTAL_AMOUNT, b.BOOKING_STATUS " +
            "FROM ARK_BOOKINGS b " +
            "JOIN ARK_VEHICLES v ON b.VEHICLE_ID = v.VEHICLE_ID " +
            "WHERE b.BOOKING_ID = ? AND b.USER_ID = ?";

        try (
            java.sql.Connection con = java.sql.DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521/XE", "ARK", "Ark12345");
            java.sql.PreparedStatement ps = con.prepareStatement(bookingSql)
        ) {
            ps.setInt(1, Integer.parseInt(bookingId));
            ps.setInt(2, Integer.parseInt(
                session.getAttribute("userId").toString()));

            try (java.sql.ResultSet rs = ps.executeQuery()) {
            	if (rs.next()
            		    && ("PENDING".equalsIgnoreCase(rs.getString("BOOKING_STATUS"))
            		        || "CONFIRMED".equalsIgnoreCase(rs.getString("BOOKING_STATUS")))) {
                    bookingFound = true;
                    vehicleName = rs.getString("VEHICLE_NAME");
                    startDate = rs.getDate("START_DATE").toString();
                    endDate = rs.getDate("END_DATE").toString();
                    totalAmount = rs.getBigDecimal("TOTAL_AMOUNT")
                        .toPlainString();
                }
            }
        } catch (Exception e) {
            application.log("Unable to load payment details", e);
        }
    }
%>

<% if (bookingFound) { %>
    <div class="summary-row">
        <span class="muted">Booking ID</span>
        <strong>#<%= bookingId %></strong>
    </div>

    <div class="summary-row">
        <span class="muted">Vehicle</span>
        <strong><%= vehicleName %></strong>
    </div>

    <div class="summary-row">
        <span class="muted">Pickup Date</span>
        <strong><%= startDate %></strong>
    </div>

    <div class="summary-row">
        <span class="muted">Return Date</span>
        <strong><%= endDate %></strong>
    </div>

    <div class="summary-row">
        <span class="muted">Payment status</span>
        <span>Pending</span>
    </div>

    <div class="summary-row">
        <span class="muted">Total Amount</span>
        <strong class="total">&#8377;<%= totalAmount %></strong>
    </div>
<% } else { %>
    <p class="notice">
        Booking not found or unavailable for payment.
        Please select a confirmed booking from My Bookings.
    </p>
<% } %>
            

            <div class="summary-row">
                <span class="muted">Booking ID</span>
                <strong>
                    <%= bookingId == null || bookingId.isBlank()
                        ? "Not selected" : "#" + bookingId %>
                </strong>
            </div>

            <div class="summary-row">
                <span class="muted">Payment status</span>
                <span>Pending</span>
            </div>

            <p class="notice">
                Your booking details and final amount should be loaded
                from your saved reservation before payment is enabled.
            </p>
        </section>

        <section class="card">
            <h2>Payment Method</h2>

            <form id="paymentForm">
                <label class="payment-option">
                    <input type="radio" name="paymentMethod"
                           value="upi" required>
                    <div>
                        <div class="option-title">UPI</div>
                        <div class="option-description">
                            Pay using a supported UPI app
                        </div>
                    </div>
                </label>

                <label class="payment-option">
                    <input type="radio" name="paymentMethod"
                           value="card">
                    <div>
                        <div class="option-title">Credit / Debit Card</div>
                        <div class="option-description">
                            Card payment through a payment provider
                        </div>
                    </div>
                </label>

                <label class="payment-option">
                    <input type="radio" name="paymentMethod"
                           value="netbanking">
                    <div>
                        <div class="option-title">Net Banking</div>
                        <div class="option-description">
                            Pay through your bank
                        </div>
                    </div>
                </label>

<button type="submit" class="pay-button">
    Continue to Payment
</button>

                <p class="notice">
                    UI preview only. No payment will be collected or processed.
                </p>
            </form>
        </section>
    </div>
</main>

<script>


document.getElementById("paymentForm").addEventListener(
    "submit", function(event) {
        event.preventDefault();

        const selected = document.querySelector(
            'input[name="paymentMethod"]:checked'
        );

        if (!selected) {
            alert("Please select a payment method.");
            return;
        }

        const params = new URLSearchParams(window.location.search);
        const bookingId = params.get("bookingId");

        if (!bookingId || !/^\d+$/.test(bookingId)) {
            alert("Invalid booking. Please return to My Bookings.");
            return;
        }

        const form = document.createElement("form");
        form.method = "POST";
        form.action = "<%= request.getContextPath() %>/DemoPaymentServlet";

        const fields = {
            bookingId: bookingId,
            method: selected.value
        };

        for (const [name, value] of Object.entries(fields)) {
            const input = document.createElement("input");
            input.type = "hidden";
            input.name = name;
            input.value = value;
            form.appendChild(input);
        }

        document.body.appendChild(form);
        form.submit();
    }
);


</script>
</body>
</html>
