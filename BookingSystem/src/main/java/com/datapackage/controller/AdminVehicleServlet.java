package com.datapackage.controller;

import com.datapackage.DAO.VehicleDAO;
import com.datapackage.model.Vehicle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminVehicleServlet")
public class AdminVehicleServlet extends HttpServlet {
    private VehicleDAO vehicleDAO;

    @Override
    public void init() {
        vehicleDAO = new VehicleDAO();
    }

    // Handle adding vehicle
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Retrieve form data
            String type = request.getParameter("type");
            String priceStr = request.getParameter("price");
            String numberPlate = request.getParameter("numberPlate");

            if (type == null || priceStr == null || numberPlate == null) {
                // Redirect to the same page with an error if any required field is missing
                response.sendRedirect("admin/AddVehicle.jsp?error=missing_fields");
                return;
            }

            double price;
            try {
                price = Double.parseDouble(priceStr);
            } catch (NumberFormatException e) {
                response.sendRedirect("admin/AddVehicle.jsp?error=invalid_price");
                return;
            }

            // Handle file upload
            Part imagePart = request.getPart("imageFile");
            if (imagePart == null || imagePart.getSize() == 0) {
                response.sendRedirect("admin/AddVehicle.jsp?error=no_image_uploaded");
                return;
            }

            String imageFileName = extractFileName(imagePart);
            if (imageFileName == null || imageFileName.isEmpty()) {
                response.sendRedirect("admin/AddVehicle.jsp?error=invalid_image");
                return;
            }

            // Save the image file to the server
            String imagePath = "images/" + imageFileName;  // Save to 'images' folder
            String uploadPath = getServletContext().getRealPath("/") + "images" + File.separator + imageFileName;

            // Make sure the directory exists
            File imageDirectory = new File(getServletContext().getRealPath("/") + "images");
            if (!imageDirectory.exists()) {
                imageDirectory.mkdirs();  // Create the directory if it does not exist
            }

            imagePart.write(uploadPath);  // Write the image to the server

            // Create Vehicle object
            Vehicle vehicle = new Vehicle(0, type, price, imagePath, numberPlate);
            boolean isAdded = vehicleDAO.addVehicle(vehicle);

            if (isAdded) {
                response.sendRedirect("admin/AddVehicle.jsp?success=true");
            } else {
                response.sendRedirect("admin/AddVehicle.jsp?error=database_error");
            }
        } catch (Exception e) {
            e.printStackTrace();  // Log the error for debugging
            response.sendRedirect("admin/AddVehicle.jsp?error=true");
        }
    }

    // Handle retrieving all vehicles
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Vehicle> vehicles = vehicleDAO.getAllVehicles();  // Get all vehicles from database
        request.setAttribute("vehicles", vehicles);  // Set the list of vehicles as a request attribute
        request.getRequestDispatcher("/admin/AddVehicle.jsp").forward(request, response);  // Forward the request to the JSP
    }

    // Utility method to extract the file name
    private String extractFileName(Part part) {
        String partHeader = part.getHeader("content-disposition");
        for (String content : partHeader.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return null;
    }
}
