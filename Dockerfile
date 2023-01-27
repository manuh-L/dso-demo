#Stage 0 - Build artifact from source
FROM maven:3.8.7-openjdk-18 AS BUILD
WORKDIR /app
COPY .  .
RUN mvn package -DskipTests

#Stage 1 - package app to Run

FROM openjdk:18-alpine AS RUN
WORKDIR /run
COPY --from=BUILD /app/target/demo-0.0.1-SNAPSHOT.jar demo.jar
ARG USER=devops
ENV HOME /home/$USER
RUN  adduser -D $USER && chown $USER:$USER /run/demo.jar
USER $USER
EXPOSE 8080
CMD java  -jar /run/demo.jar
