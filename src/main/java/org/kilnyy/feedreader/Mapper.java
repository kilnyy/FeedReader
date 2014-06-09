package org.kilnyy.feedreader;

import org.kilnyy.feedreader.Adapter;
import org.kilnyy.feedreader.Fetcher;
import org.kilnyy.feedreader.Site;
import org.kilnyy.feedreader.Article;
import java.util.ArrayList;

import com.sun.syndication.feed.synd.SyndFeed;
import com.sun.syndication.feed.synd.SyndEntry;
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

    public ArrayList<Article> getAllArticles() {
        ArrayList<Article> articles = new ArrayList<Article>();
        Adapter adapter = new Adapter();
        ResultSet rs = adapter.execQuery("SELECT * FROM article");
        try {
            while(rs.next()) {
                articles.add(new Article(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4)));
            }
        } catch (final Exception ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
        return articles;
    }

    public Site insertSite(String url) {
        Site site = new Site(url);
        SyndFeed feed = Fetcher.getInstance().fetchSite(site.url);
        dealFeed(feed, site, new Timestamp(0));
        return site;
    }

    public void dealFeed(SyndFeed feed, Site site, Timestamp lastLoadTime) {
        ArrayList<SyndEntry> entries = Fetcher.getInstance().getEntrys(feed);
        for (SyndEntry entry : entries) {
            if (((Timestamp)entry.getPublishedDate()).after(lastLoadTime)) {
                new Article(site, entry.getTitle(), entry.getDescription().getValue());
            }
        }
    }

    public static void main(final String[] args) {
        Mapper.getInstance().insertSite("http://www.36kr.com/feed");
    }
}
