# Step 1: Build the Java program
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app
COPY . .
RUN javac Welcome.java

# Step 2: Create a lightweight runtime image
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app /app
CMD ["java", "Welcome"]

