#!/bin/bash

#sudo chown xpro:xpro /home/cloud/git/docker/skynetdmz/data/*
#sudo rm -fr /home/cloud/git/docker/skynetdmz/data/*

docker rmi prune
docker build -t skynetdmz .
echo y | docker images prune
docker images
docker container ps -a
