package models;

import jakarta.persistence.*;

@Entity
public class Reservation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @ManyToOne
    @JoinColumn(name = "userId", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "destinationId", nullable = false)
    private Destination destination;

    @Column(name = "brojOsoba", nullable = false)
    private int brojOsoba;

    @Column(name = "brojDana", nullable = false)
    private int brojDana;

    @Column(name = "date",nullable = false)
    private String date;
    public Reservation() {
    }

    public Reservation(User user, Destination destination, int brojOsoba, int brojDana, String date) {
        this.user = user;
        this.destination = destination;
        this.brojOsoba = brojOsoba;
        this.brojDana = brojDana;
        this.date = date;
    }


    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getId() {
        return id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Destination getDestination() {
        return destination;
    }

    public void setDestination(Destination destination) {
        this.destination = destination;
    }

    public int getBrojOsoba() {
        return brojOsoba;
    }

    public void setBrojOsoba(int brojOsoba) {
        this.brojOsoba = brojOsoba;
    }

    public int getBrojDana() {
        return brojDana;
    }

    public void setBrojDana(int brojDana) {
        this.brojDana = brojDana;
    }
}
