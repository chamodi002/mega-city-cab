<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.datapackage.model.Vehicle" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Add Vehicle</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background: url('${pageContext.request.contextPath}/images/midsize-luxury-suv-sales.jpg') no-repeat center center fixed;
            background-size: cover;
        }
        .transparent-card {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
        }
        .table-card {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
        }
        .vehicle-image {
            width: 100px;
            height: 100px;
            border-radius: 8px;
        }
    </style>
</head>
<body>

<div class="container mt-4">
    <h2 class="text-center text-white">Add Vehicle</h2>

    <!-- Success Message for Vehicle Addition -->
    <% if (request.getParameter("success") != null) { %>
        <div class="alert alert-success">Vehicle added successfully!</div>
    <% } else if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger">There was an error adding the vehicle. Please try again.</div>
    <% } %>

    <div class="transparent-card">
        <form action="${pageContext.request.contextPath}/AdminVehicleServlet" method="post" enctype="multipart/form-data">
            <div class="mb-3">
                <label class="form-label text-white">Vehicle Type:</label>
                <input type="text" class="form-control" name="type" required>
            </div>
            <div class="mb-3">
                <label class="form-label text-white">Price (LKR):</label>
                <input type="number" class="form-control" name="price" required>
            </div>
            <div class="mb-3">
                <label class="form-label text-white">Upload Image:</label>
                <input type="file" class="form-control" name="imageFile" id="imageFile" accept="image/*" required>
                <img id="preview" class="vehicle-image mt-2" src="#" alt="Preview" hidden>
            </div>
            
            <div class="mb-3">
                <label class="form-label text-white">Model:</label>
                <input type="model" class="form-control" name="model" required>
            </div>
            <div class="mb-3">
                <label class="form-label text-white">Number Plate:</label>
                <input type="text" class="form-control" name="numberPlate" required>
            </div>
            <button type="submit" class="btn btn-primary w-50 d-block mx-auto">Add Vehicle</button>
        </form>
    </div>

    <!-- Display Added Vehicles -->
    <h3 class="mt-5 text-center text-white">Added Vehicles</h3>
    <div class="table-card">
        <table class="table table-bordered mt-3 text-white">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Type</th>
                    <th>Price</th>
                    <th>Image</th>
                    <th>Number Plate</th>
                    
                </tr>
            </thead>
            <tbody>
                <%
                    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
                    if (vehicles != null) {
                        for (Vehicle v : vehicles) {
                %>
                <tr>
                    <td><%= v.getId() %></td>
                    <td><%= v.getType() %></td>
                    <td>LKR <%= v.getPrice() %></td>
                    <td><img src="<%= v.getImage() %>" class="vehicle-image"></td>
                    <td><%= v.getNumberPlate() %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr><td colspan="5" class="text-center">No vehicles added yet.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<script>
    document.getElementById('imageFile').addEventListener('change', function(event) {
        let img = document.getElementById('preview');
        let file = event.target.files[0];
        if (file) {
            let reader = new FileReader();
            reader.onload = function(e) {
                img.src = e.target.result;
                img.hidden = false;
            }
            reader.readAsDataURL(file);
        }
    });
</script>

</body>
</html>
