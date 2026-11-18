
package com.ark.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String DB_URL =
            "jdbc:oracle:thin:@localhost:1521:XE";

    private static final String DB_USER = "ARK";
    private static final String DB_PASSWORD = "Ark12345";

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("adminEmail");
        String password = request.getParameter("adminPassword");

        if (email == null || password == null
                || email.trim().isEmpty()
                || password.isEmpty()) {

            response.sendRedirect(
                request.getContextPath()
                + "/admin-login.jsp?error=invalid");
            return;
        }

        String sql =
            "SELECT ADMIN_ID, ADMIN_NAME, ADMIN_EMAIL, PASSWORD_HASH "
          + "FROM ARK_ADMINS WHERE LOWER(ADMIN_EMAIL) = LOWER(?)";

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            try (Connection con = DriverManager.getConnection(
                        DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, email.trim());

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        String passwordHash =
                                rs.getString("PASSWORD_HASH");

                        if (passwordHash != null
                                && BCrypt.checkpw(password, passwordHash)) {

                            // Create a fresh session after authentication.
                            HttpSession oldSession =
                                    request.getSession(false);

                            if (oldSession != null) {
                                oldSession.invalidate();
                            }

                            HttpSession session =
                                    request.getSession(true);

                            session.setAttribute(
                                "adminId", rs.getInt("ADMIN_ID"));

                            session.setAttribute(
                                "adminName", rs.getString("ADMIN_NAME"));

                            session.setAttribute(
                                "adminEmail", rs.getString("ADMIN_EMAIL"));

                            session.setMaxInactiveInterval(30 * 60);

                            response.sendRedirect(
                                request.getContextPath()
                                + "/admin-dashboard.jsp");
                            return;
                        }
                    }
                }
            }

            // Use the same message for unknown email and wrong password.
            response.sendRedirect(
                request.getContextPath()
                + "/admin-login.jsp?error=invalid");

        } catch (Exception e) {
            throw new ServletException(
                "Unable to process administrator login.", e);
        }
    }
}
