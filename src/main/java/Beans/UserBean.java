package Beans;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;

public class UserBean implements Serializable {

    private int id;
    private String username;
    private String name;
    private String lastName;
    private String email;
    private String password;
    private boolean isAdmin;
    private boolean isDeleted;
    private String profilePicturePath;
    private String dateCreated;
    private String sessionId;

    public UserBean(int id, String username, String password, boolean isAdmin, boolean isDeleted, String profilePicturePath, String dateCreated, String lastName, String email, String name) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.isAdmin = isAdmin;
        this.isDeleted = isDeleted;
        this.profilePicturePath = profilePicturePath;
        this.dateCreated = dateCreated;
        this.lastName = lastName;
        this.email = email;
        this.name = name;
    }

    public UserBean() {
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
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

    public boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
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
        this.password = password;
    }

    public boolean getIsAdmin() {
        return isAdmin;
    }

    public void setIsAdmin(boolean isAdmin) {
        this.isAdmin = isAdmin;
    }
}
