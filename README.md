# ARK – Vehicle Rental Management System

A web-based vehicle rental management system designed to make vehicle booking, customer management, and rental operations easier through a simple web interface.

## About the Project

ARK Vehicle Rental System is a Java-based web application that allows users to browse available vehicles, register or log in, book vehicles, manage their bookings, and access rental-related services. It also provides an admin panel for managing vehicles, users, bookings, and payments.

The project is developed using Java web technologies, JSP, Servlets, JDBC, and Oracle Database.

## Features

### User Features
- User Registration and Login
- Browse available vehicles
- Vehicle booking management
- View personal bookings
- Edit bookings
- Cancel bookings
- Profile management
- Payment interface
- Account deletion
- Logout functionality

### Admin Features
- Admin login and logout
- Admin dashboard
- Manage vehicles
- Manage registered users
- View and manage bookings
- View payment records

## Technologies Used

| Technology | Purpose |
|---|---|
| Java | Backend programming |
| JSP | Dynamic web pages |
| Servlets | Request handling and backend logic |
| JDBC | Database connectivity |
| Oracle Database XE | Database management |
| HTML5 | Page structure |
| CSS3 | Styling and layouts |
| JavaScript | Client-side interactions |
| Apache Tomcat 10.1 | Web application server |
| Eclipse IDE | Development environment |

## Project Structure

```text
ARKVehicleRental/
│
├── src/
│   └── com/ark/
│       ├── servlet/
│       │   ├── RegisterServlet.java
│       │   ├── LoginServlet.java
│       │   ├── LogoutServlet.java
│       │   ├── VehicleServlet.java
│       │   ├── BookingServlet.java
│       │   ├── EditBookingServlet.java
│       │   ├── CancelBookingServlet.java
│       │   ├── DeleteAccountServlet.java
│       │   ├── DemoPaymentServlet.java
│       │   └── admin/
│       │
│       └── util/
│           └── DBConnection.java
│
├── WebContent/
│   ├── index.jsp
│   ├── about.jsp
│   ├── vehicles.jsp
│   ├── login.jsp
│   ├── register.jsp
│   ├── my-bookings.jsp
│   ├── profile.jsp
│   ├── payment.jsp
│   ├── admin/
│   ├── css/
│   ├── js/
│   └── WEB-INF/
│       └── lib/
│
└── README.md
```

## Requirements

Before running the project, make sure you have installed:

- JDK
- Eclipse IDE for Enterprise Java and Web Developers
- Apache Tomcat 10.1
- Oracle Database XE
- Oracle JDBC Driver

## Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR-USERNAME/ARK-Vehicle-Rental-System.git
```

### 2. Import into Eclipse

1. Open Eclipse.
2. Go to **File → Import**.
3. Select **Existing Projects into Workspace**.
4. Browse to the cloned project folder.
5. Click **Finish**.

### 3. Configure Oracle Database

Make sure Oracle Database XE is running.

Configure the database connection inside:

```text
com.ark.util.DBConnection
```

Set your database URL, username, and password according to your Oracle installation.

### 4. Configure Apache Tomcat

1. Add Tomcat 10.1 to Eclipse.
2. Configure the project to use the Tomcat runtime.
3. Clean and rebuild the project.
4. Add the project to the Tomcat server.

### 5. Run the Project

Right-click the project and select:

```text
Run As → Run on Server
```

Open the application in your browser:

```text
http://localhost:8080/ARKVehicleRental/
```

> If your Tomcat server uses a different port or context path, adjust the URL accordingly.

## Database Connectivity

The project uses JDBC to connect Java application components to Oracle Database.

Example JDBC URL:

```text
jdbc:oracle:thin:@localhost:1521:XE
```

Database connection handling is managed through the `DBConnection.java` utility class.

## Application Modules

- **Authentication Module** – registration, login, logout
- **Vehicle Module** – vehicle listing and management
- **Booking Module** – booking, editing and cancellation
- **Payment Module** – payment interface and records
- **Profile Module** – user profile and account management
- **Admin Module** – management of users, vehicles, bookings and payments

## Project Purpose

This project was developed as an academic Java web development project to explore full-stack web application development, database connectivity, session management, CRUD operations, and web application deployment using Java technologies.

## Developer

**Tanush Muddapur**

BCA – Computer Applications

## License

This project is intended for educational and academic purposes.
