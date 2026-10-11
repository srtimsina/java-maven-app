# Java Maven Web App

A small Jakarta Servlet application packaged as a WAR for Apache Tomcat 10.1 or newer.

## Build

Requires JDK 17 and Maven 3.8 or newer.

```sh
mvn clean verify
```

The deployable archive is created at `target/java-maven-app.war`.

## Deploy to Tomcat

Copy the WAR into Tomcat's `webapps` directory and start or restart Tomcat:

```sh
cp target/java-maven-app.war "$CATALINA_BASE/webapps/"
```

Open `http://localhost:8080/java-maven-app/` and follow the link to the `/hello` servlet.

## Continuous integration

Use Jenkins to run `mvn --batch-mode --no-transfer-progress clean verify` and archive `target/java-maven-app.war` as a build artifact. The Jenkins agent needs JDK 17 and Maven 3.8 or newer.
