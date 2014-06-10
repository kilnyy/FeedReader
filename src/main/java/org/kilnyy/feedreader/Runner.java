package org.kilnyy.feedreader;

import org.kilnyy.feedreader.Mapper;

public class Runner {
    public static void main(final String[] args) {
        int interval = 10000;
        try {
            if (args.length == 1) {
                interval = Integer.parseInt(args[0]);
            }
            System.err.println("Starting...");
            while (true) {
                System.err.println("Updating...");
                Mapper.getInstance().updateAllSites();
                Thread.sleep(interval);
            }
        } catch (InterruptedException ex){
            System.err.println("End");
        } catch (Exception ex) {
            System.err.println("ERROR: " + ex.getMessage());
        }
    }
}
