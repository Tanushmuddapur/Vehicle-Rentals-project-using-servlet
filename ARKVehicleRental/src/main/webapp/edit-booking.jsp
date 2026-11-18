
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>

<%
if (session.getAttribute("userId") == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

int userId = Integer.parseInt(session.getAttribute("userId").toString());
String bookingText = request.getParameter("bookingId");

if (bookingText == null || !bookingText.matches("\\d+")) {
    response.sendError(400, "Invalid booking ID.");
    return;
}

int bookingId = Integer.parseInt(bookingText);

String dbUrl = "jdbc:oracle:thin:@localhost:1521:XE";
String dbUser = "ARK";
String dbPassword = "Ark12345";

String vehicleName = "";
Date startDate = null;
Date endDate = null;

try (Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
     PreparedStatement ps = con.prepareStatement(
         "SELECT v.VEHICLE_NAME, b.START_DATE, b.END_DATE " +
         "FROM ARK_BOOKINGS b " +
         "JOIN ARK_VEHICLES v ON b.VEHICLE_ID = v.VEHICLE_ID " +
         "WHERE b.BOOKING_ID = ? AND b.USER_ID = ? " +
         "AND b.BOOKING_STATUS = 'PENDING'")) {

    ps.setInt(1, bookingId);
    ps.setInt(2, userId);

    try (ResultSet rs = ps.executeQuery()) {
        if (!rs.next()) {
            response.sendError(404, "Pending booking not found.");
            return;
        }

        vehicleName = rs.getString("VEHICLE_NAME");
        startDate = rs.getDate("START_DATE");
        endDate = rs.getDate("END_DATE");
    }
} catch (SQLException e) {
    throw new ServletException("Unable to load booking details.", e);
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Booking | ARK Rentals</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            font-family: Arial, sans-serif;
            background: #090909;
            color: #f5f5f5;
        }
        .card {
            width: 100%;
            max-width: 480px;
            padding: 32px;
            background: #151515;
            border: 1px solid #b89445;
            border-radius: 14px;
        }
        h1 { color: #d6b15e; margin-top: 0; }
        .vehicle { color: #ccc; margin-bottom: 24px; }
        label {
            display: block;
            margin: 18px 0 8px;
            color: #ddd;
        }
        input {
            width: 100%;
            padding: 12px;
            border-radius: 7px;
            border: 1px solid #555;
            background: #0b0b0b;
            color: white;
        }
        button, .back {
            display: inline-block;
            padding: 12px 16px;
            border-radius: 7px;
            border: none;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
            margin-top: 22px;
        }
        button { background: #d6b15e; color: #111; }
        .back { color: #e5c878; border: 1px solid #8b713b; margin-left: 8px; }
        .note { color: #aaa; font-size: 13px; margin-top: 16px; }
    </style>
</head>
<body>
<jsp:include page="/navbar.jsp" />

    <main class="card">
        <h1>Edit Booking</h1>
        <p class="vehicle"><%= vehicleName %> · Booking #<%= bookingId %></p>

        <form action="<%= request.getContextPath() %>/EditBookingServlet"
              method="post">
            <input type="hidden" name="bookingId" value="<%= bookingId %>">

            <label for="startDate">Pickup Date</label>
            <input type="date" id="startDate" name="startDate"
                   min="<%= LocalDate.now() %>"
                   value="<%= startDate.toString() %>" required>

            <label for="endDate">Return Date</label>
            <input type="date" id="endDate" name="endDate"
                   min="<%= startDate.toString() %>"
                   value="<%= endDate.toString() %>" required>

            <button type="submit">Save Changes</button>
            <a class="back"
               href="<%= request.getContextPath() %>/my-bookings.jsp">Back</a>
        </form>

        <p class="note">
            Your changes will be checked for date conflicts before they are saved.
        </p>
    </main>
</body>
</html>
