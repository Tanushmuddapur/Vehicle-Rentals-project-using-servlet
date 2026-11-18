
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>

<%!
    private String safe(Object value) {
        if (value == null) return "";
        String s = value.toString();
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    String dbUrl = "jdbc:oracle:thin:@localhost:1521:XE";
    String dbUser = "ARK";
    String dbPassword = "Ark12345";

    String editId = request.getParameter("edit");
    boolean editing = false;

    int vehicleId = 0;
    String vehicleName = "";
    String brand = "";
    String vehicleType = "";
    String registrationNo = "";
    String rentPerDay = "";
    String fuelType = "";
    String transmission = "";
    String seats = "";
    String imageUrl = "";
    String status = "AVAILABLE";

    if (editId != null && editId.matches("\\d+")) {
        String sql = "SELECT * FROM ARK_VEHICLES WHERE VEHICLE_ID = ?";

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            try (Connection con = DriverManager.getConnection(
                    dbUrl, dbUser, dbPassword);
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, Integer.parseInt(editId));

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        editing = true;
                        vehicleId = rs.getInt("VEHICLE_ID");
                        vehicleName = rs.getString("VEHICLE_NAME");
                        brand = rs.getString("BRAND");
                        vehicleType = rs.getString("VEHICLE_TYPE");
                        registrationNo = rs.getString("REGISTRATION_NO");
                        rentPerDay = rs.getString("RENT_PER_DAY");
                        fuelType = rs.getString("FUEL_TYPE");
                        transmission = rs.getString("TRANSMISSION");
                        seats = rs.getString("SEATS");
                        imageUrl = rs.getString("IMAGE_URL");
                        status = rs.getString("STATUS");
                    }
                }
            }
        } catch (Exception e) {
            application.log("Unable to load vehicle for editing.", e);
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ARK | Manage Vehicles</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    background: #0b0b0b;
    color: #f5f5f5;
    font-family: Arial, sans-serif;
    padding: 30px;
}

.container {
    max-width: 1400px;
    margin: auto;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    flex-wrap: wrap;
    margin-bottom: 30px;
}

.logo {
    color: #d4af37;
    font-weight: bold;
    letter-spacing: 4px;
    font-size: 28px;
    margin-bottom: 8px;
}

.subtitle {
    color: #999;
    font-size: 14px;
}

a {
    color: #e5c75c;
    text-decoration: none;
}

.back {
    border: 1px solid #665329;
    padding: 11px 16px;
    border-radius: 7px;
}

.panel {
    background: #171717;
    border: 1px solid #333;
    border-radius: 13px;
    padding: 25px;
    margin-bottom: 25px;
}

h2 {
    font-size: 20px;
    margin-bottom: 20px;
}

.form-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 17px;
}

label {
    display: block;
    color: #bbb;
    font-size: 13px;
    margin-bottom: 8px;
}

input, select {
    width: 100%;
    padding: 12px;
    border-radius: 6px;
    border: 1px solid #444;
    background: #101010;
    color: white;
    outline: none;
}

input:focus, select:focus {
    border-color: #d4af37;
}

.form-actions {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
    margin-top: 22px;
}

button, .button {
    display: inline-block;
    padding: 11px 16px;
    border: none;
    border-radius: 6px;
    background: linear-gradient(135deg, #f0d878, #b88a19);
    color: #111;
    font-weight: bold;
    cursor: pointer;
    font-size: 13px;
}

.secondary {
    background: #292929;
    color: #eee;
    border: 1px solid #444;
}

.table-wrap {
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 950px;
    border-collapse: collapse;
}

th, td {
    text-align: left;
    padding: 15px 12px;
    border-bottom: 1px solid #303030;
    font-size: 13px;
}

th {
    color: #d4af37;
    background: #201c13;
}

td {
    color: #ddd;
}

.status {
    color: #86df9b;
}

.actions {
    display: flex;
    align-items: center;
    gap: 8px;
}

.edit-link {
    color: #e5c75c;
}

.delete-button {
    background: #421c1c;
    border: 1px solid #7a3434;
    color: #ffaaaa;
}

.notice {
    color: #d9c47c;
    background: #211d13;
    border: 1px solid #493b22;
    padding: 13px;
    border-radius: 7px;
    margin-bottom: 20px;
}

@media (max-width: 850px) {
    body {
        padding: 15px;
    }

    .form-grid {
        grid-template-columns: 1fr;
    }

    .panel {
        padding: 18px;
    }
}
</style>
</head>

<body>
<jsp:include page="/navbar.jsp" />

<div class="container">

    <header class="header">
        <div>
            <div class="logo">ARK / VEHICLES</div>
            <div class="subtitle">Inventory and rental price management</div>
        </div>

        <a class="back"
           href="<%= request.getContextPath() %>/admin-dashboard.jsp">
           ← Dashboard
        </a>
    </header>

    <% if ("added".equals(request.getParameter("success"))) { %>
        <div class="notice">Vehicle added successfully.</div>
    <% } else if ("updated".equals(request.getParameter("success"))) { %>
        <div class="notice">Vehicle updated successfully.</div>
    <% } else if ("deleted".equals(request.getParameter("success"))) { %>
        <div class="notice">Vehicle deleted successfully.</div>
    <% } else if ("error".equals(request.getParameter("error"))) { %>
        <div class="notice">The operation could not be completed. Check the vehicle details and existing bookings.</div>
    <% } %>

    <section class="panel">
        <h2><%= editing ? "Edit Vehicle #" + vehicleId : "Add New Vehicle" %></h2>

        <form action="<%= request.getContextPath() %>/AdminVehiclesServlet"
      method="post">

            <input type="hidden" name="action"
                   value="<%= editing ? "update" : "create" %>">

            <% if (editing) { %>
                <input type="hidden" name="vehicleId"
                       value="<%= vehicleId %>">
            <% } %>

            <div class="form-grid">

                <div>
                    <label>Vehicle Name *</label>
                    <input name="vehicleName" required maxlength="100"
                           value="<%= safe(vehicleName) %>"
                           placeholder="e.g. Hyundai Creta">
                </div>

                <div>
                    <label>Brand *</label>
                    <input name="brand" required maxlength="80"
                           value="<%= safe(brand) %>"
                           placeholder="e.g. Hyundai">
                </div>

                <div>
                    <label>Vehicle Type *</label>
                    <input name="vehicleType" required maxlength="50"
                           value="<%= safe(vehicleType) %>"
                           placeholder="e.g. SUV">
                </div>

                <div>
                    <label>Registration Number *</label>
                    <input name="registrationNo" required maxlength="30"
                           value="<%= safe(registrationNo) %>"
                           placeholder="e.g. KA25AB1234">
                </div>

                <div>
                    <label>Rent Per Day (₹) *</label>
                    <input type="number" name="rentPerDay"
                           min="1" max="999999" step="0.01" required
                           value="<%= safe(rentPerDay) %>">
                </div>

                <div>
                    <label>Fuel Type *</label>
                    <select name="fuelType" required>
                        <option value="">Select fuel</option>
                        <option value="Petrol" <%= "Petrol".equalsIgnoreCase(fuelType) ? "selected" : "" %>>Petrol</option>
                        <option value="Diesel" <%= "Diesel".equalsIgnoreCase(fuelType) ? "selected" : "" %>>Diesel</option>
                        <option value="Electric" <%= "Electric".equalsIgnoreCase(fuelType) ? "selected" : "" %>>Electric</option>
                        <option value="Hybrid" <%= "Hybrid".equalsIgnoreCase(fuelType) ? "selected" : "" %>>Hybrid</option>
                        <option value="CNG" <%= "CNG".equalsIgnoreCase(fuelType) ? "selected" : "" %>>CNG</option>
                    </select>
                </div>

                <div>
                    <label>Transmission *</label>
                    <select name="transmission" required>
                        <option value="">Select transmission</option>
                        <option value="Manual" <%= "Manual".equalsIgnoreCase(transmission) ? "selected" : "" %>>Manual</option>
                        <option value="Automatic" <%= "Automatic".equalsIgnoreCase(transmission) ? "selected" : "" %>>Automatic</option>
                    </select>
                </div>

                <div>
                    <label>Seats *</label>
                    <input type="number" name="seats" min="1" max="100"
                           required value="<%= safe(seats) %>"
                           placeholder="e.g. 5">
                </div>

                
<div>
    <label>Car Image URL</label>
    <input type="url"
           id="imageUrl"
           name="imageUrl"
           maxlength="500"
           value="<%= safe(imageUrl) %>"
           placeholder="Paste direct car image URL">

    <p style="color:#999;font-size:12px;margin-top:7px;">
        Paste an image link ending in .jpg, .jpeg, .png or .webp.
    </p>

    <img id="carImagePreview"
         src="<%= safe(imageUrl) %>"
         alt="Car image preview"
         style="display:none;width:100%;max-width:260px;
                height:150px;object-fit:cover;margin-top:12px;
                border-radius:8px;border:1px solid #493b22;">

    <p style="margin-top:8px;">
        <a href="https://www.google.com/search?tbm=isch&q=car+images"
           target="_blank" rel="noopener noreferrer"
           style="color:#e5c75c;font-size:13px;">
            Find car images on Google Images ↗
        </a>
    </p>
</div>


                <div>
                    <label>Availability Status *</label>
                    <select name="status" required>
                        <option value="AVAILABLE" <%= "AVAILABLE".equalsIgnoreCase(status) ? "selected" : "" %>>Available</option>
                        <option value="UNAVAILABLE" <%= "UNAVAILABLE".equalsIgnoreCase(status) ? "selected" : "" %>>Unavailable</option>
                    </select>
                </div>

            </div>

            <div class="form-actions">
                <button type="submit">
                    <%= editing ? "Save Changes" : "Add Vehicle" %>
                </button>

                <% if (editing) { %>
                    <a class="button secondary"
                       href="<%= request.getContextPath() %>/admin-vehicles.jsp">
                       Cancel Edit
                    </a>
                <% } %>
            </div>

        </form>
    </section>

    <section class="panel">
        <h2>Vehicle Inventory</h2>

        <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Vehicle</th>
                    <th>Brand</th>
                    <th>Registration</th>
                    <th>Rent / Day</th>
                    <th>Fuel</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody>
            <%
                String listSql =
                    "SELECT VEHICLE_ID, VEHICLE_NAME, BRAND, "
                  + "REGISTRATION_NO, RENT_PER_DAY, FUEL_TYPE, STATUS "
                  + "FROM ARK_VEHICLES ORDER BY VEHICLE_ID";

                try {
                    Class.forName("oracle.jdbc.driver.OracleDriver");

                    try (Connection con = DriverManager.getConnection(
                                dbUrl, dbUser, dbPassword);
                         PreparedStatement ps = con.prepareStatement(listSql);
                         ResultSet rs = ps.executeQuery()) {

                        while (rs.next()) {
                            int id = rs.getInt("VEHICLE_ID");
            %>
                <tr>
                    <td><%= id %></td>
                    <td><%= safe(rs.getString("VEHICLE_NAME")) %></td>
                    <td><%= safe(rs.getString("BRAND")) %></td>
                    <td><%= safe(rs.getString("REGISTRATION_NO")) %></td>
                    <td>&#8377;<%= rs.getBigDecimal("RENT_PER_DAY") %></td>
                    <td><%= safe(rs.getString("FUEL_TYPE")) %></td>
                    <td class="status"><%= safe(rs.getString("STATUS")) %></td>
                    <td>
                        <div class="actions">
                            <a class="edit-link"
                               href="<%= request.getContextPath() %>/admin-vehicles.jsp?edit=<%= id %>">
                               Edit
                            </a>

                            

<form action="<%= request.getContextPath() %>/AdminVehiclesServlet"
      method="post"
      onsubmit="return confirm('Are you sure you want to delete this vehicle?');">

    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="vehicleId" value="<%= id %>">

    <button type="submit" class="delete-button">Delete</button>
</form>


                        </div>
                    </td>
                </tr>
            <%
                        }
                    }
                } catch (Exception e) {
                    application.log("Unable to load vehicle inventory.", e);
            %>
                <tr>
                    <td colspan="8">Unable to load vehicles. Check the server log.</td>
                </tr>
            <%
                }
            %>
            
            
<script>
const imageInput = document.getElementById("imageUrl");
const imagePreview = document.getElementById("carImagePreview");

function updateCarPreview() {
    const url = imageInput.value.trim();

    if (!url) {
        imagePreview.style.display = "none";
        imagePreview.removeAttribute("src");
        return;
    }

    imagePreview.onerror = function() {
        imagePreview.style.display = "none";
    };

    imagePreview.onload = function() {
        imagePreview.style.display = "block";
    };

    imagePreview.src = url;
}

imageInput.addEventListener("input", updateCarPreview);

updateCarPreview();
</script>
            
            
            </tbody>
        </table>
        </div>
    </section>

</div>
</body>
</html>
