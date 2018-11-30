#!/bin/bash

docker stop skynetdmz
docker rm skynetdmz

docker run -ti --name skynetdmz --hostname skynetdmz \
           --rm --cap-add=NET_ADMIN --device=/dev/net/tun -d \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v /home/cloud/git/docker/skynetdmz/data/:/data \
           -v /etc/localtime:/etc/localtime:ro \
	   --env-file /home/cloud/git/docker/skynetdmz/files/skynetdmz.env \
           --log-driver json-file \
           --log-opt max-size=10m \
           -p 9091:9091 \
           -p 82:22 \
	   --dns 8.8.8.8 --dns 8.8.4.4 \
	   skynetdmz

# list open ports
docker container ps -a
docker port skynetdmz
docker logs skynetdmz

## CONNECT
# docker exec -it skynetdmz /bin/bash
# ssh-keygen -f "/home/xpro/.ssh/known_hosts" -R "[localhost]:82"
# ssh localhost -p 84
