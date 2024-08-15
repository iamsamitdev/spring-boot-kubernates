# creates a layer from the openjdk:17-alpine Docker image.
FROM openjdk:17-alpine

# cd /app
WORKDIR /app

# Refer to Maven build -> finalName
ARG JAR_FILE=target/demo-*.jar

# cp target/spring-boot-docker-0.0.1-SNAPSHOT.jar /app/spring-boot-docker.jar
COPY ${JAR_FILE} demo.jar

# java -jar /app/spring-boot-docker.jar
CMD ["java", "-jar", "-Xmx1024M", "/app/demo.jar"]

# Make port 9090 available to the world outside this container
EXPOSE 9090