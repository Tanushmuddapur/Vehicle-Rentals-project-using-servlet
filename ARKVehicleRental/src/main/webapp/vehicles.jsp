<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*,java.text.NumberFormat,java.util.Locale" %>
    
    <%
    request.setAttribute("activePage", "vehicles");
%>
    
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String fullName = (String) session.getAttribute("fullName");
%>
<%!
    private String html(Object value) {
        if (value == null) return "";
        return value.toString()
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }

    private String vehicleCategory(String type, String brand, String name) {
        String value = ((type == null ? "" : type) + " "
                + (brand == null ? "" : brand) + " "
                + (name == null ? "" : name)).toLowerCase(Locale.ROOT);
        if (value.contains("luxury") || value.contains("rolls-royce")
                || value.contains("maserati") || value.contains("bmw")
                || value.contains("mercedes") || value.contains("range rover"))
            return "luxury";
        if (value.contains("muv") || value.contains("mpv") || value.contains("innova"))
            return "muv";
        if (value.contains("suv") || value.contains("creta") || value.contains("seltos")
                || value.contains("fortuner"))
            return "suv";
        if (value.contains("sedan") || value.contains("swift") || value.contains("city"))
            return "sedan";
        return "all";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Vehicles | ARK Vehicle Rentals</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{--gold:#d8b56d;--gold-light:#e0c583;--bg:#101110;--panel:#171816;--muted:#aaa;--border:#34352f}
body{font-family:"Segoe UI",Arial,sans-serif;background:var(--bg);color:#f7f7f7;min-height:100vh}
a{color:inherit}
.navbar{display:flex;justify-content:space-between;align-items:center;gap:18px;flex-wrap:wrap;padding:20px 7%;background:var(--panel);border-bottom:1px solid #33342e;position:sticky;top:0;z-index:10}
.logo{color:var(--gold);font-size:28px;font-weight:900;letter-spacing:5px;text-decoration:none}.logo small{display:block;font-size:9px;color:#bbb;letter-spacing:2px;font-weight:400}
.nav-links{display:flex;gap:24px;align-items:center;flex-wrap:wrap}.nav-links a{color:#ddd;text-decoration:none;font-size:13px;transition:color .3s}.nav-links a:hover{color:var(--gold)}.logout{border:1px solid var(--gold);padding:9px 15px;border-radius:6px}
.hero{padding:65px 7% 45px;background:linear-gradient(90deg,#101110 10%,#101110dd 55%,#10111088),url("https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=1800&q=85");background-size:cover;background-position:center}
.eyebrow{color:var(--gold);text-transform:uppercase;letter-spacing:3px;font-size:11px;font-weight:bold}.hero h1{font-size:clamp(32px,5vw,52px);margin:15px 0}.hero h1 span,.section-heading h2 span{color:var(--gold)}.hero p{color:#c5c5c5;line-height:1.8;max-width:650px}.welcome{margin-top:20px;font-size:14px;color:var(--gold-light)}
.container{padding:40px 7% 65px}.section-heading{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:20px;margin-bottom:25px}.section-heading h2{font-size:26px}.vehicle-count{color:#aaa;font-size:12px;margin-top:8px}
.controls{display:flex;gap:12px;flex-wrap:wrap;margin-bottom:28px}.search{flex:1;min-width:210px}.search,.filter{background:#1b1c19;color:#fff;border:1px solid #41413a;padding:12px 15px;border-radius:7px;outline:none;font-size:14px;transition:border-color .3s,box-shadow .3s}.search:focus,.filter:focus{border-color:var(--gold);box-shadow:0 0 12px #d8b56d30}.filter option{background:#1b1c19;color:#fff}
.vehicle-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:25px}.vehicle-card{min-width:0;position:relative;background:linear-gradient(145deg,#20211d,#151613);border:1px solid var(--border);border-radius:13px;overflow:hidden;box-shadow:0 5px 16px #0003;transition:transform .35s,border-color .35s,box-shadow .35s;animation:cardAppear .6s ease both}.vehicle-card:hover{transform:translateY(-7px);border-color:var(--gold);box-shadow:0 18px 35px #0008,0 0 18px #d8b56d1f}.vehicle-card:focus-within{outline:2px solid var(--gold);outline-offset:3px}@keyframes cardAppear{from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:translateY(0)}}
.image-wrap{position:relative;height:205px;overflow:hidden;background:#252621}.vehicle-card img{display:block;width:100%;height:100%;object-fit:cover;transition:transform .55s,filter .35s}.vehicle-card:hover img{transform:scale(1.06);filter:brightness(1.08)}.badge{position:absolute;top:13px;left:13px;padding:7px 11px;border:1px solid var(--gold);border-radius:5px;background:#101110eb;color:var(--gold-light);font-size:10px;letter-spacing:1.5px;text-transform:uppercase}
.vehicle-info{padding:21px}.vehicle-type{font-size:10px;color:var(--gold);letter-spacing:1px;text-transform:uppercase}.vehicle-info h3{font-size:22px;margin:7px 0}.brand{color:#aaa;font-size:13px}.specs{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin:19px 0}.spec{font-size:11px;color:#999}.spec strong{display:block;color:#eee;font-size:12px;font-weight:600;margin-top:5px;overflow-wrap:anywhere}.card-bottom{display:flex;justify-content:space-between;align-items:center;gap:12px;border-top:1px solid #33342e;padding-top:17px}.price{color:var(--gold-light);font-size:21px;font-weight:700}.price small{display:block;color:#999;font-size:10px;font-weight:400;margin-top:3px}.book-btn,.confirm-booking{border:0;background:var(--gold);color:#111;padding:11px 17px;border-radius:6px;font-size:12px;font-weight:800;cursor:pointer;transition:background .25s,transform .25s}.book-btn:hover,.confirm-booking:hover{background:var(--gold-light);transform:translateY(-2px)}.book-btn:disabled{background:#4c4c45;color:#aaa;cursor:not-allowed;transform:none}
.empty{display:none;text-align:center;padding:35px 15px;color:#bbb;border:1px dashed #444;border-radius:10px}.empty h3{color:var(--gold);margin-bottom:8px}.notice{margin-bottom:20px;padding:13px 16px;border-radius:7px;background:#2a2115;border:1px solid #8b6c31;color:#f0d59c;font-size:13px}
footer{text-align:center;padding:25px 15px;background:#171816;border-top:1px solid #33342e;color:#aaa;font-size:11px;letter-spacing:1.5px}
.modal-overlay{display:none;position:fixed;inset:0;background:#000c;z-index:50;align-items:center;justify-content:center;padding:20px;overflow-y:auto}.booking-modal{width:100%;max-width:480px;background:#191a17;border:1px solid var(--gold);border-radius:13px;padding:28px;box-shadow:0 20px 60px #0009;position:relative}.modal-heading{display:flex;justify-content:space-between;align-items:center;gap:15px;margin-bottom:22px}.modal-heading h2{font-size:22px}.modal-heading h2 span{color:var(--gold)}.close-modal{border:1px solid #555;background:transparent;color:#ddd;border-radius:6px;padding:7px 10px;cursor:pointer}.selected-car{background:#22231f;border:1px solid #383931;border-radius:8px;padding:15px;margin-bottom:20px}.selected-car strong{display:block;color:var(--gold-light);font-size:17px;margin-bottom:6px}.selected-car span{font-size:13px;color:#aaa}.booking-modal label{display:block;font-size:12px;color:#ccc;margin:14px 0 7px}.booking-modal input[type=date]{width:100%;padding:12px;background:#111;color:#fff;border:1px solid #444;border-radius:6px;color-scheme:dark}.total-row{display:flex;justify-content:space-between;align-items:center;margin:20px 0;padding-top:15px;border-top:1px solid #393a33;color:#ccc}.total-row strong{font-size:20px;color:var(--gold-light)}.modal-actions{display:flex;gap:10px;flex-wrap:wrap}.modal-actions button{flex:1}.cancel-booking{padding:11px 17px;background:transparent;color:var(--gold);border:1px solid var(--gold);border-radius:6px;cursor:pointer;font-weight:700}.cancel-booking:hover{background:#d8b56d1a}.booking-error{color:#ffaaa5;font-size:12px;margin-top:10px;display:none}
@media(max-width:1000px){.vehicle-grid{grid-template-columns:repeat(2,minmax(0,1fr))}.navbar{padding:18px 5%}.container{padding-left:5%;padding-right:5%}}
@media(max-width:650px){.vehicle-grid{grid-template-columns:1fr}.hero{padding:45px 6% 35px}.container{padding:30px 6% 45px}.nav-links{gap:13px}.logo{font-size:24px}.image-wrap{height:220px}.booking-modal{padding:22px}}


/* ABOUT ARK */
.about-section {
    background: #0b0b0b;
    color: #f5f5f5;
    padding: 90px 7%;
    border-top: 1px solid #292929;
}

.about-container {
    max-width: 1200px;
    margin: 0 auto;
    text-align: center;
}

.about-label {
    display: inline-block;
    color: #d4af37;
    font-size: 12px;
    font-weight: bold;
    letter-spacing: 4px;
    margin-bottom: 20px;
}

.about-section h2 {
    font-size: clamp(30px, 4vw, 48px);
    line-height: 1.25;
    margin-bottom: 22px;
}

.about-section h2 span {
    color: #d4af37;
}

.about-description {
    max-width: 750px;
    margin: 0 auto 45px;
    color: #aaa;
    font-size: 16px;
    line-height: 1.9;
}

.about-features {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 22px;
    margin-bottom: 38px;
}

.about-card {
    background: linear-gradient(145deg, #191919, #111);
    border: 1px solid #333;
    border-radius: 14px;
    padding: 30px 24px;
    transition: transform 0.3s, border-color 0.3s;
}

.about-card:hover {
    transform: translateY(-6px);
    border-color: #d4af37;
}

.about-icon {
    color: #d4af37;
    font-size: 30px;
    margin-bottom: 16px;
}

.about-card h3 {
    color: #f5f5f5;
    font-size: 18px;
    margin-bottom: 12px;
}

.about-card p {
    color: #aaa;
    font-size: 14px;
    line-height: 1.8;
}

.about-button {
    display: inline-block;
    padding: 13px 24px;
    border-radius: 7px;
    background: linear-gradient(135deg, #f0d878, #b88a19);
    color: #111;
    font-weight: bold;
    text-decoration: none;
    transition: transform 0.2s;
}

.about-button:hover {
    transform: translateY(-2px);
}

@media (max-width: 768px) {
    .about-section {
        padding: 60px 6%;
    }

    .about-features {
        grid-template-columns: 1fr;
    }
}


</style>
</head>
<body>
<jsp:include page="/navbar.jsp" />


<header class="hero">
    <div class="eyebrow">The ARK Collection</div>
    <h1>Find Your <span>Perfect Drive.</span></h1>
    <p>Discover a carefully selected collection of comfortable everyday cars, spacious family vehicles and premium luxury machines. Choose your vehicle and book your dates with ease.</p>
    <% if (fullName != null && !fullName.trim().isEmpty()) { %>
        <div class="welcome">Welcome back, <%= html(fullName) %>.</div>
    <% } %>
</header>
<main class="container">
    <div class="section-heading">
        <div><h2>Explore Our <span>Fleet</span></h2><div class="vehicle-count" id="vehicleCount">Loading vehicles...</div></div>
    </div>
    <% if ("unavailable".equals(request.getParameter("error"))) { %>
        <div class="notice">Those dates are no longer available for this vehicle. Please choose another date range or vehicle.</div>
    <% } else if ("invalid".equals(request.getParameter("error"))) { %>
        <div class="notice">Please check your booking dates and try again.</div>
    <% } %>
    <div class="controls">
        <input class="search" id="search" type="search" placeholder="Search by vehicle name or brand..." aria-label="Search vehicles">
        <select class="filter" id="filter" aria-label="Filter vehicle category">
            <option value="all">All Categories</option>
            <option value="sedan">Sedan</option>
            <option value="suv">SUV</option>
            <option value="muv">MUV / MPV</option>
            <option value="luxury">Luxury</option>
        </select>
    </div>
    <div class="vehicle-grid" id="vehicleGrid">
<%
    String vehicleSql = "SELECT VEHICLE_ID, VEHICLE_NAME, BRAND, VEHICLE_TYPE, REGISTRATION_NO, "
        + "RENT_PER_DAY, FUEL_TYPE, TRANSMISSION, SEATS, IMAGE_URL, STATUS "
        + "FROM ARK_VEHICLES ORDER BY VEHICLE_ID";
    boolean foundVehicles = false;
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        try (Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE", "ARK", "Ark12345");
             PreparedStatement ps = con.prepareStatement(vehicleSql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                foundVehicles = true;
                int id = rs.getInt("VEHICLE_ID");
                String name = rs.getString("VEHICLE_NAME");
                String brand = rs.getString("BRAND");
                String type = rs.getString("VEHICLE_TYPE");
                String fuel = rs.getString("FUEL_TYPE");
                String transmission = rs.getString("TRANSMISSION");
                String status = rs.getString("STATUS");
                String imageUrl = rs.getString("IMAGE_URL");
                int seats = rs.getInt("SEATS");
                java.math.BigDecimal price = rs.getBigDecimal("RENT_PER_DAY");
                boolean available = "AVAILABLE".equalsIgnoreCase(status);
                String category = vehicleCategory(type, brand, name);
                String displayType = (type == null || type.trim().isEmpty()) ? "Vehicle" : type;
                String formattedPrice = price == null ? "0" : NumberFormat.getNumberInstance(new Locale("en", "IN")).format(price);
                if (imageUrl == null || imageUrl.trim().isEmpty()) {
                    imageUrl = "https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=880&q=80";
                }
                // Only render web image URLs; use the fallback for any other value.
                if (!(imageUrl.startsWith("https://") || imageUrl.startsWith("http://"))) {
                    imageUrl = "https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=880&q=80";
                }
%>
        <article class="vehicle-card" data-type="<%= html(category) %>">
            <div class="image-wrap">
                <img src="<%= html(imageUrl) %>" alt="<%= html((brand == null ? "" : brand) + " " + (name == null ? "Vehicle" : name)) %>" loading="lazy" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=880&q=80';">
                <span class="badge"><%= available ? html(displayType) : "Unavailable" %></span>
            </div>
            <div class="vehicle-info">
                <div class="vehicle-type"><%= html(displayType) %></div>
                <h3><%= html(name) %></h3>
                <div class="brand"><%= html(brand) %></div>
                <div class="specs">
                    <div class="spec">Fuel<strong><%= html(fuel) %></strong></div>
                    <div class="spec">Transmission<strong><%= html(transmission) %></strong></div>
                    <div class="spec">Seats<strong><%= seats %></strong></div>
                    <div class="spec">Status<strong><%= available ? "Available" : "Unavailable" %></strong></div>
                </div>
                <div class="card-bottom">
                    <div class="price">&#8377;<%= formattedPrice %><small>per day</small></div>
                    <button type="button" class="book-btn"
                        data-vehicle-id="<%= id %>"
                        data-vehicle-name="<%= html(name) %>"
                        data-price="<%= price == null ? "0" : price.toPlainString() %>"
                        <%= available ? "" : "disabled" %>><%= available ? "Book Now" : "Unavailable" %></button>
                </div>
            </div>
        </article>
<%
            }
        }
    } catch (Exception e) {
        application.log("Unable to load vehicles from Oracle in vehicles.jsp", e);
%>
        <p style="color:#ffaaa5;padding:20px;grid-column:1/-1;">Unable to load vehicles right now. Please check the Oracle connection and server log.</p>
<%
    }
    if (!foundVehicles) {
%>
        <p style="color:#ccc;padding:20px;grid-column:1/-1;">No vehicles are currently listed.</p>
<%
    }
%>
    </div>
    <div id="empty" class="empty"><h3>No Vehicles Found</h3><p>Try another vehicle name or select a different category.</p></div>
</main>


<footer>EXPERIENCE THE DIFFERENCE | ARK VEHICLE RENTALS</footer>

<div class="modal-overlay" id="bookingModal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
    <div class="booking-modal">
        <div class="modal-heading"><h2 id="modalTitle">Reserve Your <span>Vehicle</span></h2><button type="button" class="close-modal" onclick="closeBooking()" aria-label="Close booking form">✕</button></div>
        <div class="selected-car"><strong id="bookingCarName">Selected Vehicle</strong><span id="bookingDailyPrice">&#8377;0 per day</span></div>
        <form action="<%= request.getContextPath() %>/BookingServlet" method="post" id="bookingForm">
            <input type="hidden" name="vehicleId" id="bookingVehicleId">
            <label for="pickupDate">Pickup Date</label>
            <input type="date" name="startDate" id="pickupDate" required>
            <label for="returnDate">Return Date</label>
            <input type="date" name="endDate" id="returnDate" required>
            <div class="total-row"><span>Estimated Total</span><strong id="bookingTotal">&#8377;0</strong></div>
            <div class="booking-error" id="bookingError">Please choose a valid return date that is the same as or later than the pickup date.</div>
            <div class="modal-actions"><button type="submit" class="confirm-booking">Confirm Booking</button><button type="button" class="cancel-booking" onclick="closeBooking()">Cancel</button></div>
        </form>
    </div>
</div>
<script>
const search = document.getElementById("search");
const filter = document.getElementById("filter");
const cards = Array.from(document.querySelectorAll(".vehicle-card"));
const empty = document.getElementById("empty");
const count = document.getElementById("vehicleCount");
const bookingModal = document.getElementById("bookingModal");
const pickupDate = document.getElementById("pickupDate");
const returnDate = document.getElementById("returnDate");
const bookingForm = document.getElementById("bookingForm");
let selectedPrice = 0;

function filterVehicles() {
    const query = search.value.toLowerCase().trim();
    const category = filter.value;
    let visible = 0;
    cards.forEach(function(card) {
        const matchesText = card.textContent.toLowerCase().includes(query);
        const matchesType = category === "all" || card.dataset.type === category;
        const show = matchesText && matchesType;
        card.style.display = show ? "" : "none";
        if (show) visible++;
    });
    count.textContent = "Showing " + visible + " of " + cards.length + " vehicles";
    empty.style.display = visible === 0 ? "block" : "none";
}

function localDateString(date) {
    return date.getFullYear() + "-" + String(date.getMonth() + 1).padStart(2, "0") + "-" + String(date.getDate()).padStart(2, "0");
}

function showBooking(vehicleId, carName, price) {
    selectedPrice = Number(price) || 0;
    document.getElementById("bookingVehicleId").value = vehicleId;
    document.getElementById("bookingCarName").textContent = carName;
    document.getElementById("bookingDailyPrice").textContent = "₹" + selectedPrice.toLocaleString("en-IN") + " per day";
    const today = localDateString(new Date());
    pickupDate.min = today;
    returnDate.min = today;
    pickupDate.value = today;
    returnDate.value = today;
    document.getElementById("bookingError").style.display = "none";
    updateBookingTotal();
    bookingModal.style.display = "flex";
    document.body.style.overflow = "hidden";
}

function closeBooking() {
    bookingModal.style.display = "none";
    document.body.style.overflow = "";
}

function updateBookingTotal() {
    const start = pickupDate.value ? new Date(pickupDate.value + "T00:00:00") : null;
    const end = returnDate.value ? new Date(returnDate.value + "T00:00:00") : null;
    let days = 1;
    if (start && end && end >= start) days = Math.floor((end - start) / 86400000) + 1;
    document.getElementById("bookingTotal").textContent = "₹" + (selectedPrice * days).toLocaleString("en-IN");
    if (pickupDate.value) returnDate.min = pickupDate.value;
}

document.querySelectorAll(".book-btn").forEach(function(button) {
    button.addEventListener("click", function() {
        if (this.disabled) return;
        showBooking(this.dataset.vehicleId, this.dataset.vehicleName, this.dataset.price);
    });
});
search.addEventListener("input", filterVehicles);
filter.addEventListener("change", filterVehicles);
pickupDate.addEventListener("change", updateBookingTotal);
returnDate.addEventListener("change", updateBookingTotal);
bookingForm.addEventListener("submit", function(event) {
    if (!pickupDate.value || !returnDate.value || returnDate.value < pickupDate.value) {
        event.preventDefault();
        document.getElementById("bookingError").style.display = "block";
        return;
    }
    // The form continues to BookingServlet for server-side validation and saving.
});
bookingModal.addEventListener("click", function(event) {
    if (event.target === bookingModal) closeBooking();
});
document.addEventListener("keydown", function(event) {
    if (event.key === "Escape" && bookingModal.style.display === "flex") closeBooking();
});
filterVehicles();
</script>
</body>
</html>
