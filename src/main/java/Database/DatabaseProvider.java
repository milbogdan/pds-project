package Database;

import jakarta.persistence.*;

import java.sql.*;

public class DatabaseProvider {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/";
    private static final String DB_NAME = "letovanja";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new ExceptionInInitializerError(e);
        }
    }
    private static void createDatabaseIfNotExists() {
        try (Connection connection = DriverManager.getConnection(JDBC_URL, USER, PASSWORD);
             Statement statement = connection.createStatement()) {

            ResultSet resultSet = statement.executeQuery("SHOW DATABASES LIKE '" + DB_NAME + "'");
            if (!resultSet.next()) {
                statement.executeUpdate("CREATE DATABASE " + DB_NAME);
                System.out.println("Database " + DB_NAME + " created.");
            } else {
                System.out.println("Database " + DB_NAME + " already exists.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public static void provideDatabase() {
        createDatabaseIfNotExists();
    }

}
