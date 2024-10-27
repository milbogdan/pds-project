package Daos;

import Beans.UserBean;
import jakarta.persistence.*;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import models.ChatMessage;
import models.User;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.CopyOnWriteArrayList;

public class UserDAO {
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("letovanja-app");

    public List<User> getAllUsers(int skip, int take) {
        EntityManager em = emf.createEntityManager();
        List<User> users = null;
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<User> cq = cb.createQuery(User.class);
            Root<User> rootEntry = cq.from(User.class);
            CriteriaQuery<User> all = cq.select(rootEntry);
            TypedQuery<User> allQuery = em.createQuery(all);

            // Paginacija
            allQuery.setFirstResult(skip);
            allQuery.setMaxResults(take);

            users = allQuery.getResultList();
        } finally {
            em.close();
        }
        return users;
    }

    public int getTotalUsersCount() {
        EntityManager em = emf.createEntityManager();
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<Long> cq = cb.createQuery(Long.class);
            Root<User> rootEntry = cq.from(User.class);
            cq.select(cb.count(rootEntry));
            TypedQuery<Long> query = em.createQuery(cq);
            return query.getSingleResult().intValue();
        } finally {
            em.close();
        }
    }
    public void updateUser(UserBean userBean) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            User user = em.find(User.class, userBean.getId());
            if (user != null) {
                user.setUsername(userBean.getUsername());
                user.setAdmin(userBean.getIsAdmin());
                user.setDeleted(userBean.getIsDeleted());
                user.setDateCreated(userBean.getDateCreated());
                user.setProfilePicturePath(userBean.getProfilePicturePath());
                em.persist(user);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
    public void updateUserWithUser(User usr) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            User user = em.find(User.class, usr.getId());
            if (user != null) {
                user.setUsername(usr.getUsername());
                user.setPassword(usr.getPassword());
                user.setAdmin(usr.isAdmin());
                user.setDeleted(usr.isDeleted());
                user.setDateCreated(usr.getDateCreated());
                user.setProfilePicturePath(usr.getProfilePicturePath());
                em.persist(user);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
    public User getUserByUsername(String username) {
        EntityManager em = emf.createEntityManager();
        TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class);
        query.setParameter("username", username);
        List<User> resultList = query.getResultList();
        if (resultList.isEmpty()) {
            return null;
        } else {
            return resultList.get(0);
        }
    }
    public void setSessionIdByUsername(String username, String sessionId) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            User user = em.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class)
                    .setParameter("username", username)
                    .getSingleResult();

            user.setSessionId(sessionId);

            em.persist(user);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
    public List<User> searchUsersByUsername(String username) {
        EntityManager em = emf.createEntityManager();
        TypedQuery<User> query = em.createQuery(
                "SELECT u FROM User u WHERE u.username LIKE :username", User.class);
        query.setParameter("username", "%" + username + "%");

        return query.getResultList();
    }

}
