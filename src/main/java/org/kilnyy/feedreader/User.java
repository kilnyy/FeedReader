package org.kilnyy.feedreader;

import org.kilnyy.feedreader.Adapter;
import org.kilnyy.feedreader.Fetcher;

import com.sun.syndication.feed.synd.SyndFeed;

import java.sql.ResultSet;
import java.sql.Timestamp;

public class User {
    public Integer id;
    public String email;
    public String password;

    User(Integer _id, String _email, String _password) {
        id = _id;
        email = _email;
        password = _password;
    }

    User(Integer _id) {
        Adapter adapter = new Adapter();
        id = _id;
        ResultSet rs = adapter.execQuery("SELECT * FROM users WHERE id = " + id);
        try {
            if (rs.next()) {
                id = rs.getInt(1);
                email = rs.getString(2);
                password = rs.getString(3);
            }
        } catch (final Exception ex) {
            id = -1;
            System.err.println("ERROR: " + ex.getMessage());
        }
    }

    User(String _email, String _password) {
        Adapter adapter = new Adapter();
        email = _email;
        password = _password;
        ResultSet rs = adapter.execQuery("SELECT * FROM users WHERE email = '" + email + "'");
        try {
            if (rs.next()) {
                id = rs.getInt(1);
                email = rs.getString(2);
                if (!password.equals(rs.getString(3))) {
                    id = -1;
                }
            } else {
                adapter.getPs("INSERT INTO users(email, password) VALUES(?, ?)");
                adapter.ps.setString(1, email);
                adapter.ps.setString(2, password);
                adapter.execPs();
                rs = adapter.execQuery("SELECT * FROM users WHERE email = '" + email + "'");
                if (rs.next()) {
                    id = rs.getInt(1);
                } else {
                    id = -1;
                }
            }
        } catch (final Exception ex) {
            id = -1;
            System.err.println("ERROR: " + ex.getMessage());
        }
    }
}

