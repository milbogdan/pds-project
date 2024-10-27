package com.example.bogdan_milojevic_61_2021_pds_projekat;

import Daos.ChatMessageDAO;
import Daos.UserDAO;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/SaveMessageServlet")
public class SaveMessageServlet extends HttpServlet {
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("letovanja-app");

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String messageContent = request.getParameter("message");
        HttpSession session = request.getSession(false);
        String username= (String) session.getAttribute("username");
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByUsername(username);

        String currentTime = getCurrentTime();

        ChatMessageDAO chatMessageDAO = new ChatMessageDAO();
        chatMessageDAO.addMessage(user, messageContent, currentTime);

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("Message saved successfully");
    }


    private String getCurrentTime() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(new Date());
    }
}
