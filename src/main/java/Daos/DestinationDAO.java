package Daos;

import Beans.DestinationBean;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import models.Destination;

import java.util.List;

public class DestinationDAO {
    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("letovanja-app");

    public void save(Destination destination) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(destination);
        em.getTransaction().commit();
        em.close();
    }
    public List<Destination> getAllDestinations(int skip, int take) {
        EntityManager em = emf.createEntityManager();
        List<Destination> destinations = null;
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<Destination> cq = cb.createQuery(Destination.class);
            Root<Destination> rootEntry = cq.from(Destination.class);
            CriteriaQuery<Destination> all = cq.select(rootEntry);
            TypedQuery<Destination> allQuery = em.createQuery(all);

            // Paginacija
            allQuery.setFirstResult(skip);
            allQuery.setMaxResults(take);

            destinations = allQuery.getResultList();
        } finally {
            em.close();
        }
        return destinations;
    }
    public int getTotalDestinationsCount() {
        EntityManager em = emf.createEntityManager();
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<Long> cq = cb.createQuery(Long.class);
            Root<Destination> rootEntry = cq.from(Destination.class);
            cq.select(cb.count(rootEntry));
            TypedQuery<Long> query = em.createQuery(cq);
            return query.getSingleResult().intValue();
        } finally {
            em.close();
        }
    }
    public Destination getDestinationById(int id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Destination.class, id);
        } finally {
            em.close();
        }
    }
    public void updateDestination(DestinationBean destinationBean) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Destination destination = em.find(Destination.class, destinationBean.getId());
            if (destination != null) {
                destination.setName(destinationBean.getName());
                destination.setPricePerPerson(destinationBean.getPricePerPerson());
                destination.setDeleted(destinationBean.getIsDeleted());
                destination.setImagePath(destinationBean.getImagePath());
                em.persist(destination);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

}
