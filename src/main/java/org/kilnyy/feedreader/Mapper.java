package org.kilnyy.feedreader;

import org.kilnyy.feedreader.Adapter;
import org.kilnyy.feedreader.Fetcher;
import org.kilnyy.feedreader.Site;
import org.kilnyy.feedreader.Article;
import org.kilnyy.feedreader.User;
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

    public User getUser(String email, String password) {
        User user = new User(email, password);
        if (user == null || user.id == -1) return null;
        return user;
    }

    public User getUser(Integer id) {
        User user = new User(id);
        if (user == null || user.id == -1) return null;
        return user;
    }

    private ArrayList<Site> getAllSites(ResultSet rs) {
        ArrayList<Site> sites = new ArrayList<Site>();
        try {
            while(rs.next()) {
                sites.add(new Site(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getTimestamp(4)));
            }
        } catch (final Exception ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
        return sites;
    }

    public ArrayList<Site> getAllSites(User user) {
        if (user == null) return new ArrayList<Site>();
        Adapter adapter = new Adapter();
        ResultSet rs = adapter.execQuery("SELECT sites.id, sites.title, url, last_load_time FROM sites"
                                         + " JOIN rel_users_subscribe_sites ON (sites.id = site_id)"
                                         + " WHERE user_id = " + user.id);
        return getAllSites(rs);
    }

    public ArrayList<Site> getAllSites() {
        Adapter adapter = new Adapter();
        ResultSet rs = adapter.execQuery("SELECT * FROM sites");
        return getAllSites(rs);
    }

    public void updateAllSites() {
        ArrayList<Site> sites = getAllSites();
        for (Site site : sites) {
            dealFeed(site);
        }
    }

    private ArrayList<Article> getAllArticles(ResultSet rs) {
        ArrayList<Article> articles = new ArrayList<Article>();
        try {
            while(rs.next()) {
                articles.add(new Article(rs.getInt(1), rs.getInt(2), rs.getString(3), 
                                         rs.getString(4), rs.getTimestamp(5)));
            }
        } catch (final Exception ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
        return articles;
    }

    public ArrayList<Article> getAllArticles(User user) {
        if (user == null) return new ArrayList<Article>();
        Adapter adapter = new Adapter();
        ResultSet rs = adapter.execQuery("SELECT articles.id, articles.site_id, articles.title, "
                                         + " content, published_date"
                                         + " FROM articles" 
                                         + " JOIN sites ON (articles.site_id = sites.id)"
                                         + " JOIN rel_users_subscribe_sites r ON (sites.id = r.site_id)"
                                         + " WHERE user_id = " + user.id
                                         + " ORDER BY published_date desc LIMIT 50");
        return getAllArticles(rs);
    }

    public ArrayList<Article> getAllArticles() {
        Adapter adapter = new Adapter();
        ResultSet rs = adapter.execQuery("SELECT * FROM articles" 
                                         + "ORDER BY published_date desc LIMIT 50");
        return getAllArticles(rs);
    }

    public Site insertSite(String url) {
        Site site = new Site(url);
        if (site.id == -1) {
            return null;
        }
        dealFeed(site);
        return site;
    }

    public Site collectionSite(User user, String url) {
        Site site = insertSite(url);
        if (site != null) {
            Adapter adapter = new Adapter();
            try {
                adapter.getPs("INSERT INTO rel_users_subscribe_sites VALUES(?, ?)");
                adapter.ps.setInt(1, user.id);
                adapter.ps.setInt(2, site.id);
                adapter.execPs();
            } catch (final Exception ex) {
                System.err.println("ERROR: " + ex.getMessage());
            }
        }
        return site;
    }

    public Site Site(User user, String url) {
        Site site = insertSite(url);
        if (site != null) {
            Adapter adapter = new Adapter();
            try {
                adapter.getPs("INSERT INTO rel_users_subscribe_sites VALUES(?, ?)");
                adapter.ps.setInt(1, user.id);
                adapter.ps.setInt(2, site.id);
                adapter.execPs();
            } catch (final Exception ex) {
                System.err.println("ERROR: " + ex.getMessage());
            }
        }
        return site;
    }

    public void dealFeed(Site site) {
        SyndFeed feed = Fetcher.getInstance().fetchSite(site.url);
        ArrayList<SyndEntry> entries = Fetcher.getInstance().getEntrys(feed);
        for (SyndEntry entry : entries) {
            if (site.lastLoadTime.compareTo(entry.getPublishedDate()) == -1) {
                new Article(site, entry.getTitle(), entry.getDescription().getValue(),
                            new Timestamp(entry.getPublishedDate().getTime()));
            }
        }
        site.updateLastLoadTime();
    }
}
