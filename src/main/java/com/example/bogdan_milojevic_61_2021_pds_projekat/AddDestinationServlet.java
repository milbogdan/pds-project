package com.example.bogdan_milojevic_61_2021_pds_projekat;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

import Daos.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import Daos.DestinationDAO;
import models.Destination;
import models.User;

@WebServlet("/addDestinationServlet")
@MultipartConfig
public class AddDestinationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uploadPath = getServletContext().getRealPath("") + File.separator + "destinationImages";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();
        String name = request.getParameter("destinationName");
        int price = Integer.parseInt(request.getParameter("destinationPrice"));
        Part filePart = request.getPart("destinationImage");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String filePath = uploadPath + File.separator + fileName;

            try (InputStream inputStream = filePart.getInputStream()) {
                Files.copy(inputStream, new File(filePath).toPath(), StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException e) {
                e.printStackTrace();
            }

            String profilePicturePath = "destinationImages/" + fileName;
            Destination destination = new Destination();
            destination.setName(name);
            destination.setImagePath("destinationImages/" + fileName);
            destination.setPricePerPerson(price);

            DestinationDAO destinationDAO = new DestinationDAO();
            destinationDAO.save(destination);
        }

        response.sendRedirect("index.jsp");
    }
}
