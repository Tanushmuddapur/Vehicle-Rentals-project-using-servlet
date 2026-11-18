package com.ark.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import com.ark.util.DBConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null
                || email.trim().isEmpty()
                || password.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=invalid");
            return;
        }

        email = email.trim().toLowerCase();

        try (Connection con = DBConnection.getConnection()) {

            // 1. Check the separate admin table
            String adminSql =
                    "SELECT ADMIN_ID, ADMIN_NAME, ADMIN_EMAIL, PASSWORD_HASH "
                  + "FROM ARK_ADMINS WHERE LOWER(ADMIN_EMAIL) = ?";

            try (PreparedStatement ps = con.prepareStatement(adminSql)) {

                ps.setString(1, email);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        String hash = rs.getString("PASSWORD_HASH");

                        if (hash != null && BCrypt.checkpw(password, hash)) {

                            HttpSession oldSession =
                                    request.getSession(false);

                            if (oldSession != null) {
                                oldSession.invalidate();
                            }

                            HttpSession session = request.getSession(true);

                            session.setAttribute(
                                    "userId", rs.getLong("ADMIN_ID"));
                            
                            session.setAttribute(
                                    "fullName", rs.getString("ADMIN_NAME"));
                            session.setAttribute(
                                    "userEmail", rs.getString("ADMIN_EMAIL"));
                            session.setAttribute("role", "ADMIN");

                            session.setMaxInactiveInterval(30 * 60);

                            // Correct admin dashboard path
                            response.sendRedirect(
                                    request.getContextPath()
                                    + "/admin-dashboard.jsp");
                            return;
                        }

                        // Admin email exists, but password is incorrect
                        response.sendRedirect(
                                request.getContextPath()
                                + "/login.jsp?error=invalid");
                        return;
                    }
                }
            }

            // 2. Check customer credentials
            String customerSql =
                    "SELECT USER_ID, FULL_NAME, PASSWORD_HASH, ROLE "
                  + "FROM ARK_USERS WHERE LOWER(EMAIL) = ?";

            try (PreparedStatement ps =
                    con.prepareStatement(customerSql)) {

                ps.setString(1, email);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        String hash = rs.getString("PASSWORD_HASH");
                        String role = rs.getString("ROLE");

                        if (hash != null
                                && BCrypt.checkpw(password, hash)
                                && !"ADMIN".equalsIgnoreCase(role)) {

                            HttpSession oldSession =
                                    request.getSession(false);

                            if (oldSession != null) {
                                oldSession.invalidate();
                            }

                            HttpSession session = request.getSession(true);

                            session.setAttribute(
                                    "userId", rs.getLong("USER_ID"));
                            session.setAttribute(
                                    "fullName", rs.getString("FULL_NAME"));
                            session.setAttribute("userEmail", email);
                            session.setAttribute(
                                    "role", role == null ? "CUSTOMER" : role);

                            session.setMaxInactiveInterval(30 * 60);

                            // Customer dashboard
                            response.sendRedirect(
                                    request.getContextPath()
                                    + "/vehicles.jsp");
                            return;
                        }
                    }
                }
            }

            // 3. Invalid login
            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=invalid");

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to authenticate user.", e);
        }
    }
}