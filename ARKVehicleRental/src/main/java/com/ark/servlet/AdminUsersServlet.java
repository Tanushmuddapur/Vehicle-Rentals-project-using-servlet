
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

@WebServlet("/AdminUsersServlet")
public class AdminUsersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String DB_URL =
            "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DB_USER = "ARK";
    private static final String DB_PASSWORD = "Ark12345";

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Check whether an admin is logged in
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

        List<Map<String, Object>> customers = new ArrayList<>();

        String sql =
                "SELECT USER_ID, FULL_NAME, EMAIL, ROLE, CREATED_AT "
              + "FROM ARK_USERS ";

        if (!search.isEmpty()) {
            sql += "WHERE LOWER(FULL_NAME) LIKE ? "
                 + "OR LOWER(EMAIL) LIKE ? "
                 + "OR TO_CHAR(USER_ID) LIKE ? ";
        }

        sql += "ORDER BY USER_ID DESC";

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            try (Connection con = DriverManager.getConnection(
                        DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement ps = con.prepareStatement(sql)) {

                if (!search.isEmpty()) {
                    String keyword = "%" + search.toLowerCase() + "%";

                    ps.setString(1, keyword);
                    ps.setString(2, keyword);
                    ps.setString(3, "%" + search + "%");
                }

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> customer =
                                new LinkedHashMap<>();

                        customer.put("userId", rs.getInt("USER_ID"));
                        customer.put("fullName",
                                rs.getString("FULL_NAME"));
                        customer.put("email",
                                rs.getString("EMAIL"));
                        customer.put("role",
                                rs.getString("ROLE"));
                        customer.put("createdAt",
                                rs.getDate("CREATED_AT"));

                        customers.add(customer);
                    }
                }
            }

            request.setAttribute("customers", customers);
            request.setAttribute("search", search);

            request.getRequestDispatcher("/admin-users.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to load customer records.", e);
        }
    }
}
