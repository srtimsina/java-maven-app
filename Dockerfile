FROM tomcat:10.1-jdk25-temurin

COPY target/java-maven-app.war /usr/local/tomcat/webapps/java-maven-app.war

EXPOSE 8080
