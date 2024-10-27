package models;

import jakarta.persistence.*;

@Entity
public class Destination {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",nullable = false)
    private int id;

    @Column(name = "name",nullable = false)
    private String name;

    @Column(name = "imagePath",nullable = false)
    private String imagePath;

    @Column(name = "pricePerPerson",nullable = false)
    private double pricePerPerson;

    @Column(name = "isDeleted",nullable = false)
    private boolean isDeleted;

    public Destination(int id, String name, String imagePath, double pricePerPerson, boolean isDeleted) {
        this.id = id;
        this.name = name;
        this.imagePath = imagePath;
        this.pricePerPerson = pricePerPerson;
        this.isDeleted = isDeleted;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    public Destination() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public double getPricePerPerson() {
        return pricePerPerson;
    }

    public void setPricePerPerson(double pricePerPerson) {
        this.pricePerPerson = pricePerPerson;
    }
}