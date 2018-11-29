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
	   --dns 8.8.8.8 --dns 8.8.4.4 \
	   skynetdmz

## CONNECT
docker exec -it skynetdmz /bin/bash
