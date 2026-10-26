# Java Maven Web App

A small Jakarta Servlet application packaged as a WAR for Apache Tomcat 10.1 or newer.

## Build

Requires JDK 17 or newer and Maven 3.8 or newer. The Docker image runs on JDK 25, the latest LTS release; Maven continues to target Java 17 bytecode.

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

The [Jenkinsfile](./Jenkinsfile) runs the Maven tests and package, archives `target/java-maven-app.war`, then builds and pushes `suryaraj/nodejs-app:<BUILD_NUMBER>` to Docker Hub. Configure a Jenkins **Username with password** credential with the ID `dockerhub-credentails`; the credential's Docker Hub account must have push access to `suryaraj/nodejs-app`. The Jenkins agent needs JDK 17 or newer, Maven 3.8 or newer, and Docker access.
