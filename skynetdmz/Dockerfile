# https://hub.docker.com/r/haugene/transmission-openvpn/
FROM haugene/transmission-openvpn

RUN apt-get update && apt-get install -y curl firefox vim sudo network-manager-openvpn network-manager 

ENV USER=xpro
ENV GROUP=xpro
RUN sudo adduser --disabled-password --quiet xpro \
 && sudo addgroup $USER $GROUP \
 && sudo chown -R $USER:$GROUP /home/$USER \
 && echo "xpro:docker" | chpasswd  \
 && adduser $USER sudo

COPY files/bashrc.root /root/.bashrc
COPY files/ipinfo.sh /root/
#COPY files/bashrc.xpro /home/xpro/.bashrc
#    chown ${USER}:${GROUP} -R /home/xpro/*

#USER xpro
#ENV HOME /home/xpro
#WORKDIR /home/xpro
#CMD tail -f /dev/null
#CMD /bin/bash
