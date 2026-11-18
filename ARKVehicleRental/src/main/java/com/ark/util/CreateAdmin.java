
package com.ark.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import org.mindrot.jbcrypt.BCrypt;

public class CreateAdmin {

    public static void main(String[] args) {

        String url = "jdbc:oracle:thin:@localhost:1521:XE";
        String dbUser = "ARK";
        String dbPassword = "Ark12345";

        String adminName = "ARK Administrator";
        String adminEmail = "admin@ark.com";

        // Change this to your own strong admin password
        String adminPassword = "Ala VaikuntaPuramalo";

        String passwordHash = BCrypt.hashpw(
            adminPassword,
            BCrypt.gensalt(12)
        );

        String sql =
            "INSERT INTO ARK_ADMINS " +
            "(ADMIN_ID, ADMIN_NAME, ADMIN_EMAIL, PASSWORD_HASH) " +
            "VALUES (ARK_ADMINS_SEQ.NEXTVAL, ?, ?, ?)";

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            try (Connection con = DriverManager.getConnection(
                    url, dbUser, dbPassword);
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, adminName);
                ps.setString(2, adminEmail);
                ps.setString(3, passwordHash);

                ps.executeUpdate();

                System.out.println("Admin account created successfully!");
                System.out.println("Admin email: " + adminEmail);
                System.out.println("Remember your chosen password.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
