package com.example.bogdan_milojevic_61_2021_pds_projekat;


import Daos.ContactDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Contact;
import models.User;
import Daos.UserDAO;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/ContactServlet")
public class ContactServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String ime = request.getParameter("ime");
        String email = request.getParameter("email");
        String poruka = request.getParameter("poruka");
        String username = request.getParameter("username");

        UserDAO userDao = new UserDAO();
        User user = userDao.getUserByUsername(username);

        if (user != null) {
            ContactDAO contactDAO = new ContactDAO();
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            LocalDateTime now = LocalDateTime.now();
            String currentTime = dtf.format(now);

            Contact contact = new Contact(0, user, poruka, currentTime);
            contactDAO.addContact(contact);

            response.sendRedirect("kontakt.jsp");
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
