#!/bin/bash

docker rmi prune
docker build -t skynetweb .
echo y | docker images prune
docker images
docker container ps -a
