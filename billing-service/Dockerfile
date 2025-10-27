# ---------- Build stage ----------
FROM maven:3.9.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy only the pom.xml first to cache dependencies
COPY pom.xml .

RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the JAR
RUN mvn clean package -DskipTests


# ---------- Runtime stage ----------
FROM openjdk:21-jdk AS runner

WORKDIR /app

# ✅ FIXED: correct source path (no extra /app)
COPY --from=builder /app/target/billing-service-0.0.1-SNAPSHOT.jar ./app.jar

# Expose billing-service port
EXPOSE 4001
# Optional management port
EXPOSE 9001

ENTRYPOINT ["java", "-jar", "app.jar"]
