# syntax=docker/dockerfile:1

FROM node:24-alpine AS frontend-build
WORKDIR /frontend

COPY frontend/package*.json ./
RUN npm ci

COPY frontend/ .
RUN npm run build

FROM eclipse-temurin:21-jdk-alpine AS backend-build
WORKDIR /app

COPY gradlew ./
COPY gradle ./gradle
RUN chmod +x gradlew

COPY build.gradle* settings.gradle* ./
RUN ./gradlew --version

COPY src ./src

RUN rm -rf src/main/resources/static
COPY --from=frontend-build /frontend/dist ./src/main/resources/static


RUN ./gradlew clean build --no-daemon


FROM eclipse-temurin:21-jre-alpine AS runtime
WORKDIR /app

ENV SPRING_PROFILES_ACTIVE=dev

COPY --from=backend-build /app/build/libs/*-SNAPSHOT.jar app.jar

EXPOSE 8080
EXPOSE 9090

ENTRYPOINT ["java", "-jar", "app.jar"]