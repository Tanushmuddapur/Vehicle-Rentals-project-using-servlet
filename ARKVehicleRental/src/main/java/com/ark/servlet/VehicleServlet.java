package com.ark.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.ark.util.DBConnection;

@WebServlet("/VehicleServlet")
public class VehicleServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        List<java.util.Map<String, Object>> vehicles =
                new ArrayList<>();

        String sql =
            "SELECT VEHICLE_ID, VEHICLE_NAME, BRAND, VEHICLE_TYPE, " +
            "RENT_PER_DAY, FUEL_TYPE, TRANSMISSION, SEATS, IMAGE_URL " +
            "FROM ARK_VEHICLES WHERE STATUS = 'AVAILABLE' " +
            "ORDER BY VEHICLE_ID";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                java.util.Map<String, Object> vehicle =
                        new java.util.HashMap<>();

                vehicle.put("id", rs.getLong("VEHICLE_ID"));
                vehicle.put("name", rs.getString("VEHICLE_NAME"));
                vehicle.put("brand", rs.getString("BRAND"));
                vehicle.put("type", rs.getString("VEHICLE_TYPE"));
                vehicle.put("price", rs.getBigDecimal("RENT_PER_DAY"));
                vehicle.put("fuel", rs.getString("FUEL_TYPE"));
                vehicle.put("transmission",
                        rs.getString("TRANSMISSION"));
                vehicle.put("seats", rs.getInt("SEATS"));
                vehicle.put("image", rs.getString("IMAGE_URL"));

                vehicles.add(vehicle);
            }

            request.setAttribute("vehicles", vehicles);

            request.getRequestDispatcher("/vehicles.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load vehicles from Oracle.", e);
        }
    }
}