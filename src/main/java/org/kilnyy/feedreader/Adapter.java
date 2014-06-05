package org.kilnyy.feedreader;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Adapter {

    private static Adapter instance;
    private Connection con;
    private Statement st;

    public static Adapter getInstance() {
        if (instance == null) {
            instance = new Adapter();
            return instance;
        } else {
            return instance;
        }
    }
    
    public Adapter() {
        ResultSet rs = null;

        String url = "jdbc:mysql://localhost:3306/FeedReader";
        String user = "root";
        String password = "";

        try {
            con = DriverManager.getConnection(url, user, password);
            st = con.createStatement();
            rs = st.executeQuery("SELECT VERSION()");

            if (rs.next()) {
                System.out.println(rs.getString(1));
            }
            if (rs != null) {
                rs.close();
            }

        } catch (SQLException ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
    }

    protected void finalize() {
        try {
            if (st != null) {
                st.close();
            }
            if (con != null) {
                con.close();
            }
        } catch (SQLException ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
    }
}
