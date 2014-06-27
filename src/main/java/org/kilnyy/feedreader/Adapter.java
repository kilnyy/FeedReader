package org.kilnyy.feedreader;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import com.mysql.jdbc.Driver;
import java.util.Properties;
import java.io.InputStream;

public class Adapter {

    private Connection con;
    private Statement st;
    private ResultSet rs;
    public PreparedStatement ps;

    public Adapter() {
        Properties props = new Properties(System.getProperties());
        String defaultResourceName = "database.sample.properties";
        String resourceName = "database.properties";
        InputStream in;
        try {
            in = this.getClass().getClassLoader().getResourceAsStream(resourceName);
            if (in == null)
                in = Thread.currentThread().getContextClassLoader().getResourceAsStream(resourceName);
            if (in == null)
                in = Thread.currentThread().getContextClassLoader().getResourceAsStream(defaultResourceName);
            if (in == null)
                in = Thread.currentThread().getContextClassLoader().getResourceAsStream(defaultResourceName);
            if (in != null) {
                props.load(in);
                in.close();
            } else {
                System.err.println("ERROR: Could not find" + resourceName + " or " + defaultResourceName);
            }
        } catch (final Exception ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }

        try {
            String url = props.getProperty("database.url");
            String user = props.getProperty("database.user");
            String password = props.getProperty("database.password");
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
            if (st == null) {
                st = con.createStatement();
            }
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
