FROM ubuntu:latest as build

RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    maven

WORKDIR /gatewaysservice

COPY pom.xml .

COPY . .

RUN mvn clean package


FROM openjdk:17-jdk-slim

WORKDIR /gatewaysservice

COPY --from=build /gatewaysservice/target/gatewaysservice-0.0.1-SNAPSHOT.jar gatewaysservice.jar

ENV DATA_DIR=/var/lib/data
CMD ["java", "-jar", "gatewaysservice.jar"]