
RUN mvn package
FROM tomcat:8.0.20-jre8
EXPOSE 6000
#default command
CMD java -jar /data/hello-world-0.1.0.jar
# Dummy text to test 
COPY target/java-web-app*.war /usr/local/tomcat/webapps/java-web-app.war
