FROM tomcat:10.1-jdk25-temurin

COPY target/java-maven-app.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
