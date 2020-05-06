#!/bin/bash

IMAGE=skynetweb

docker stop ${IMAGE}
docker rm ${IMAGE}

docker run -ti --name ${IMAGE} --hostname ${IMAGE} \
           --rm --cap-add=NET_ADMIN --device=/dev/net/tun -d \
           --mac-address 00:17:f2:cd:5d:9f \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v /home/cloud/git/docker/${IMAGE}/tsfr/:/tsfr \
           -v /etc/localtime:/etc/localtime:ro \
     --env-file /home/cloud/git/docker/${IMAGE}/files/${IMAGE}.env \
           --log-driver json-file \
           --log-opt max-size=10m \
           -p 9091:9091 \
           -p 8022:22 \
	   --dns 8.8.8.8 --dns 8.8.4.4 \
	   ${IMAGE}

# list open ports
docker exec ${IMAGE} env
docker container ps -a
docker port ${IMAGE}
docker logs ${IMAGE}

## LINK XDISPLAY FROM HOST
xhost +local:

## CLEAN SSH KEY
ssh-keygen -f "/home/xpro/.ssh/known_hosts" -R "[localhost]:8222"

## CONNECT TO DOCKER
# docker exec -it skynetdmz /bin/bash
# OR
# ssh [root;xpro]@localhost -p 8222 [docker]
# (docker) firefox
# (host) firefox http://localhost:9091

