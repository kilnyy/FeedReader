FeedReader
============
A online rss reader.

Getting Start
-----------------
To run this webapp, you need `maven` and `tomcat`.

To build the webapp, run the following command:

    $ mvn package

To start the release in tomat:

    $ cp target/feedreader.war path/to/your/tomcat/path
    
To run article updating program in foreground:

    $ java -cp target/feedreader-jar-with-dependencies.jar org.kilnyy.feedreader.Runner 600000

Then start tomcat:
       
    $ catalina start

Then point your browser at [http://localhost:8080/feedreader](http://localhost:8080/feedreader).
