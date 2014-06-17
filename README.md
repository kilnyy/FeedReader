FeedReader
============
A online rss reader.

Github repo link: https://github.com/kilnyy/FeedReader

Please go to http://reader.ourbears.cn:8080/feedreader/login.jsp to try it out

Hier
-----------------
/src FeedReader Source Code

/sql Database script

/doc Final project report

Getting Start
-----------------
To run this webapp, you need `maven` and `tomcat`.

First you need to import sql/FeedReader.sql to your MySQL database.

Then create src/main/resources/database.properties to setting database config.

To build the webapp, run the following command:

    $ mvn package

To start the release in tomat:

    $ cp target/feedreader.war path/to/your/tomcat/path
    
To run article updating program in foreground:

    $ java -cp target/feedreader-jar-with-dependencies.jar org.kilnyy.feedreader.Runner 600000

Then start tomcat:
       
    $ catalina start

Then point your browser at [http://localhost:8080/feedreader](http://localhost:8080/feedreader).
