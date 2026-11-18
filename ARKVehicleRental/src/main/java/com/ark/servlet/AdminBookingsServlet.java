
package com.ark.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminBookingsServlet")
public class AdminBookingsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String DB_URL =
            "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DB_USER = "ARK";
    private static final String DB_PASSWORD = "Ark12345";

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/admin-login.jsp");
            return;
        }

        String search = request.getParameter("search");
        String status = request.getParameter("status");

        if (search == null) {
            search = "";
        }
        search = search.trim();

        if (status == null) {
            status = "";
        }
        status = status.trim().toUpperCase();

        if (!status.isEmpty()
                && !status.equals("CONFIRMED")
                && !status.equals("CANCELLED")) {
            status = "";
        }

        List<Map<String, Object>> bookings = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT b.BOOKING_ID, b.USER_ID, "
              + "u.FULL_NAME, u.EMAIL, "
              + "b.VEHICLE_ID, v.VEHICLE_NAME, "
              + "b.START_DATE, b.END_DATE, "
              + "b.TOTAL_AMOUNT, b.BOOKING_STATUS, "
              + "b.BOOKING_DATE "
              + "FROM ARK_BOOKINGS b "
              + "JOIN ARK_USERS u ON b.USER_ID = u.USER_ID "
              + "JOIN ARK_VEHICLES v ON b.VEHICLE_ID = v.VEHICLE_ID "
              + "WHERE 1 = 1 ");

        if (!search.isEmpty()) {
            sql.append(
                    "AND (TO_CHAR(b.BOOKING_ID) LIKE ? "
                  + "OR LOWER(u.FULL_NAME) LIKE ? "
                  + "OR LOWER(u.EMAIL) LIKE ? "
                  + "OR LOWER(v.VEHICLE_NAME) LIKE ?) ");
        }

        if (!status.isEmpty()) {
            sql.append("AND b.BOOKING_STATUS = ? ");
        }

        sql.append("ORDER BY b.BOOKING_ID DESC");

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            try (Connection con = DriverManager.getConnection(
                        DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement ps = con.prepareStatement(sql.toString())) {

                int index = 1;

                if (!search.isEmpty()) {
                    String keyword = "%" + search.toLowerCase() + "%";

                    ps.setString(index++, "%" + search + "%");
                    ps.setString(index++, keyword);
                    ps.setString(index++, keyword);
                    ps.setString(index++, keyword);
                }

                if (!status.isEmpty()) {
                    ps.setString(index, status);
                }

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> booking =
                                new LinkedHashMap<>();

                        booking.put("bookingId",
                                rs.getInt("BOOKING_ID"));
                        booking.put("userId",
                                rs.getInt("USER_ID"));
                        booking.put("customerName",
                                rs.getString("FULL_NAME"));
                        booking.put("email",
                                rs.getString("EMAIL"));
                        booking.put("vehicleId",
                                rs.getInt("VEHICLE_ID"));
                        booking.put("vehicleName",
                                rs.getString("VEHICLE_NAME"));
                        booking.put("startDate",
                                rs.getDate("START_DATE"));
                        booking.put("endDate",
                                rs.getDate("END_DATE"));
                        booking.put("totalAmount",
                                rs.getBigDecimal("TOTAL_AMOUNT"));
                        booking.put("status",
                                rs.getString("BOOKING_STATUS"));
                        booking.put("bookingDate",
                                rs.getDate("BOOKING_DATE"));

                        bookings.add(booking);
                    }
                }
            }

            request.setAttribute("bookings", bookings);
            request.setAttribute("search", search);
            request.setAttribute("status", status);

            request.getRequestDispatcher("/admin-bookings.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to load booking records.", e);
        }
    }
}
