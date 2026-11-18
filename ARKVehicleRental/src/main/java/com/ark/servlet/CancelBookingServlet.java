
package com.ark.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CancelBookingServlet")
public class CancelBookingServlet extends HttpServlet {

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
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int userId = Integer.parseInt(
                    session.getAttribute("userId").toString());

            String bookingText = request.getParameter("bookingId");

            if (bookingText == null || !bookingText.matches("\\d+")) {
                response.sendError(400, "Invalid booking ID.");
                return;
            }

            int bookingId = Integer.parseInt(bookingText);

            String sql =
                    "UPDATE ARK_BOOKINGS "
                  + "SET BOOKING_STATUS = 'CANCELLED' "
                  + "WHERE BOOKING_ID = ? "
                  + "AND USER_ID = ? "
                  + "AND BOOKING_STATUS IN ('PENDING', 'CONFIRMED') "
                  + "AND START_DATE >= TRUNC(SYSDATE)";

            try (Connection con = DriverManager.getConnection(
                        DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, bookingId);
                ps.setInt(2, userId);

                int updated = ps.executeUpdate();

                if (updated == 1) {
                    response.sendRedirect(
                            request.getContextPath()
                            + "/my-bookings.jsp?cancel=success");
                } else {
                    response.sendRedirect(
                            request.getContextPath()
                            + "/my-bookings.jsp?cancel=failed");
                }
            }

        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid booking ID.");
        } catch (Exception e) {
            throw new ServletException(
                    "Unable to cancel booking.", e);
        }
    }
}
