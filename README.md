Модуль для формирования и дальнейшего скачивания отчётов.

Как запустить:
git clone https://github.com/dmitriyvechorko/reportsmodule.git 
cd reportsmodule


export GITHUB_USER=dmitriyvechorko
export GITHUB_TOKEN=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

echo "$GITHUB_TOKEN" | docker login ghcr.io --username $GITHUB_USER --password-stdin

docker pull ghcr.io/dmitriyvechorko/reportsmodule:latest

docker run -d \
  --name report-app \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5432/productdb \
  -e SPRING_DATASOURCE_USERNAME=postgres \
  -e SPRING_DATASOURCE_PASSWORD=root \
  ghcr.io/dmitriyvechorko/reportsmodule:latest

  docker-compose up -d
