#!/bin/bash

# Переменные
GITHUB_USER="dmitriyvechorko"
REPO_NAME="reportsmodule"
IMAGE_NAME="ghcr.io/$GITHUB_USER/$REPO_NAME"
TAG="latest"

# Проверка наличия токена
if [ -z "$GITHUB_TOKEN" ]; then
  echo "❌ Ошибка: GITHUB_TOKEN не установлен"
  exit 1
fi

# Шаг 1: Сборка Docker-образа с правильным именем
echo "🏗️ Сборка Docker-образа..."
docker build -t $REPO_NAME:$TAG .
if [ $? -ne 0 ]; then
    echo "❌ Ошибка сборки Docker-образа"
    exit 1
fi

# Шаг 2: Логин в GitHub Container Registry
echo "🔐 Логин в GitHub Container Registry..."
echo "$GITHUB_TOKEN" | docker login ghcr.io --username $GITHUB_USER --password-stdin
if [ $? -ne 0 ]; then
    echo "❌ Ошибка авторизации в GHCR"
    exit 1
fi

# Шаг 3: Добавление правильного тэга для GHCR
echo "🏷️ Добавление тэга ghcr.io/$GITHUB_USER/$REPO_NAME:$TAG"
docker tag $REPO_NAME:$TAG $IMAGE_NAME:$TAG

# Шаг 4: Загрузка образа
echo "📦 Загрузка образа в GHCR..."
docker push $IMAGE_NAME:$TAG
if [ $? -ne 0 ]; then
    echo "❌ Ошибка загрузки образа в GHCR"
    exit 1
fi

echo "✅ Образ успешно загружен в GitHub Container Registry: $IMAGE_NAME:$TAG"