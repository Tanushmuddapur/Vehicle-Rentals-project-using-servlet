
package com.ark.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminVehiclesServlet")
public class AdminVehiclesServlet extends HttpServlet {

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

        String base = request.getContextPath() + "/admin-vehicles.jsp";

        // Only authenticated administrators may modify vehicles.
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/admin-login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                createVehicle(request);
                response.sendRedirect(base + "?success=added");

            } else if ("update".equals(action)) {
                updateVehicle(request);
                response.sendRedirect(base + "?success=updated");

            } else if ("delete".equals(action)) {
                deleteVehicle(request);
                response.sendRedirect(base + "?success=deleted");

            } else {
                response.sendRedirect(base + "?error=error");
            }



        } catch (IllegalArgumentException e) {

            getServletContext().log(
                    "Vehicle operation: " + e.getMessage(), e);

            if (e.getMessage() != null
                    && e.getMessage().toLowerCase()
                            .contains("booking history")) {
                response.sendRedirect(base + "?error=bookings");
            } else {
                response.sendRedirect(base + "?error=error");
            }

        } catch (SQLException e) {

            getServletContext().log(
                    "Vehicle database error. Oracle code: "
                    + e.getErrorCode() + ", message: "
                    + e.getMessage(), e);

            if (e.getErrorCode() == 2292) {
                response.sendRedirect(base + "?error=bookings");
            } else {
                response.sendRedirect(base + "?error=error");
            }
        }
    }


    private void createVehicle(HttpServletRequest request)
            throws SQLException {

        Vehicle v = readVehicle(request);

        String sql =
                "INSERT INTO ARK_VEHICLES "
              + "(VEHICLE_ID, VEHICLE_NAME, BRAND, VEHICLE_TYPE, "
              + "REGISTRATION_NO, RENT_PER_DAY, FUEL_TYPE, "
              + "TRANSMISSION, SEATS, IMAGE_URL, STATUS) "
              + "VALUES (ARK_VEHICLES_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DriverManager.getConnection(
                    DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = con.prepareStatement(sql)) {

            setVehicleParameters(ps, v, 1);
            ps.executeUpdate();
        }
    }

    private void updateVehicle(HttpServletRequest request)
            throws SQLException {

        String idText = request.getParameter("vehicleId");
        int vehicleId = parseId(idText);

        Vehicle v = readVehicle(request);

        String sql =
                "UPDATE ARK_VEHICLES SET "
              + "VEHICLE_NAME = ?, BRAND = ?, VEHICLE_TYPE = ?, "
              + "REGISTRATION_NO = ?, RENT_PER_DAY = ?, "
              + "FUEL_TYPE = ?, TRANSMISSION = ?, SEATS = ?, "
              + "IMAGE_URL = ?, STATUS = ? "
              + "WHERE VEHICLE_ID = ?";

        try (Connection con = DriverManager.getConnection(
                    DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = con.prepareStatement(sql)) {

            setVehicleParameters(ps, v, 1);
            ps.setInt(11, vehicleId);

            if (ps.executeUpdate() != 1) {
                throw new IllegalArgumentException(
                        "Vehicle not found.");
            }
        }
    }

    private void deleteVehicle(HttpServletRequest request)
            throws SQLException {

        int vehicleId = parseId(request.getParameter("vehicleId"));

        String sql =
                "DELETE FROM ARK_VEHICLES WHERE VEHICLE_ID = ?";

        try (Connection con = DriverManager.getConnection(
                    DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, vehicleId);

            if (ps.executeUpdate() != 1) {
                throw new IllegalArgumentException(
                        "Vehicle not found.");
            }
        }
    }

    private Vehicle readVehicle(HttpServletRequest request) {

        Vehicle v = new Vehicle();

        v.name = required(request, "vehicleName", 100);
        v.brand = required(request, "brand", 80);
        v.type = required(request, "vehicleType", 50);
        v.registration = required(request, "registrationNo", 30)
                .toUpperCase(java.util.Locale.ROOT);

        String priceText = required(request, "rentPerDay", 30);

        try {
            v.price = new BigDecimal(priceText);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid price.");
        }

        if (v.price.compareTo(BigDecimal.ZERO) <= 0
                || v.price.compareTo(new BigDecimal("999999")) > 0
                || v.price.scale() > 2) {
            throw new IllegalArgumentException("Invalid rental price.");
        }

        v.fuel = required(request, "fuelType", 20);
        v.transmission = required(request, "transmission", 20);

        String seatsText = required(request, "seats", 10);

        try {
            v.seats = Integer.parseInt(seatsText);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid seat count.");
        }

        if (v.seats < 1 || v.seats > 100) {
            throw new IllegalArgumentException("Invalid seat count.");
        }

        v.imageUrl = request.getParameter("imageUrl");
        if (v.imageUrl != null) {
            v.imageUrl = v.imageUrl.trim();
        }

        if (v.imageUrl != null && v.imageUrl.isEmpty()) {
            v.imageUrl = null;
        }

        if (v.imageUrl != null && v.imageUrl.length() > 500) {
            throw new IllegalArgumentException("Image URL too long.");
        }

        v.status = required(request, "status", 20);

        if (!"AVAILABLE".equals(v.status)
                && !"UNAVAILABLE".equals(v.status)) {
            throw new IllegalArgumentException("Invalid vehicle status.");
        }

        if (!"Petrol".equalsIgnoreCase(v.fuel)
                && !"Diesel".equalsIgnoreCase(v.fuel)
                && !"Electric".equalsIgnoreCase(v.fuel)
                && !"Hybrid".equalsIgnoreCase(v.fuel)
                && !"CNG".equalsIgnoreCase(v.fuel)) {
            throw new IllegalArgumentException("Invalid fuel type.");
        }

        if (!"Manual".equalsIgnoreCase(v.transmission)
                && !"Automatic".equalsIgnoreCase(v.transmission)) {
            throw new IllegalArgumentException("Invalid transmission.");
        }

        return v;
    }

    private String required(HttpServletRequest request,
                            String parameter, int maxLength) {

        String value = request.getParameter(parameter);

        if (value == null) {
            throw new IllegalArgumentException(
                    "Missing " + parameter);
        }

        value = value.trim();

        if (value.isEmpty() || value.length() > maxLength) {
            throw new IllegalArgumentException(
                    "Invalid " + parameter);
        }

        return value;
    }

    private int parseId(String value) {

        if (value == null || !value.matches("\\d+")) {
            throw new IllegalArgumentException("Invalid vehicle ID.");
        }

        try {
            int id = Integer.parseInt(value);

            if (id <= 0) {
                throw new IllegalArgumentException("Invalid vehicle ID.");
            }

            return id;

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid vehicle ID.");
        }
    }

    private void setVehicleParameters(PreparedStatement ps,
                                      Vehicle v, int start)
            throws SQLException {

        ps.setString(start, v.name);
        ps.setString(start + 1, v.brand);
        ps.setString(start + 2, v.type);
        ps.setString(start + 3, v.registration);
        ps.setBigDecimal(start + 4, v.price);
        ps.setString(start + 5, v.fuel);
        ps.setString(start + 6, v.transmission);
        ps.setInt(start + 7, v.seats);
        ps.setString(start + 8, v.imageUrl);
        ps.setString(start + 9, v.status);
    }

    private static class Vehicle {
        String name;
        String brand;
        String type;
        String registration;
        BigDecimal price;
        String fuel;
        String transmission;
        int seats;
        String imageUrl;
        String status;
    }
}