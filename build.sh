TAG=${1:-latest}

docker build -t metaverse-frontend:$TAG  -f ./docker/Dockerfile .
