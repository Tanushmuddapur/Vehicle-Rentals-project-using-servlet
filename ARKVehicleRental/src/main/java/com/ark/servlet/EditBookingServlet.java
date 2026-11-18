
package com.ark.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/EditBookingServlet")
public class EditBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL =
            "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DB_USER = "ARK";
    private static final String DB_PASSWORD = "Ark12345";

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int userId = Integer.parseInt(
                    session.getAttribute("userId").toString());

            String bookingText = request.getParameter("bookingId");
            String startText = request.getParameter("startDate");
            String endText = request.getParameter("endDate");

            if (bookingText == null || !bookingText.matches("\\d+")
                    || startText == null || startText.isBlank()
                    || endText == null || endText.isBlank()) {
                response.sendError(400, "Please provide valid booking details.");
                return;
            }

            int bookingId = Integer.parseInt(bookingText);
            LocalDate startDate = LocalDate.parse(startText);
            LocalDate endDate = LocalDate.parse(endText);

            if (startDate.isBefore(LocalDate.now())
                    || endDate.isBefore(startDate)) {
                response.sendError(400,
                        "Please select valid pickup and return dates.");
                return;
            }

            long days = ChronoUnit.DAYS.between(startDate, endDate) + 1;

            try (Connection con =
                    DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

                // Verify that this is the user's pending booking.
                String bookingSql =
                        "SELECT VEHICLE_ID FROM ARK_BOOKINGS "
                      + "WHERE BOOKING_ID = ? AND USER_ID = ? "
                      + "AND BOOKING_STATUS = 'PENDING'";

                int vehicleId;

                try (PreparedStatement ps = con.prepareStatement(bookingSql)) {
                    ps.setInt(1, bookingId);
                    ps.setInt(2, userId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            response.sendError(404,
                                    "Pending booking not found.");
                            return;
                        }

                        vehicleId = rs.getInt("VEHICLE_ID");
                    }
                }

                // Get the current daily rental rate.
                String vehicleSql =
                        "SELECT RENT_PER_DAY FROM ARK_VEHICLES "
                      + "WHERE VEHICLE_ID = ? AND STATUS = 'AVAILABLE'";

                BigDecimal dailyRate;

                try (PreparedStatement ps = con.prepareStatement(vehicleSql)) {
                    ps.setInt(1, vehicleId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            response.sendError(400,
                                    "This vehicle is currently unavailable.");
                            return;
                        }

                        dailyRate = rs.getBigDecimal("RENT_PER_DAY");
                    }
                }

                // Check for overlapping pending or confirmed bookings.
                String availabilitySql =
                        "SELECT COUNT(*) FROM ARK_BOOKINGS "
                      + "WHERE VEHICLE_ID = ? "
                      + "AND BOOKING_ID <> ? "
                      + "AND BOOKING_STATUS IN ('PENDING', 'CONFIRMED') "
                      + "AND START_DATE <= ? AND END_DATE >= ?";

                try (PreparedStatement ps =
                        con.prepareStatement(availabilitySql)) {

                    ps.setInt(1, vehicleId);
                    ps.setInt(2, bookingId);
                    ps.setDate(3, Date.valueOf(endDate));
                    ps.setDate(4, Date.valueOf(startDate));

                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            response.sendRedirect(
                                    request.getContextPath()
                                    + "/my-bookings.jsp?error=unavailable");
                            return;
                        }
                    }
                }

                // Recalculate the total and update the pending booking.
                BigDecimal totalAmount =
                        dailyRate.multiply(BigDecimal.valueOf(days));

                String updateSql =
                        "UPDATE ARK_BOOKINGS "
                      + "SET START_DATE = ?, END_DATE = ?, TOTAL_AMOUNT = ? "
                      + "WHERE BOOKING_ID = ? AND USER_ID = ? "
                      + "AND BOOKING_STATUS = 'PENDING'";

                try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                    ps.setDate(1, Date.valueOf(startDate));
                    ps.setDate(2, Date.valueOf(endDate));
                    ps.setBigDecimal(3, totalAmount);
                    ps.setInt(4, bookingId);
                    ps.setInt(5, userId);

                    int rows = ps.executeUpdate();

                    if (rows > 0) {
                        response.sendRedirect(
                                request.getContextPath()
                                + "/my-bookings.jsp?updated=1");
                    } else {
                        response.sendError(409,
                                "Booking could not be updated.");
                    }
                }
            }

        } catch (NumberFormatException
                | java.time.format.DateTimeParseException e) {
            response.sendError(400, "Invalid booking ID or date format.");
        } catch (Exception e) {
            throw new ServletException(
                    "Error while updating booking.", e);
        }
    }
}
