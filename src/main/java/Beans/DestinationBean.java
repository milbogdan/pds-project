package Beans;

import java.io.Serializable;

public class DestinationBean implements Serializable {

    private int id;

    private String name;

    private String imagePath;

    private double pricePerPerson;

    private boolean isDeleted;

    public DestinationBean(int id, String name, String imagePath, double pricePerPerson, boolean isDeleted) {
        this.id = id;
        this.name = name;
        this.imagePath = imagePath;
        this.pricePerPerson = pricePerPerson;
        this.isDeleted = isDeleted;
    }

    public boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    public DestinationBean() {
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