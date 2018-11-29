#!/bin/bash

sudo \rm -fr /home/cloud/git/docker/skynetdmz/data/*

#docker rmi prune
docker build -t skynetdmz .
docker images
docker container ps -a
