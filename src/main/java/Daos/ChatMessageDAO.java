package Daos;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import models.ChatMessage;
import models.User;

import java.util.List;

public class ChatMessageDAO {
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("letovanja-app");

    public void addMessage(User user, String content, String time) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            ChatMessage message = new ChatMessage();
            message.setUser(user);
            message.setContent(content);
            message.setTime(time);
            em.persist(message);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public List<ChatMessage> getAllMessages() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT m FROM ChatMessage m", ChatMessage.class).getResultList();
        } finally {
            em.close();
        }
    }
}
