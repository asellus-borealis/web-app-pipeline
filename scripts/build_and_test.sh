#!/bin/bash
set -e

echo "Starting automated build and test pipeline..."

# Запуск сборки и тестов через локальный Maven Wrapper
./mvnw clean package -DskipTests=false

echo "Build and test completed successfully."
