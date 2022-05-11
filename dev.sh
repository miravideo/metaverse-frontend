TAG=${1:-latest}

docker run --rm -it \
    -p 1989:8081 \
     metaverse-frontend:$TAG