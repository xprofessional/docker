#!/bin/bash

docker stop skynetweb
docker rm skynetweb
#docker rmi $(docker images -q)
docker images
docker container ps -a
