package com.example.bogdan_milojevic_61_2021_pds_projekat;

import Daos.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.NoResultException;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.UUID;

import models.User;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("letovanja-app");

    public LoginServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String korisnicko = request.getParameter("korisnicko");
        String sifra = request.getParameter("sifra");
        UserDAO userDao = new UserDAO();

        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.username = :korisnicko", User.class);
            query.setParameter("korisnicko", korisnicko);
            User korisnik = query.getSingleResult();

            if (korisnik != null && !korisnik.isDeleted() && BCrypt.checkpw(sifra, korisnik.getPassword())) {
                HttpSession session = request.getSession();
                session.setAttribute("username", korisnik.getUsername());
                session.setAttribute("isAdmin", korisnik.isAdmin());

                String sessionId = UUID.randomUUID().toString();
                userDao.setSessionIdByUsername(korisnicko, sessionId);

                response.sendRedirect("index.jsp");
            } else {
                response.sendRedirect("login.jsp?error=1");
            }
        } catch (NoResultException e) {
            response.sendRedirect("login.jsp?error=1");
        } finally {
            em.close();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
