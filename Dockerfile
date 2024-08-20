# Etapa de construcción
FROM maven:3.8.4-openjdk-17 AS build

# Establecer un directorio de trabajo
WORKDIR /app

# Copiar solo el archivo pom.xml y descargar las dependencias
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar el resto de los archivos del proyecto
COPY src /app/src

# Construir el proyecto
RUN mvn clean package -DskipTests

# Etapa de ejecución
FROM openjdk:17-jdk-slim

# Establecer un directorio de trabajo
WORKDIR /app

# Copiar el archivo JAR desde la etapa de construcción
COPY --from=build /app/target/prueba-0.0.1-SNAPSHOT.jar /app/prueba-0.0.1-SNAPSHOT.jar

# Exponer el puerto que utilizará la aplicación
EXPOSE 8080

# Establecer el punto de entrada para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "/app/prueba-0.0.1-SNAPSHOT.jar"]
