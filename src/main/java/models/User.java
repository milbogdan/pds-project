package models;

import jakarta.persistence.*;
import org.mindrot.jbcrypt.BCrypt;

import java.util.Date;

@Entity
@Table(name = "user")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "username",nullable = false, unique = true, length = 191)
    private String username;

    @Column(name = "name",nullable = false, unique = true, length = 191)
    private String name;

    @Column(name = "lastName",nullable = false, unique = true, length = 191)
    private String lastName;

    @Column(name = "email",nullable = false, unique = true, length = 191)
    private String email;

    @Column(name = "password",nullable = false)
    private String password;

    @Column(name = "isAdmin",nullable = false)
    private boolean isAdmin;

    @Column(name = "isDeleted",nullable = false)
    private boolean isDeleted;

    @Column(name = "profilePicturePath")
    private String profilePicturePath="profilePictures/default_user_image.jpg";

    @Column(name = "dateCreated",nullable = false)
    private String dateCreated;

    @Column(name = "sessionId",nullable = false)
    private String sessionId="";

    public User(int id, String username, String password, boolean isAdmin, boolean isDeleted,String name, String lastName, String email, String profilePicturePath, String dateCreated) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.isAdmin = isAdmin;
        this.isDeleted = isDeleted;
        this.name = name;
        this.lastName = lastName;
        this.email = email;
        this.profilePicturePath = profilePicturePath;
        this.dateCreated = dateCreated;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public User() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getProfilePicturePath() {
        return profilePicturePath;
    }

    public void setProfilePicturePath(String profilePicturePath) {
        this.profilePicturePath = profilePicturePath;
    }

    public String getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(String dateCreated) {
        this.dateCreated = dateCreated;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = BCrypt.hashpw(password, BCrypt.gensalt(12));
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdmin(boolean admin) {
        isAdmin = admin;
    }
}
