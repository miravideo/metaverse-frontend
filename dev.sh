TAG=${1:-latest}

docker run --rm -it \
    -p 8080:8080 \
     metaverse-frontend:$TAG