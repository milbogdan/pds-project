package Daos;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import models.Contact;

import java.util.List;

public class ContactDAO {
    private static final String PERSISTENCE_UNIT_NAME = "letovanja-app";
    private static EntityManagerFactory factory;

    public ContactDAO() {
        factory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
    }

    public void addContact(Contact contact) {
        EntityManager em = factory.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(contact);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
    public List<Contact> getAllContacts(int offset, int limit) {
        EntityManager em = factory.createEntityManager();

        try {
            Query query = em.createQuery("SELECT c FROM Contact c", Contact.class);
            query.setFirstResult(offset);
            query.setMaxResults(limit);

            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public int getTotalContactsCount() {
        EntityManager em = factory.createEntityManager();

        try {
            Query query = em.createQuery("SELECT COUNT(c) FROM Contact c");
            return ((Long) query.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
}