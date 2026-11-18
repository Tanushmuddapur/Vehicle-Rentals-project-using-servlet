<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
if (session.getAttribute("userId") == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

int userId = Integer.parseInt(session.getAttribute("userId").toString());

String dbUrl = "jdbc:oracle:thin:@localhost:1521:XE";
String dbUser = "ARK";
String dbPassword = "Ark12345";

String fullName = "";
String email = "";
String role = "CUSTOMER";
String createdAt = "Member";

String sql = "SELECT FULL_NAME, EMAIL, ROLE, CREATED_AT "
           + "FROM ARK_USERS WHERE USER_ID = ?";

try (Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
     PreparedStatement ps = con.prepareStatement(sql)) {

    ps.setInt(1, userId);

    try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            fullName = rs.getString("FULL_NAME");
            email = rs.getString("EMAIL");
            role = rs.getString("ROLE");

            java.sql.Date date = rs.getDate("CREATED_AT");
            if (date != null) {
                createdAt = new java.text.SimpleDateFormat("dd MMM yyyy")
                        .format(date);
            }
        } else {
            response.sendError(404, "Customer profile not found.");
            return;
        }
    }
} catch (Exception e) {
    throw new ServletException("Unable to load customer profile.", e);
}

String initials = "?";
if (fullName != null && !fullName.trim().isEmpty()) {
    String[] parts = fullName.trim().split("\\s+");
    initials = parts[0].substring(0, 1).toUpperCase();
    if (parts.length > 1) {
        initials += parts[parts.length - 1].substring(0, 1).toUpperCase();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Profile | ARK Rentals</title>

<style>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: Arial, sans-serif;
    background: #090909;
    color: #f5f5f5;
    min-height: 100vh;
}

.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 7%;
    background: #111;
    border-bottom: 1px solid #292929;
}

.logo {
    font-size: 22px;
    font-weight: bold;
    letter-spacing: 2px;
    color: #d4af37;
}

.navbar a {
    color: #ddd;
    text-decoration: none;
    margin-left: 22px;
    font-size: 14px;
}

.navbar a:hover,
.navbar a.active {
    color: #d4af37;
}

.container {
    max-width: 1000px;
    margin: 55px auto;
    padding: 0 22px;
}

.eyebrow {
    color: #d4af37;
    text-transform: uppercase;
    letter-spacing: 3px;
    font-size: 12px;
    margin-bottom: 12px;
}

h1 {
    font-size: 38px;
    margin-bottom: 12px;
}

.subtitle {
    color: #aaa;
    line-height: 1.6;
    margin-bottom: 32px;
}

.profile-card {
    background: linear-gradient(145deg, #191919, #101010);
    border: 1px solid #393020;
    border-radius: 18px;
    overflow: hidden;
}

.profile-banner {
    height: 115px;
    background: linear-gradient(110deg, #6c5119, #d4af37, #72561b);
}

.profile-main {
    padding: 0 32px 32px;
}

.profile-header {
    display: flex;
    align-items: center;
    gap: 22px;
    margin-top: -48px;
    margin-bottom: 28px;
}

.avatar {
    width: 100px;
    height: 100px;
    flex-shrink: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #151515;
    border: 4px solid #d4af37;
    border-radius: 50%;
    color: #f5d76e;
    font-size: 30px;
    font-weight: bold;
}

.name {
    font-size: 26px;
    margin: 45px 0 8px;
    overflow-wrap: anywhere;
}

.badge {
    display: inline-block;
    color: #e8cc76;
    border: 1px solid #806b35;
    background: #292213;
    border-radius: 20px;
    padding: 6px 12px;
    font-size: 11px;
    letter-spacing: 1px;
}

.section-title {
    font-size: 17px;
    margin: 28px 0 18px;
    color: #f0d47f;
}

.details {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 16px;
}

.detail {
    background: #101010;
    border: 1px solid #2d2d2d;
    border-radius: 10px;
    padding: 18px;
    min-width: 0;
}

.detail-label {
    display: block;
    color: #999;
    font-size: 12px;
    margin-bottom: 10px;
}

.detail-value {
    color: #f5f5f5;
    font-size: 15px;
    overflow-wrap: anywhere;
}

.actions {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    margin-top: 28px;
}

.btn {
    display: inline-block;
    padding: 13px 19px;
    border-radius: 8px;
    text-decoration: none;
    font-size: 14px;
    font-weight: bold;
    transition: 0.2s;
}

.btn-primary {
    background: linear-gradient(135deg, #d4af37, #f5d76e);
    color: #111;
}

.btn-secondary {
    border: 1px solid #62532d;
    color: #e5c878;
    background: #17140d;
}

.btn:hover {
    transform: translateY(-2px);
    filter: brightness(1.08);
}

.footer {
    text-align: center;
    color: #777;
    font-size: 12px;
    padding: 30px 15px;
}

@media (max-width: 600px) {
    .navbar {
        padding: 18px;
        align-items: flex-start;
        gap: 16px;
        flex-direction: column;
    }

    .navbar a {
        margin-left: 0;
        margin-right: 16px;
    }

    .container {
        margin: 35px auto;
    }

    h1 {
        font-size: 30px;
    }

    .profile-main {
        padding: 0 18px 24px;
    }

    .profile-header {
        gap: 14px;
    }

    .avatar {
        width: 78px;
        height: 78px;
        font-size: 24px;
    }

    .name {
        font-size: 20px;
    }

    .details {
        grid-template-columns: 1fr;
    }
}
</style>
</head>

<body>
<jsp:include page="/navbar.jsp" />


<main class="container">
    <div class="eyebrow">Your Account</div>
    <h1>My Profile</h1>
    <p class="subtitle">
        Manage your account details and access your rental activity.
    </p>

    <section class="profile-card">
        <div class="profile-banner"></div>

        <div class="profile-main">
            <div class="profile-header">
                <div class="avatar"><%= initials %></div>

                <div>
                    <div class="name"><%= fullName == null ? "" : fullName %></div>
                    <span class="badge">
                        <%= role == null ? "CUSTOMER" : role %>
                    </span>
                </div>
            </div>

            <h2 class="section-title">Personal Information</h2>

            <div class="details">
                <div class="detail">
                    <span class="detail-label">Full Name</span>
                    <span class="detail-value">
                        <%= fullName == null ? "" : fullName %>
                    </span>
                </div>

                <div class="detail">
                    <span class="detail-label">Email Address</span>
                    <span class="detail-value">
                        <%= email == null ? "" : email %>
                    </span>
                </div>

                <div class="detail">
                    <span class="detail-label">Customer ID</span>
                    <span class="detail-value"><%= userId %></span>
                </div>

                <div class="detail">
                    <span class="detail-label">Member Since</span>
                    <span class="detail-value"><%= createdAt %></span>
                </div>
            </div>

<div class="actions">
    <a class="btn btn-primary"
       href="<%= request.getContextPath() %>/my-bookings.jsp">
        View My Bookings
    </a>

    <a class="btn btn-secondary"
       href="<%= request.getContextPath() %>/vehicles.jsp">
        Browse Vehicles
    </a>

    <a class="btn btn-secondary"
       href="<%= request.getContextPath() %>/LogoutServlet">
        Logout
    </a>

    <form action="<%= request.getContextPath() %>/DeleteAccountServlet"
          method="post"
          onsubmit="return confirm('WARNING: This permanently deletes your account, bookings, and demo-payment records. This cannot be undone. Continue?');"
          style="width:100%; margin-top:18px;">

        <label for="currentPassword"
               style="display:block; color:#aaa; margin-bottom:10px;">
            Enter your current password to delete your account
        </label>

        <input type="password"
               id="currentPassword"
               name="currentPassword"
               required
               autocomplete="current-password"
               placeholder="Current password"
               style="width:100%; max-width:360px; padding:13px;
                      background:#111; color:#fff;
                      border:1px solid #555; border-radius:8px;
                      margin-bottom:12px;">

        <br>

        <button type="submit"
                style="background:#351515; color:#ff8c8c;
                       border:1px solid #a33a3a; padding:13px 19px;
                       border-radius:8px; font-size:14px;
                       font-weight:bold; cursor:pointer;">
            Delete Account Permanently
        </button>
    </form>
</div>
        </div>
    </section>
</main>

<footer class="footer">
    ARK RENTALS &mdash; Premium Vehicle Rental Experience
</footer>

</body>
</html>
