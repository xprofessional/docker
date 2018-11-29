#!/bin/bash

docker stop skynetdmz
docker rm skynetdmz

docker run -ti --name skynetdmz --hostname skynetdmz \
           --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
	   --cap-add=NET_ADMIN --device=/dev/net/tun -d \
           -v /home/cloud/git/docker/skynetdmz/data/:/data \
           -v /etc/localtime:/etc/localtime:ro \
           -e OPENVPN_PROVIDER=PIA \
           -e OPENVPN_CONFIG=Hong\ Kong \
           -e OPENVPN_USERNAME=p0299086 \
           -e OPENVPN_PASSWORD= \
           -e WEBPROXY_ENABLED=false \
           -e LOCAL_NETWORK=192.168.10.10/90 \
           --log-driver json-file \
           --log-opt max-size=10m \
           -p 9091:9091 \
	   --dns 8.8.8.8 --dns 8.8.4.4 \
	   skynetdmz

## CONNECT
# docker exec -it skynetdmz /bin/bash
