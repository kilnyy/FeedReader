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
    private ResultSet rs;

    public Adapter() {
        String url = "jdbc:mysql://localhost:3306/FeedReader";
        String user = "root";
        String password = "";

        try {
            con = DriverManager.getConnection(url, user, password);
            st = con.createStatement();
        } catch (SQLException ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
    }

    public ResultSet exec(String query) {
        try {
            rs = st.executeQuery(query);
        } catch (SQLException ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
        return rs;
    }

    protected void finalize() {
        try {
            if (st != null) {
                st.close();
            }
            if (con != null) {
                con.close();
            }
            if (rs != null) {
                rs.close();
            }
        } catch (SQLException ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
    }
}
