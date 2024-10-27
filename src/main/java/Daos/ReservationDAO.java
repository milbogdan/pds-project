package Daos;

import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import models.Reservation;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import models.User;

import java.util.List;

public class ReservationDAO {
    private static EntityManagerFactory emf = Persistence.createEntityManagerFactory("letovanja-app");

    public void saveReservation(Reservation reservation) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(reservation);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
    public List<Reservation> getAllReservationsForUser(User user, int skip, int take) {
        EntityManager em = emf.createEntityManager();
        List<Reservation> reservations = null;
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<Reservation> cq = cb.createQuery(Reservation.class);
            Root<Reservation> rootEntry = cq.from(Reservation.class);
            cq.select(rootEntry).where(cb.equal(rootEntry.get("user"), user));
            TypedQuery<Reservation> allQuery = em.createQuery(cq);

            allQuery.setFirstResult(skip);
            allQuery.setMaxResults(take);

            reservations = allQuery.getResultList();
        } finally {
            em.close();
        }
        return reservations;
    }
    public int getTotalReservationsCount(User user) {
        EntityManager em = emf.createEntityManager();
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<Long> cq = cb.createQuery(Long.class);
            Root<Reservation> rootEntry = cq.from(Reservation.class);
            cq.select(cb.count(rootEntry)).where(cb.equal(rootEntry.get("user"), user));
            TypedQuery<Long> query = em.createQuery(cq);
            return query.getSingleResult().intValue();
        } finally {
            em.close();
        }
    }
}
