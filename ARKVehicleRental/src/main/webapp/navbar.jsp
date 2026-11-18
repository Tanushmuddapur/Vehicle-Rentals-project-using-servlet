<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String context = request.getContextPath();

    // Each page sets this attribute before including navbar.jsp.
    String activePage = (String) request.getAttribute("activePage");
    if (activePage == null) {
        activePage = "";
    }

    // Adjust this condition if your login code uses a different session attribute.
    boolean loggedIn = session.getAttribute("userId") != null;

    boolean isAdmin = "ADMIN".equalsIgnoreCase(
        String.valueOf(session.getAttribute("role"))
    );
%>

<style>
    :root {
        --ark-gold: #d6ad64;
        --ark-gold-light: #f0d49a;
        --ark-black: #080909;
        --ark-white: #f8f6f1;
    }

    .ark-navbar,
    .ark-navbar * {
        box-sizing: border-box;
    }

    .ark-navbar {
        position: fixed;
        z-index: 9999;
        top: 0;
        left: 0;
        width: 100%;
        min-height: 86px;
        padding: 0 7%;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 28px;
        background: rgba(8, 9, 9, .70);
        border-bottom: 1px solid rgba(255,255,255,.12);
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        transition:
            min-height .35s ease,
            background .35s ease,
            border-color .35s ease,
            box-shadow .35s ease;
        font-family: Inter, Arial, sans-serif;
    }

    .ark-navbar.is-scrolled {
        min-height: 70px;
        background: rgba(8, 9, 9, .97);
        border-bottom-color: rgba(214,173,100,.35);
        box-shadow: 0 12px 35px rgba(0,0,0,.20);
    }

    .ark-brand {
        display: inline-flex;
        align-items: center;
        gap: 13px;
        flex-shrink: 0;
        color: var(--ark-white);
        text-decoration: none;
    }

    .ark-brand-symbol {
        width: 39px;
        height: 39px;
        display: grid;
        place-items: center;
        border: 1px solid var(--ark-gold);
        color: var(--ark-gold-light);
        transform: rotate(45deg);
        transition: background .3s ease, box-shadow .3s ease;
    }

    .ark-brand-symbol span {
        transform: rotate(-45deg);
        font-family: Georgia, serif;
        font-size: 25px;
    }

    .ark-brand:hover .ark-brand-symbol {
        background: rgba(214,173,100,.12);
        box-shadow: 0 0 20px rgba(214,173,100,.18);
    }

    .ark-brand-name {
        font-family: "Cormorant Garamond", Georgia, serif;
        font-size: 29px;
        line-height: 1;
        font-weight: 600;
        letter-spacing: 7px;
    }

    .ark-brand-subtitle {
        display: block;
        margin-top: 6px;
        color: var(--ark-gold);
        font-size: 8px;
        font-weight: 500;
        letter-spacing: 2.4px;
        white-space: nowrap;
    }

    .ark-nav-links {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: clamp(17px, 2.3vw, 32px);
    }

    .ark-nav-links a {
        position: relative;
        padding: 12px 0;
        color: #e5e2dc;
        text-decoration: none;
        white-space: nowrap;
        font-size: 10px;
        font-weight: 500;
        letter-spacing: 1.15px;
        transition: color .25s ease;
    }

    /* Animated gold underline */
    .ark-nav-links a::after {
        content: "";
        position: absolute;
        left: 0;
        bottom: 3px;
        width: 0;
        height: 1px;
        background: var(--ark-gold);
        transition: width .3s ease;
    }

    .ark-nav-links a:hover,
    .ark-nav-links a.active {
        color: var(--ark-gold-light);
    }

    .ark-nav-links a:hover::after,
    .ark-nav-links a.active::after {
        width: 100%;
    }

    /* Active page gets a stronger gold accent */
    .ark-nav-links a.active {
        font-weight: 700;
    }

    .ark-nav-links a.ark-logout {
        padding: 12px 17px;
        border: 1px solid rgba(214,173,100,.65);
        color: var(--ark-gold-light);
        transition: background .3s ease, color .3s ease;
    }

    .ark-nav-links a.ark-logout::after {
        display: none;
    }

    .ark-nav-links a.ark-logout:hover {
        background: var(--ark-gold);
        color: #111;
    }

    .ark-menu-toggle {
        display: none;
        width: 42px;
        height: 42px;
        border: 1px solid rgba(214,173,100,.4);
        background: transparent;
        color: var(--ark-gold-light);
        font-size: 23px;
        cursor: pointer;
    }

    /* Give page content room below the fixed navbar */
    body {
        padding-top: 86px;
    }

    @media (max-width: 950px) {
        .ark-navbar {
            padding: 0 5%;
        }

        .ark-nav-links {
            gap: 17px;
        }

        .ark-nav-links a {
            font-size: 9px;
            letter-spacing: .7px;
        }

        .ark-brand-name {
            font-size: 26px;
        }
    }

    @media (max-width: 760px) {
        .ark-navbar {
            min-height: 75px;
            padding: 0 6%;
        }

        .ark-navbar.is-scrolled {
            min-height: 68px;
        }

        .ark-brand-symbol {
            width: 33px;
            height: 33px;
        }

        .ark-brand-symbol span {
            font-size: 22px;
        }

        .ark-brand-name {
            font-size: 25px;
            letter-spacing: 5px;
        }

        .ark-brand-subtitle {
            font-size: 7px;
            letter-spacing: 1.8px;
        }

        .ark-menu-toggle {
            display: block;
            flex-shrink: 0;
        }

        .ark-nav-links {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            display: flex;
            flex-direction: column;
            align-items: stretch;
            gap: 0;
            padding: 8px 6% 20px;
            background: rgba(8,9,9,.98);
            border-bottom: 1px solid rgba(214,173,100,.3);
            box-shadow: 0 18px 28px rgba(0,0,0,.25);

            visibility: hidden;
            opacity: 0;
            transform: translateY(-8px);
            pointer-events: none;
            transition:
                opacity .25s ease,
                transform .25s ease,
                visibility .25s ease;

            max-height: calc(100vh - 75px);
            overflow-y: auto;
        }

        .ark-nav-links.open {
            visibility: visible;
            opacity: 1;
            transform: translateY(0);
            pointer-events: auto;
        }

        .ark-nav-links a {
            padding: 17px 4px;
            border-bottom: 1px solid rgba(255,255,255,.07);
            font-size: 11px;
            letter-spacing: 1px;
        }

        .ark-nav-links a::after {
            display: none;
        }

        .ark-nav-links a.active {
            padding-left: 12px;
            border-left: 2px solid var(--ark-gold);
            background: rgba(214,173,100,.06);
        }

        .ark-nav-links a.ark-logout {
            margin-top: 12px;
            padding: 14px;
            text-align: center;
        }

        body {
            padding-top: 75px;
        }
    }

    @media (prefers-reduced-motion: reduce) {
        .ark-navbar,
        .ark-navbar *,
        .ark-nav-links {
            transition: none !important;
            animation: none !important;
        }
    }
</style>

<header class="ark-navbar" id="arkNavbar">
    <a class="ark-brand" href="<%= context %>/index.jsp" aria-label="ARK Home">
        <div class="ark-brand-symbol"><span>A</span></div>
        <div>
            <div class="ark-brand-name">ARK</div>
            <span class="ark-brand-subtitle">VEHICLE RENTALS</span>
        </div>
    </a>

    <button class="ark-menu-toggle"
            id="arkMenuToggle"
            type="button"
            aria-label="Open navigation"
            aria-controls="arkNavLinks"
            aria-expanded="false">
        &#9776;
    </button>

    <nav class="ark-nav-links" id="arkNavLinks" aria-label="Main navigation">
        
<% if (!"vehicles".equals(activePage)) { %>
    <a href="<%= context %>/index.jsp"
       class="<%= "home".equals(activePage) ? "active" : "" %>">
        Home
    </a>
<% } %>


        <a href="<%= context %>/about.jsp"
           class="<%= "about".equals(activePage) ? "active" : "" %>">About</a>

        <% if (loggedIn) { %>
            <% if (isAdmin) { %>
                <a href="<%= context %>/admin-dashboard.jsp"
                   class="<%= "admin".equals(activePage) ? "active" : "" %>">Dashboard</a>
                <a href="<%= context %>/AdminVehiclesServlet"
                   class="<%= "vehicles".equals(activePage) ? "active" : "" %>">Vehicles</a>
            <% } else { %>
                <a href="<%= context %>/vehicles.jsp"
                   class="<%= "vehicles".equals(activePage) ? "active" : "" %>">Vehicles</a>

                <a href="<%= context %>/my-bookings.jsp"
                   class="<%= "bookings".equals(activePage) ? "active" : "" %>">My Bookings</a>

                <a href="<%= context %>/profile.jsp"
                   class="<%= "profile".equals(activePage) ? "active" : "" %>">Profile</a>
            <% } %>

            <a class="ark-logout" href="<%= context %>/LogoutServlet">Logout</a>
        <% } else { %>
            <a href="<%= context %>/login.jsp"
               class="<%= "login".equals(activePage) ? "active" : "" %>">Login</a>

            <a href="<%= context %>/register.jsp"
               class="<%= "register".equals(activePage) ? "active" : "" %>">Register</a>
        <% } %>
    </nav>
</header>

<script>
(function () {
    const navbar = document.getElementById("arkNavbar");
    const toggle = document.getElementById("arkMenuToggle");
    const links = document.getElementById("arkNavLinks");

    if (!navbar || !toggle || !links) return;

    function updateNavbar() {
        navbar.classList.toggle("is-scrolled", window.scrollY > 25);
    }

    updateNavbar();
    window.addEventListener("scroll", updateNavbar, { passive: true });

    toggle.addEventListener("click", function () {
        const isOpen = links.classList.toggle("open");

        toggle.setAttribute("aria-expanded", String(isOpen));
        toggle.setAttribute(
            "aria-label",
            isOpen ? "Close navigation" : "Open navigation"
        );
        toggle.innerHTML = isOpen ? "&times;" : "&#9776;";
    });

    links.querySelectorAll("a").forEach(function (link) {
        link.addEventListener("click", function () {
            links.classList.remove("open");
            toggle.setAttribute("aria-expanded", "false");
            toggle.setAttribute("aria-label", "Open navigation");
            toggle.innerHTML = "&#9776;";
        });
    });
})();
</script>