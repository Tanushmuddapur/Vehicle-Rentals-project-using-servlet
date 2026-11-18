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

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String DB_URL =
            "jdbc:oracle:thin:@localhost:1521:XE";

    private static final String DB_USER = "ARK";
    private static final String DB_PASSWORD = "Ark12345";

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
    	System.out.println("BookingServlet doPost reached!");

        HttpSession session = request.getSession(false);

        // Check whether the user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Get logged-in user's ID from session
            int userId = Integer.parseInt(
                    session.getAttribute("userId").toString());

            // Get booking details from the form
            String vehicleIdText = request.getParameter("vehicleId");
            String startDateText = request.getParameter("startDate");
            String endDateText = request.getParameter("endDate");

            if (vehicleIdText == null || startDateText == null
                    || endDateText == null
                    || vehicleIdText.isBlank()
                    || startDateText.isBlank()
                    || endDateText.isBlank()) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Please provide all booking details.");
                return;
            }

            int vehicleId = Integer.parseInt(vehicleIdText);

            LocalDate startDate = LocalDate.parse(startDateText);
            LocalDate endDate = LocalDate.parse(endDateText);
            LocalDate today = LocalDate.now();

            // Validate the dates
            if (startDate.isBefore(today)
                    || endDate.isBefore(startDate)) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Please select valid pickup and return dates.");
                return;
            }

            // Calculate rental days, including pickup and return dates
            long days = ChronoUnit.DAYS.between(
                    startDate, endDate) + 1;

            try (Connection con = DriverManager.getConnection(
                    DB_URL, DB_USER, DB_PASSWORD)) {

                // Get the actual daily price from Oracle
                String vehicleSql =
                        "SELECT RENT_PER_DAY FROM ARK_VEHICLES "
                      + "WHERE VEHICLE_ID = ? "
                      + "AND STATUS = 'AVAILABLE'";

                BigDecimal dailyRate;

                try (PreparedStatement ps =
                        con.prepareStatement(vehicleSql)) {

                    ps.setInt(1, vehicleId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (!rs.next()) {
                            response.sendError(
                                    HttpServletResponse.SC_BAD_REQUEST,
                                    "Vehicle not found or unavailable.");
                            return;
                        }

                        dailyRate = rs.getBigDecimal("RENT_PER_DAY");
                    }
                }

                BigDecimal totalAmount = dailyRate.multiply(
                        BigDecimal.valueOf(days));
                

                String availabilitySql = "SELECT COUNT(*) FROM ARK_BOOKINGS "
                	    + "WHERE VEHICLE_ID = ? "
                	    + "AND BOOKING_STATUS IN ('PENDING', 'CONFIRMED') "
                	    + "AND START_DATE <= ? "
                	    + "AND END_DATE >= ?";

try (PreparedStatement availabilityPs =
        con.prepareStatement(availabilitySql)) {

    availabilityPs.setInt(1, vehicleId);
    availabilityPs.setDate(2, Date.valueOf(endDate));
    availabilityPs.setDate(3, Date.valueOf(startDate));

    try (ResultSet availabilityRs =
            availabilityPs.executeQuery()) {

        if (availabilityRs.next()
                && availabilityRs.getInt(1) > 0) {

        	response.sendRedirect(
        		    request.getContextPath()
        		    + "/vehicles.jsp?error=unavailable"
        		);
        		return;
        }
    }
}

System.out.println("DEBUG: Creating booking with PENDING status");
                // Insert booking into ARK_BOOKINGS
String insertSql = "INSERT INTO ARK_BOOKINGS "
	    + "(BOOKING_ID, USER_ID, VEHICLE_ID, START_DATE, END_DATE, TOTAL_AMOUNT, BOOKING_STATUS, BOOKING_DATE) "
	    + "VALUES (ARK_BOOKINGS_SEQ.NEXTVAL, ?, ?, ?, ?, ?, 'PENDING', SYSDATE)";

                try (PreparedStatement ps =
                        con.prepareStatement(insertSql)) {

                    ps.setInt(1, userId);
                    ps.setInt(2, vehicleId);
                    ps.setDate(3, Date.valueOf(startDate));
                    ps.setDate(4, Date.valueOf(endDate));
                    ps.setBigDecimal(5, totalAmount);

                    int rows = ps.executeUpdate();

                    if (rows > 0) {
                        response.sendRedirect(
                                request.getContextPath()
                                + "/my-bookings.jsp?success=1");
                    } else {
                        response.sendError(
                                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                                "Booking could not be saved.");
                    }
                }
            }

        } catch (NumberFormatException
                 | java.time.format.DateTimeParseException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid vehicle ID or date format.");

        } catch (Exception e) {
            throw new ServletException(
                    "Error while processing vehicle booking.", e);
        }
    }
}

