package com.ark.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
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

@WebServlet("/DeleteAccountServlet")
public class DeleteAccountServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String DB_URL =
            "jdbc:oracle:thin:@localhost:1521:XE";

    private static final String DB_USER = "ARK";

    // Configure ARK_DB_PASSWORD in the Tomcat environment.
    private static final String DB_PASSWORD =
            System.getenv("ARK_DB_PASSWORD");

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String context = request.getContextPath();

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(context + "/login.jsp");
            return;
        }

        // Prevent an admin account from being deleted through this servlet.
     // Only customer sessions can delete customer accounts.
        if (session.getAttribute("adminId") != null
                || session.getAttribute("userId") == null) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Only customer accounts can be deleted here."
            );
            return;
        }

        String password = request.getParameter("currentPassword");

        if (password == null || password.isEmpty()) {
            response.sendRedirect(
                    context + "/profile.jsp?deleteError=wrongpassword");
            return;
        }

        int userId;

        try {
            userId = Integer.parseInt(
                    session.getAttribute("userId").toString());
        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid customer session.");
            return;
        }

        if (DB_PASSWORD == null || DB_PASSWORD.isEmpty()) {
            throw new ServletException(
                    "Configure the ARK_DB_PASSWORD environment variable.");
        }

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            try (Connection con = DriverManager.getConnection(
                    DB_URL, DB_USER, DB_PASSWORD)) {

                con.setAutoCommit(false);

                try {
                    // Lock and retrieve the customer's password hash.
                    String checkSql =
                            "SELECT PASSWORD_HASH FROM ARK_USERS "
                          + "WHERE USER_ID = ? AND ROLE = 'CUSTOMER' "
                          + "FOR UPDATE";

                    String passwordHash = null;

                    try (PreparedStatement ps =
                            con.prepareStatement(checkSql)) {

                        ps.setInt(1, userId);

                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                passwordHash =
                                        rs.getString("PASSWORD_HASH");
                            }
                        }
                    }

                    if (passwordHash == null
                            || !BCrypt.checkpw(password, passwordHash)) {

                        con.rollback();

                        response.sendRedirect(
                                context
                                + "/profile.jsp?deleteError=wrongpassword");
                        return;
                    }

                    // Archive basic details for the admin's Deleted Members list.
                    String archiveSql =
                            "INSERT INTO ARK_DELETED_MEMBERS "
                          + "(DELETION_ID, ORIGINAL_USER_ID, FULL_NAME, "
                          + "EMAIL, DELETED_AT) "
                          + "SELECT ARK_DELETED_MEMBERS_SEQ.NEXTVAL, "
                          + "USER_ID, FULL_NAME, EMAIL, SYSDATE "
                          + "FROM ARK_USERS "
                          + "WHERE USER_ID = ? AND ROLE = 'CUSTOMER'";

                    try (PreparedStatement ps =
                            con.prepareStatement(archiveSql)) {

                        ps.setInt(1, userId);

                        if (ps.executeUpdate() != 1) {
                            throw new SQLException(
                                    "Unable to save deleted-member record.");
                        }
                    }

                    // Remove associated payment records first.
                    String deletePayments =
                            "DELETE FROM ARK_PAYMENTS WHERE USER_ID = ?";

                    try (PreparedStatement ps =
                            con.prepareStatement(deletePayments)) {

                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }

                    // Remove associated bookings.
                    String deleteBookings =
                            "DELETE FROM ARK_BOOKINGS WHERE USER_ID = ?";

                    try (PreparedStatement ps =
                            con.prepareStatement(deleteBookings)) {

                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }

                    // Permanently remove the customer account.
                    String deleteUser =
                            "DELETE FROM ARK_USERS "
                          + "WHERE USER_ID = ? AND ROLE = 'CUSTOMER'";

                    try (PreparedStatement ps =
                            con.prepareStatement(deleteUser)) {

                        ps.setInt(1, userId);

                        if (ps.executeUpdate() != 1) {
                            throw new SQLException(
                                    "Customer account was not deleted.");
                        }
                    }

                    // Save all database changes together.
                    con.commit();

                    // End the customer's session after successful deletion.
                    session.invalidate();

                    response.sendRedirect(
                            context + "/index.jsp?deleted=1");

                } catch (Exception e) {

                    try {
                        con.rollback();
                    } catch (SQLException rollbackError) {
                        e.addSuppressed(rollbackError);
                    }

                    throw e;
                }
            }

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to permanently delete the customer account.", e);
        }
    }
}