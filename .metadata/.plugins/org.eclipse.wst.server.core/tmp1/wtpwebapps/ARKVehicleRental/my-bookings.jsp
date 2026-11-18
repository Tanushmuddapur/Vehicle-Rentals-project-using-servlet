
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.SQLException" %>

<%
if (session.getAttribute("userId") == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

int userId = Integer.parseInt(session.getAttribute("userId").toString());

String dbUrl = "jdbc:oracle:thin:@localhost:1521:XE";
String dbUser = "ARK";
String dbPassword = "Ark12345";

String sql =
    "SELECT b.BOOKING_ID, v.VEHICLE_NAME, "
  + "b.START_DATE, b.END_DATE, b.TOTAL_AMOUNT, b.BOOKING_STATUS "
  + "FROM ARK_BOOKINGS b "
  + "JOIN ARK_VEHICLES v ON b.VEHICLE_ID = v.VEHICLE_ID "
  + "WHERE b.USER_ID = ? "
  + "ORDER BY b.BOOKING_ID DESC";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Bookings | ARK Vehicle Rentals</title>

<style>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: Arial, sans-serif;
    background: #101010;
    color: #f5f5f5;
}

.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 7%;
    background: #181818;
    border-bottom: 1px solid #333;
}

.logo {
    color: #d8b56d;
    font-size: 23px;
    font-weight: bold;
    letter-spacing: 1px;
}


.pay-now-btn {
    display: inline-block;
    background: linear-gradient(135deg, #e6c477, #bd913d);
    color: #151515;
    text-decoration: none;
    padding: 10px 22px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 700;
    margin-top: 15px;
    transition: transform 0.2s ease, filter 0.2s ease;
}

.pay-now-btn:hover {
    filter: brightness(1.1);
    transform: translateY(-2px);
}


.navbar a {
    color: #ddd;
    text-decoration: none;
    margin-left: 24px;
    transition: color 0.3s;
}

.navbar a:hover,
.navbar a.active {
    color: #d8b56d;
}

.container {
    width: 86%;
    max-width: 1200px;
    margin: 55px auto;
}

.eyebrow {
    color: #d8b56d;
    letter-spacing: 3px;
    font-size: 12px;
    text-transform: uppercase;
    margin-bottom: 12px;
}

h1 {
    font-size: 36px;
    margin-bottom: 12px;
}

/* Cancel Booking Button */
.cancel-booking {
    background: linear-gradient(135deg, #dc2626, #991b1b);
    color: #ffffff;
    border: 1px solid #ef4444;
    padding: 10px 22px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    margin-top: 15px;
    box-shadow: 0 4px 12px rgba(220, 38, 38, 0.2);
}

.cancel-booking:hover {
    background: linear-gradient(135deg, #ef4444, #b91c1c);
    transform: translateY(-2px);
    box-shadow: 0 6px 18px rgba(220, 38, 38, 0.35);
}

.cancel-booking:active {
    transform: translateY(0);
}

.cancel-booking:focus-visible {
    outline: 2px solid #fca5a5;
    outline-offset: 3px;
}

.subtitle {
    color: #aaa;
    margin-bottom: 35px;
    line-height: 1.6;
}

.booking-card {
    background: #1a1a1a;
    border: 1px solid #343434;
    border-radius: 12px;
    padding: 25px;
    margin-bottom: 18px;
    transition: border-color 0.3s, transform 0.3s;
}

.booking-card:hover {
    border-color: #d8b56d;
    transform: translateY(-3px);
}

.booking-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    margin-bottom: 20px;
}

.booking-top h2 {
    font-size: 21px;
    margin-bottom: 7px;
}

.booking-id {
    color: #999;
    font-size: 13px;
}

.status {
    display: inline-block;
    padding: 7px 12px;
    border-radius: 20px;
    font-size: 12px;
    background: #263d2d;
    color: #9fe0ad;
}

.booking-details {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 20px;
}

.detail-label {
    display: block;
    color: #999;
    font-size: 12px;
    margin-bottom: 8px;
}

.detail-value {
    font-size: 15px;
    overflow-wrap: anywhere;
}

.amount {
    color: #d8b56d;
    font-weight: bold;
    font-size: 19px;
}

.empty-state {
    text-align: center;
    background: #1a1a1a;
    border: 1px solid #333;
    border-radius: 12px;
    padding: 55px 20px;
}

.empty-state h2 {
    margin-bottom: 12px;
}

.empty-state p {
    color: #aaa;
    line-height: 1.6;
    margin-bottom: 24px;
}

.gold-btn {
    display: inline-block;
    background: #d8b56d;
    color: #111;
    padding: 12px 22px;
    border-radius: 6px;
    text-decoration: none;
    font-weight: bold;
    transition: all 0.3s;
}

.gold-btn:hover {
    background: #edce8b;
    transform: translateY(-2px);
}

.error-message {
    background: #3a2020;
    border: 1px solid #8b4040;
    color: #ffbaba;
    border-radius: 8px;
    padding: 18px;
}

@media (max-width: 700px) {
    .navbar {
        align-items: flex-start;
        gap: 18px;
        flex-direction: column;
    }

    .navbar a {
        margin: 0 15px 0 0;
    }

    .container {
        width: 92%;
        margin: 35px auto;
    }

    h1 {
        font-size: 29px;
    }

    .booking-details {
        grid-template-columns: 1fr;
        gap: 16px;
    }

    .booking-top {
        align-items: flex-start;
        flex-direction: column;
    }
}
</style>
</head>

<body>
<jsp:include page="/navbar.jsp" />

<main class="container">
    <div class="eyebrow">Your Rental Journey</div>
    <h1>My Bookings</h1>
    <p class="subtitle">
        View your reservations, rental dates and booking amounts.
    </p>

    <%
    boolean found = false;

    try (Connection con = DriverManager.getConnection(
                dbUrl, dbUser, dbPassword);
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, userId);

        try (ResultSet rs = ps.executeQuery()) {
            SimpleDateFormat dateFormat =
                new SimpleDateFormat("dd MMM yyyy");

            while (rs.next()) {
                found = true;

                String vehicleName = rs.getString("VEHICLE_NAME");
                String status = rs.getString("BOOKING_STATUS");

                if (vehicleName == null) {
                    vehicleName = "Vehicle";
                }

                if (status == null) {
                    status = "UNKNOWN";
                }
    %>

    

<section class="booking-card">
    <div class="booking-top">
        <div>
            <h2><%= vehicleName %></h2>
            <div class="booking-id">
                Booking ID: #<%= rs.getInt("BOOKING_ID") %>
            </div>
        </div>

        <span class="status">
    <%= "CONFIRMED".equalsIgnoreCase(status)
            ? "BOOKED" : status %>
</span>

        <% if ("PENDING".equalsIgnoreCase(status)) { %>
            <a class="pay-now-btn"
               href="<%= request.getContextPath() %>/edit-booking.jsp?bookingId=<%= rs.getInt("BOOKING_ID") %>"
               style="display:inline-block; background:linear-gradient(135deg,#d4af37,#f5d76e); color:#111; padding:12px 20px; border-radius:8px; text-decoration:none; font-weight:bold; margin:10px 0; border:1px solid #d4af37;">
                Edit Booking
            </a>
        <% } %>
        
         <% if ("PENDING".equalsIgnoreCase(status)
            || "CONFIRMED".equalsIgnoreCase(status)) { %>
        <form action="<%= request.getContextPath() %>/CancelBookingServlet"
              method="post"
              onsubmit="return confirm('Are you sure you want to cancel this booking?');">

            <input type="hidden" name="bookingId"
                   value="<%= rs.getInt("BOOKING_ID") %>">

            <button type="submit" class="cancel-booking">
                Cancel Booking
            </button>
        </form>
    <% } %>

        <% if ("PENDING".equalsIgnoreCase(status)
        || "CONFIRMED".equalsIgnoreCase(status)) { %>
    <a class="pay-now-btn"
       href="<%= request.getContextPath() %>/payment.jsp?bookingId=<%= rs.getInt("BOOKING_ID") %>"
       style="display:inline-block; background:linear-gradient(135deg,#e6c477,#bd913d); color:#151515; padding:12px 20px; border-radius:8px; text-decoration:none; font-weight:bold; margin:10px 0; border:1px solid #d4af37;">
        Pay Now
    </a>
<% } %>


    <div class="booking-details">
        <div>
            <span class="detail-label">Pickup Date</span>
            <span class="detail-value">
                <%= dateFormat.format(rs.getDate("START_DATE")) %>
            </span>
        </div>

        <div>
            <span class="detail-label">Return Date</span>
            <span class="detail-value">
                <%= dateFormat.format(rs.getDate("END_DATE")) %>
            </span>
        </div>

        <div>
            <span class="detail-label">Total Amount</span>
            <span class="amount">
                &#8377;<%= rs.getBigDecimal("TOTAL_AMOUNT") %>
            </span>
        </div>
    </div>
</section>


    <%
            }
        }
    } catch (SQLException e) {
        application.log("Error loading ARK bookings", e);
    %>

    <% if ("1".equals(request.getParameter("updated"))) { %>
    <div class="success-message">
        Booking updated successfully!
    </div>
<% } %>

<% if ("unavailable".equals(request.getParameter("error"))) { %>
    <div class="error-message">
        These dates are unavailable. Please choose different dates.
    </div>
<% } %>
    
    <div class="error-message">
        We couldn't load your bookings. Please check the database
        connection and try again.
    </div>

    <%
    }

    if (!found) {
    %>

    <section class="empty-state">
        <h2>No Bookings Yet</h2>
        <p>
            You haven't made any reservations yet.
            Explore our vehicles and choose your next ride.
        </p>
        <a class="gold-btn"
           href="<%= request.getContextPath() %>/vehicles.jsp">
            Explore Vehicles
        </a>
    </section>

    <%
    }
    %>
</main>

</body>
</html>
