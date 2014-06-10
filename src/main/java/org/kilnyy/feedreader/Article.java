package org.kilnyy.feedreader;

import org.kilnyy.feedreader.Adapter;
import org.kilnyy.feedreader.Fetcher;
import org.kilnyy.feedreader.Site;

import com.sun.syndication.feed.synd.SyndFeed;

import java.sql.ResultSet;
import java.sql.Timestamp;

public class Article {
    public Integer id;
    public Integer siteId;
    public String title;
    public String content;
    public Timestamp publishedDate;

    Article(Integer _id, Integer _siteId, String _title, String _content, Timestamp _publishedDate) {
        id = _id;
        siteId = _siteId;
        title = _title;
        content = _content;
        publishedDate = _publishedDate;
    }

    Article(Site site, String _title, String _content, Timestamp _publishedDate) {
        siteId = site.id;
        title = _title;
        content = _content;
        publishedDate = _publishedDate;
        try {
            Adapter adapter = new Adapter();
            adapter.getPs("INSERT INTO articles(site_id, title, content, published_date) VALUES(?, ?, ?, ?)");
            adapter.ps.setInt(1, siteId);
            adapter.ps.setString(2, title);
            adapter.ps.setString(3, content);
            adapter.ps.setTimestamp(4, publishedDate);
            adapter.execPs();
        } catch (Exception ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
    }
}
