package org.kilnyy.feedreader;

import java.net.URL;
import java.util.Iterator;

import org.rometools.fetcher.FeedFetcher;
import org.rometools.fetcher.FetcherEvent;
import org.rometools.fetcher.FetcherListener;
import org.rometools.fetcher.impl.FeedFetcherCache;
import org.rometools.fetcher.impl.HashMapFeedInfoCache;
import org.rometools.fetcher.impl.HttpURLFeedFetcher;
import com.sun.syndication.feed.synd.SyndFeed;
import com.sun.syndication.feed.synd.SyndEntry;
import java.util.ArrayList;

public class Fetcher {

    private static Fetcher instance;
    private FeedFetcher fetcher;

    public static Fetcher getInstance() {
        if (instance == null) {
            instance = new Fetcher();
            return instance;
        } else {
            return instance;
        }
    }
    
    public Fetcher() {
        try {
            final FeedFetcherCache feedInfoCache = HashMapFeedInfoCache.getInstance();
            fetcher = new HttpURLFeedFetcher(feedInfoCache);
            final FetcherEventListenerImpl listener = new FetcherEventListenerImpl();
            fetcher.addFetcherEventListener(listener);
        } catch (final Exception ex) {
            System.err.println("ERROR: " + ex.getMessage());
            ex.printStackTrace();
        }
    }

    class FetcherEventListenerImpl implements FetcherListener {
        @Override
        public void fetcherEvent(final FetcherEvent event) {
            final String eventType = event.getEventType();
            if (FetcherEvent.EVENT_TYPE_FEED_POLLED.equals(eventType)) {
                System.err.println("Feed Polled.    " + event.getUrlString());
            } else if (FetcherEvent.EVENT_TYPE_FEED_UNCHANGED.equals(eventType)) {
                System.err.println("Feed Unchanged. " + event.getUrlString());
            } else if (FetcherEvent.EVENT_TYPE_FEED_RETRIEVED.equals(eventType)) {
                System.err.println("Feed Retrieved. " + event.getUrlString());
            }
        }
    }

    public SyndFeed fetchSite(String url) {
        try {
            final URL feedUrl = new URL(url);
            final SyndFeed feed = fetcher.retrieveFeed(feedUrl);
            return feed;
        } catch (final Exception ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
        return null;
    }

    public ArrayList<SyndEntry> getEntrys(SyndFeed feed) {
        ArrayList<SyndEntry> res = new ArrayList<SyndEntry>();
        for ( Object entry : feed.getEntries()) {
                res.add((SyndEntry)entry);
        }
        return res;
    }

    public static void main(final String[] args) {
        SyndFeed feed = null;
        if (args.length == 1) {
            feed = Fetcher.getInstance().fetchSite(args[0]);
        }

        if (null == feed) {
            System.out.println("FeedFetcher reads and prints any RSS/Atom feed type.");
            System.out.println("The first parameter must be the URL of the feed to read.");
        }

    }
}
