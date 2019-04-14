#!/bin/bash

docker stop skynetdmz
docker rm skynetdmz

docker run -ti --name skynetdmz --hostname skynetdmz \
           --rm --cap-add=NET_ADMIN --device=/dev/net/tun -d \
           --mac-address 00:17:f2:cd:5d:9f \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v /home/cloud/git/docker/skynetdmz/data/:/data \
           -v /etc/localtime:/etc/localtime:ro \
     --env-file /home/cloud/git/docker/skynetdmz/files/skynetdmz.env \
           --log-driver json-file \
           --log-opt max-size=10m \
           -p 9091:9091 \
           -p 8222:22 \
	   --dns 8.8.8.8 --dns 8.8.4.4 \
	   skynetdmz

# list open ports
docker container ps -a
docker port skynetdmz
docker logs skynetdmz

## LINK XDISPLAY FROM HOST
xhost +local:

## CONNECT TO DOCKER
# docker exec -it skynetdmz /bin/bash
# OR
# ssh-keygen -f "/home/xpro/.ssh/known_hosts" -R "[localhost]:8222"
# ssh localhost -p 8222
# (docker) firefox
# (host) firefox http://localhost:9091

