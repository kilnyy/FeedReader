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

    Article(Integer _id, Integer _siteId, String _title, String _content) {
        id = _id;
        siteId = _siteId;
        title = _title;
        content = _content;
    }

    Article(Site site, String _title, String _content) {
        siteId = site.id;
        title = _title;
        content = _content;
        Adapter adapter = new Adapter();
        adapter.execUpdate("INSERT INTO articles VALUES(default, "
                     + siteId + ",'"
                     + title + "','"
                     + content + "')'");
    }
}
