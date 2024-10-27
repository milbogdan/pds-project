package com.example.bogdan_milojevic_61_2021_pds_projekat;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Daos.UserDAO;
import models.User;

@WebServlet("/UploadProfilePicture")
@MultipartConfig(location = "", fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class UploadProfilePictureServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uploadPath = getServletContext().getRealPath("") + File.separator + "profilePictures";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        Part filePart = request.getPart("profilePicture");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String filePath = uploadPath + File.separator + fileName;

            try (InputStream inputStream = filePart.getInputStream()) {
                Files.copy(inputStream, new File(filePath).toPath(), StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException e) {
                e.printStackTrace();
            }

            String profilePicturePath = "profilePictures/" + fileName;
            HttpSession session = request.getSession(false);
            String username = session.getAttribute("username").toString();
            UserDAO userDao = new UserDAO();
            User user = userDao.getUserByUsername(username);
            if (user != null) {
                user.setProfilePicturePath(profilePicturePath);
                userDao.updateUserWithUser(user);
            }
        }

        response.sendRedirect("profil.jsp");
    }
}
