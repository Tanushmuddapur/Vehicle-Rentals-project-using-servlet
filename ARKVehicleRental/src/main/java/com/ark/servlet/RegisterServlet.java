
package com.ark.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import com.ark.util.DBConnection;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Get form values
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword =
                request.getParameter("confirmPassword");

        // Check empty or missing fields
        if (fullName == null || email == null ||
            password == null || confirmPassword == null ||
            fullName.trim().isEmpty() ||
            email.trim().isEmpty() ||
            password.isEmpty() ||
            confirmPassword.isEmpty()) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "All fields are required."
            );
            return;
        }

        // Clean input values
        fullName = fullName.trim();
        email = email.trim().toLowerCase();

        // Validate full name
        if (fullName.length() > 100) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Full name must not exceed 100 characters."
            );
            return;
        }

        // Validate email
        if (email.length() > 150 ||
            !email.matches(
                "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please enter a valid email address."
            );
            return;
        }

        // Validate password length
        if (password.length() < 8 || password.length() > 72) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Password must contain 8 to 72 characters."
            );
            return;
        }

        // Check password confirmation
        if (!password.equals(confirmPassword)) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Passwords do not match."
            );
            return;
        }

        // Hash password using BCrypt
        String passwordHash = BCrypt.hashpw(
            password,
            BCrypt.gensalt(12)
        );

        // Oracle INSERT query
        String sql =
            "INSERT INTO ARK_USERS " +
            "(USER_ID, FULL_NAME, EMAIL, PASSWORD_HASH, ROLE) " +
            "VALUES (ARK_USERS_SEQ.NEXTVAL, ?, ?, ?, 'USER')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, passwordHash);

            int result = ps.executeUpdate();

            if (result > 0) {

                // Registration successful
                response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?registered=1"
                );

            } else {

                response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Registration failed. Please try again."
                );
            }

        } catch (SQLException e) {

            // Duplicate email / unique constraint violation
            if (e.getErrorCode() == 1) {
                response.sendError(
                    HttpServletResponse.SC_CONFLICT,
                    "This email is already registered."
                );
                return;
            }

            // Other database errors
            throw new ServletException(
                "Unable to register user. Please check database connection.",
                e
            );
        }
    }
}
