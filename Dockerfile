# Ubuntu:20.04
# OpenJDK 8
# Maven 3.2.2
# Git
# Nano

# pull base image Ubuntu
FROM ubuntu:20.04

MAINTAINER katapios

# this is a non-interactive automated build - avoid some warning messages
ENV DEBIAN_FRONTEND noninteractive

# install the OpenJDK 11 java runtime environment
RUN apt-get update && apt-get upgrade
RUN apt-get install -y \
openjdk-11-jdk \
git

RUN apt-get clean

ENV JAVA_HOME /usr
ENV PATH $JAVA_HOME/bin:$PATH

# install maven
RUN apt-get install -y maven
ENV MAVEN_HOME /opt/maven

WORKDIR "/opt"

# go to github for the project and copy it
RUN git clone https://github.com/Katapios/simple-java11-spring-app.git .

RUN mvn package

# configure the container to run app, mapping container port 8081 to that host port
ENTRYPOINT ["java", "-jar", "/opt/target/SpringHello-0.0.1-SNAPSHOT.war"]

EXPOSE 8081

CMD [""]