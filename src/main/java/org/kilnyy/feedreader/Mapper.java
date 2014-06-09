package org.kilnyy.feedreader;

import org.kilnyy.feedreader.Adapter;
import org.kilnyy.feedreader.Fetcher;
import org.kilnyy.feedreader.Site;
import org.kilnyy.feedreader.Article;
import java.util.ArrayList;

import com.sun.syndication.feed.synd.SyndFeed;
import java.sql.ResultSet;
import java.sql.Timestamp;

public class Mapper {
    private static Mapper instance;

    public static Mapper getInstance() {
        if (instance == null) {
            instance = new Mapper();
            return instance;
        } else {
            return instance;
        }
    }

    public ArrayList<Site> getAllSites() {
        ArrayList<Site> sites = new ArrayList<Site>();
        Adapter adapter = new Adapter();
        ResultSet rs = adapter.execQuery("SELECT * FROM sites");
        try {
            while(rs.next()) {
                sites.add(new Site(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getTimestamp(4)));
            }
        } catch (final Exception ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
        return sites;
    }

    public Site insertSite(String url) {
        return new Site(url);
    }

}
