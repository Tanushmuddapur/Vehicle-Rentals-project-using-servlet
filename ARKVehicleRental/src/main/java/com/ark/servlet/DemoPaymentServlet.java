
package com.ark.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/DemoPaymentServlet")
public class DemoPaymentServlet extends HttpServlet {

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

        // Check customer login
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int userId = Integer.parseInt(
                    session.getAttribute("userId").toString());

            String bookingText = request.getParameter("bookingId");
            String method = request.getParameter("method");

            // Validate submitted details
            if (bookingText == null
                    || !bookingText.matches("\\d+")
                    || method == null
                    || !method.matches("upi|card|netbanking")) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid payment details.");
                return;
            }

            int bookingId = Integer.parseInt(bookingText);

            try (Connection con = DriverManager.getConnection(
                    DB_URL, DB_USER, DB_PASSWORD)) {

                con.setAutoCommit(false);

                try {
                    BigDecimal amount;

                    // Verify booking ownership and lock the booking row
                    String bookingSql =
                            "SELECT TOTAL_AMOUNT FROM ARK_BOOKINGS "
                          + "WHERE BOOKING_ID = ? AND USER_ID = ? "
                          + "AND BOOKING_STATUS IN ('PENDING', 'CONFIRMED') "
                          + "FOR UPDATE";

                    try (PreparedStatement ps =
                            con.prepareStatement(bookingSql)) {

                        ps.setInt(1, bookingId);
                        ps.setInt(2, userId);

                        try (ResultSet rs = ps.executeQuery()) {
                            if (!rs.next()) {
                                con.rollback();
                                response.sendError(
                                        HttpServletResponse.SC_BAD_REQUEST,
                                        "Booking not found or unavailable for payment.");
                                return;
                            }

                            amount = rs.getBigDecimal("TOTAL_AMOUNT");

                            if (amount == null
                                    || amount.compareTo(BigDecimal.ZERO) <= 0) {
                                con.rollback();
                                response.sendError(
                                        HttpServletResponse.SC_BAD_REQUEST,
                                        "Invalid booking amount.");
                                return;
                            }
                        }
                    }

                    // Save demo payment record
                    String insertSql =
                            "INSERT INTO ARK_PAYMENTS "
                          + "(PAYMENT_ID, BOOKING_ID, USER_ID, "
                          + "PAYMENT_METHOD, PAYMENT_AMOUNT, "
                          + "PAYMENT_STATUS, PAYMENT_DATE) "
                          + "VALUES (ARK_PAYMENTS_SEQ.NEXTVAL, ?, ?, ?, ?, "
                          + "'DEMO_ONLY', SYSDATE)";

                    try (PreparedStatement ps =
                            con.prepareStatement(insertSql)) {

                        ps.setInt(1, bookingId);
                        ps.setInt(2, userId);
                        ps.setString(3, method);
                        ps.setBigDecimal(4, amount);

                        int rowsInserted = ps.executeUpdate();

                        if (rowsInserted != 1) {
                            throw new ServletException(
                                    "Demo payment record was not saved.");
                        }
                    }

                    // Mark the booking as confirmed after payment is saved
                    String updateSql =
                            "UPDATE ARK_BOOKINGS "
                          + "SET BOOKING_STATUS = 'CONFIRMED' "
                          + "WHERE BOOKING_ID = ? AND USER_ID = ? "
                          + "AND BOOKING_STATUS IN ('PENDING', 'CONFIRMED')";

                    try (PreparedStatement ps =
                            con.prepareStatement(updateSql)) {

                        ps.setInt(1, bookingId);
                        ps.setInt(2, userId);

                        if (ps.executeUpdate() != 1) {
                            throw new ServletException(
                                    "Unable to update booking status.");
                        }
                    }

                    // Commit payment and booking update together
                    con.commit();

                } catch (Exception e) {
                    try {
                        con.rollback();
                    } catch (Exception rollbackError) {
                        e.addSuppressed(rollbackError);
                    }
                    throw e;
                }
            }

            // Redirect to payment success page
            String encodedMethod = URLEncoder.encode(
                    method, StandardCharsets.UTF_8);

            response.sendRedirect(
                    request.getContextPath()
                    + "/payment-success.jsp?bookingId=" + bookingId
                    + "&method=" + encodedMethod
                    + "&demo=saved");

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid booking ID.");

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to complete demo payment.", e);
        }
    }
}