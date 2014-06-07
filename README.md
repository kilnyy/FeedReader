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
    $ cp target/feedreader-jar-with-dependencies.jar path/to/your/tomcat/jar/path

Then start tomcat:
       
    $ catalina start

Then point your browser at [http://localhost:8080/feedreader](http://localhost:8080/feedreader).
