package org.kilnyy.feedreader;

import org.kilnyy.feedreader.Adapter;
import org.kilnyy.feedreader.Fetcher;

import com.sun.syndication.feed.synd.SyndFeed;

import java.sql.ResultSet;
import java.sql.Timestamp;

public class Site {
    public Integer id;
    public String title;
    public String url;
    public Timestamp lastLoadTime;

    Site(Integer _id, String _title, String _url, Timestamp _lastLoadTime) {
        id = _id;
        title = _title;
        url = _url;
        lastLoadTime = _lastLoadTime;
    }

    Site(String _url) {
        Adapter adapter = new Adapter();
        ResultSet rs = adapter.execQuery("SELECT * FROM sites WHERE url = '" + _url + "'");
        try {
            if (rs.next()) {
                id = rs.getInt(1);
                title = rs.getString(2);
                url = _url;
                lastLoadTime = rs.getTimestamp(4);
            } else {
                SyndFeed feed = Fetcher.getInstance().fetchSite(_url);
                if (feed != null) {
                    adapter.execUpdate("INSERT INTO sites(title, url) VALUES('" 
                                      + feed.getTitle() + "','"
                                      + _url + "'" 
                                      + ")");
                    rs = adapter.execQuery("SELECT * FROM sites WHERE url = '" + _url + "'");
                    if (rs.next()) {
                        id = rs.getInt(1);
                        title = rs.getString(2);
                        url = _url;
                        lastLoadTime = new Timestamp(0);
                    }
                } else {
                    id = -1;
                }
            }
        } catch (final Exception ex) {
            id = -1;
            System.err.println("ERROR: " + ex.getMessage());
        }
    }

    public void updateLastLoadTime() {
        Adapter adapter = new Adapter();
        adapter.execUpdate("UPDATE sites SET last_load_time = CURRENT_TIMESTAMP Where id = " + id); 
    }
}
