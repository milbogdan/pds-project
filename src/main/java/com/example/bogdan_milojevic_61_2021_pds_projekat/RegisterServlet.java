package com.example.bogdan_milojevic_61_2021_pds_projekat;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.User;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("letovanja-app");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String lastName = request.getParameter("lastName");
        String confirmPassword = request.getParameter("confirmPassword");

        if (username == null || password == null || confirmPassword == null ||
                username.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            response.sendRedirect("registracija.jsp?error=missing_fields");
            return;
        }

        if (!password.equals(confirmPassword)) {
            response.sendRedirect("registracija.jsp?error=password_mismatch");
            return;
        }

        EntityManager em = emf.createEntityManager();
        try {
            Query query = em.createQuery("SELECT u FROM User u WHERE u.username = :username");
            query.setParameter("username", username);
            List<User> existingUsers = query.getResultList();

            if (!existingUsers.isEmpty()) {
                response.sendRedirect("registracija.jsp?error=username_exists");
                return;
            }
            em.getTransaction().begin();

            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setAdmin(false);
            user.setDeleted(false);
            user.setName(name);
            user.setLastName(lastName);
            user.setEmail(email);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String dateString = sdf.format(new Date());
            user.setDateCreated(dateString);

            em.persist(user);
            em.getTransaction().commit();

            response.sendRedirect("login.jsp?success=registered");

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            response.sendRedirect("registracija.jsp?error=database_error");
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
}
