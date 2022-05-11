TAG=${1:-latest}

docker tag metaverse-frontend:latest mirav.tencentcloudcr.com/mira/metaverse-frontend:${TAG}
docker push mirav.tencentcloudcr.com/mira/metaverse-frontend:${TAG}