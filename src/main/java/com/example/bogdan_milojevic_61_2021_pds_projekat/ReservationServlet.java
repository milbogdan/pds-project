package com.example.bogdan_milojevic_61_2021_pds_projekat;

import Daos.DestinationDAO;
import Daos.ReservationDAO;
import Daos.UserDAO;
import models.Destination;
import models.Reservation;
import models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/rezervacijaServlet")
public class ReservationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        int destinationId = Integer.parseInt(request.getParameter("destinationId"));
        int brojOsoba = Integer.parseInt(request.getParameter("brojOsoba"));
        int brojDana = Integer.parseInt(request.getParameter("brojDana"));
        String datumString = request.getParameter("datum");
        UserDAO userDao = new UserDAO();
        User user = userDao.getUserByUsername(username);
        DestinationDAO destinationDao = new DestinationDAO();
        Destination destination = destinationDao.getDestinationById(destinationId);
        if (user != null) {
            ReservationDAO reservationDao = new ReservationDAO();
            Reservation reservation = new Reservation(user, destination, brojOsoba, brojDana,datumString);
            reservationDao.saveReservation(reservation);
        }

        response.sendRedirect("index.jsp");
    }
}
