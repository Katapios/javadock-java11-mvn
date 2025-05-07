# Этап 1: сборка фронтенда
FROM node:18 AS frontend
WORKDIR /app

RUN git clone https://github.com/Katapios/simple-java11-spring-app.git
WORKDIR /app/simple-java11-spring-app/frontend

RUN npm install
RUN npm run build

# Этап 2: сборка backend .war
FROM maven:3.9.6-eclipse-temurin-11 AS backend
WORKDIR /app

RUN git clone https://github.com/Katapios/simple-java11-spring-app.git

COPY --from=frontend /app/simple-java11-spring-app/frontend/dist/ /app/simple-java11-spring-app/src/main/resources/static/

WORKDIR /app/simple-java11-spring-app
RUN mvn clean package -DskipTests

# Этап 3: финальный рантайм
FROM openjdk:11-jre-slim
WORKDIR /app

COPY --from=backend /app/simple-java11-spring-app/target/SpringHello-0.0.1-SNAPSHOT.war app.war

EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.war"]