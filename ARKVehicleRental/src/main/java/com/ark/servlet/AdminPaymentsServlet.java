
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

@WebServlet("/AdminPaymentsServlet")
public class AdminPaymentsServlet extends HttpServlet {

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
        if (search == null) {
            search = "";
        }
        search = search.trim();

        List<Map<String, Object>> payments = new ArrayList<>();

        String sql =
                "SELECT p.PAYMENT_ID, p.BOOKING_ID, p.USER_ID, "
              + "u.FULL_NAME, u.EMAIL, "
              + "p.PAYMENT_METHOD, p.PAYMENT_AMOUNT, "
              + "p.PAYMENT_STATUS, p.PAYMENT_DATE "
              + "FROM ARK_PAYMENTS p "
              + "JOIN ARK_USERS u ON p.USER_ID = u.USER_ID ";

        if (!search.isEmpty()) {
            sql += "WHERE TO_CHAR(p.PAYMENT_ID) LIKE ? "
                 + "OR TO_CHAR(p.BOOKING_ID) LIKE ? "
                 + "OR LOWER(u.FULL_NAME) LIKE ? "
                 + "OR LOWER(u.EMAIL) LIKE ? ";
        }

        sql += "ORDER BY p.PAYMENT_ID DESC";

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            try (Connection con = DriverManager.getConnection(
                        DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement ps = con.prepareStatement(sql)) {

                if (!search.isEmpty()) {
                    ps.setString(1, "%" + search + "%");
                    ps.setString(2, "%" + search + "%");
                    ps.setString(3, "%" + search.toLowerCase() + "%");
                    ps.setString(4, "%" + search.toLowerCase() + "%");
                }

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> payment =
                                new LinkedHashMap<>();

                        payment.put("paymentId",
                                rs.getInt("PAYMENT_ID"));
                        payment.put("bookingId",
                                rs.getInt("BOOKING_ID"));
                        payment.put("userId",
                                rs.getInt("USER_ID"));
                        payment.put("customerName",
                                rs.getString("FULL_NAME"));
                        payment.put("email",
                                rs.getString("EMAIL"));
                        payment.put("method",
                                rs.getString("PAYMENT_METHOD"));
                        payment.put("amount",
                                rs.getBigDecimal("PAYMENT_AMOUNT"));
                        payment.put("status",
                                rs.getString("PAYMENT_STATUS"));
                        payment.put("paymentDate",
                                rs.getTimestamp("PAYMENT_DATE"));

                        payments.add(payment);
                    }
                }
            }

            request.setAttribute("payments", payments);
            request.setAttribute("search", search);

            request.getRequestDispatcher("/admin-payments.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to load demo payment records.", e);
        }
    }
}
