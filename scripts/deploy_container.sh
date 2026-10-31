#!/bin/bash
set -e

IMAGE_NAME="web-app-pipeline"
TAG="latest"
CONTAINER_NAME="web-app-instance"
HOST_PORT=8080
CONTAINER_PORT=8080

echo "Starting automated container deployment..."

# 1. Проверяем и останавливаем любой контейнер, занимающий порт HOST_PORT или с таким же именем
echo "Cleaning up conflicting containers..."
PORT_CONTAINERS=$(docker ps -q --filter "publish=${HOST_PORT}")
if [ -n "$PORT_CONTAINERS" ]; then
    echo "Stopping container(s) using port ${HOST_PORT}..."
    docker stop $PORT_CONTAINERS || true
    docker rm $PORT_CONTAINERS || true
fi

if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "Removing existing container: ${CONTAINER_NAME}"
    docker stop ${CONTAINER_NAME} || true
    docker rm ${CONTAINER_NAME} || true
fi

# 2. Собираем Docker-образ из Dockerfile
echo "Building Docker image: ${IMAGE_NAME}:${TAG}..."
docker build -t ${IMAGE_NAME}:${TAG} .

# 3. Запускаем контейнер в фоновом режиме с пробросом портов
echo "Running container ${CONTAINER_NAME} on port ${HOST_PORT}..."
docker run -d \
  -p ${HOST_PORT}:${CONTAINER_PORT} \
  --name ${CONTAINER_NAME} \
  ${IMAGE_NAME}:${TAG}

# 4. Проверяем статус развернутого контейнера
echo "Container deployment finished successfully."
docker ps -f name=^/${CONTAINER_NAME}$
