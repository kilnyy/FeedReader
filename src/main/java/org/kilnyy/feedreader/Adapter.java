package org.kilnyy.feedreader;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import com.mysql.jdbc.Driver;

public class Adapter {

    private Connection con;
    private Statement st;
    private ResultSet rs;
    public PreparedStatement ps;

    public Adapter() {
        String url = "jdbc:mysql://127.0.0.1:3306/FeedReader";
        String user = "root";
        String password = "";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(url, user, password);
            st = con.createStatement();
            st.executeQuery("SET NAMES utf8");
        } catch (Exception ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
    }

    public PreparedStatement getPs(String sql) {
        try {
            ps = con.prepareStatement(sql);
            return ps;
        } catch (SQLException ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
        return null;
    }

    public int execPs() {
        try {
            return ps.executeUpdate();
        } catch (SQLException ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
        return -1;
    }

    public ResultSet execQuery(String query) {
        rs = null;
        try {
            rs = st.executeQuery(query);
        } catch (SQLException ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
        return rs;
    }

    public Integer execUpdate(String query) {
        Integer res = -1;
        try {
            res = st.executeUpdate(query);
        } catch (SQLException ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
        return res;
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
