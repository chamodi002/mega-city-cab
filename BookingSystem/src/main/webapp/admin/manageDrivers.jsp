<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.datapackage.model.Driver, com.datapackage.DAO.DriverDAO" %>
<%
    DriverDAO driverDAO = new DriverDAO();
    List<Driver> drivers = driverDAO.getAllDrivers();
    String message = (String) request.getAttribute("message");  // Retrieve the message attribute
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Drivers</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
    <style>
        body {
            background-image: url('${pageContext.request.contextPath}/images/4270-Aston_Martin-car-red_cars.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
        }
        .transparent-card {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .message {
            padding: 20px;
            margin-bottom: 20px;
            background-color: #4CAF50;
            color: white;
            text-align: center;
            border-radius: 10px;
            font-size: 20px;
            font-weight: bold;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
        }
        .message-error {
            background-color: #f44336;
            color: white;
        }
    </style>
</head>
<body>

<div class="container">
    <h3 class="center-align white-text">Manage Drivers</h3>
    
    <!-- Display success or error message -->
    <% if (message != null) { %>
        <div class="message <%= message.contains("successfully") ? "" : "message-error" %>">
            <%= message %>
        </div>
    <% } %>

    <!-- Add Driver Form -->
    <div class="card transparent-card">
        <div class="card-content">
            <span class="card-title">Add Driver</span>
            <form action="${pageContext.request.contextPath}/DriverServlet" method="post">
                <input type="hidden" name="action" value="add">
                
                <div class="input-field">
                    <input type="text" id="name" name="name" required>
                    <label for="name">Driver Name</label>
                </div>
                <div class="input-field">
                    <input type="text" id="license" name="license" required>
                    <label for="license">License Number</label>
                </div>
                <div class="input-field">
                    <input type="text" id="phone" name="phone" required>
                    <label for="phone">Phone Number</label>
                </div>
                <button type="submit" class="btn waves-effect waves-light">Add Driver</button>
            </form>
        </div>
    </div>

    <!-- Driver List -->
    <h4 class="center-align white-text">Driver List</h4>
    <div class="card transparent-card">
        <div class="card-content">
            <table class="striped centered">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>License</th>
                        <th>Phone</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Driver driver : drivers) { %>
                    <tr>
                        <td><%= driver.getName() %></td>
                        <td><%= driver.getLicense() %></td>
                        <td><%= driver.getPhone() %></td>
                        <td>
                            <!-- DELETE DRIVER FORM -->
                            <form id="deleteForm-<%= driver.getId() %>" action="${pageContext.request.contextPath}/DriverServlet" method="post">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= driver.getId() %>">
                                <button type="button" class="btn red" onclick="confirmDelete(<%= driver.getId() %>)">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
</body>
</html>
