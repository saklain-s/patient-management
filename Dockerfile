# ---------- Build stage ----------
FROM maven:3.9.9-eclipse-temurin-21 AS builder

WORKDIR /app

# 1️⃣ Copy only the service module’s pom.xml first so dependency downloads are cached
COPY patient-service/pom.xml .

RUN mvn dependency:go-offline -B

# 2️⃣ Copy the service module’s source code
COPY patient-service/src ./src

# 3️⃣ Build the jar (tests will run normally)
RUN mvn clean package


# ---------- Runtime stage ----------
FROM openjdk:21-jdk AS runner

WORKDIR /app

# 4️⃣ Copy the jar produced by the builder
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 4000

ENTRYPOINT ["java", "-jar", "app.jar"]
