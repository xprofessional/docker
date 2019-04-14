# https://hub.docker.com/r/haugene/transmission-openvpn/
# https://docs.docker.com/engine/examples/running_ssh_service/
FROM haugene/transmission-openvpn

RUN apt-get update && apt-get install -y curl firefox vim sudo network-manager-openvpn network-manager openssh-server

RUN mkdir /var/run/sshd && \
    echo 'root:docker' | chpasswd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    # SSH login fix. Otherwise user is kicked off after login 
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile && \
    update-rc.d ssh defaults && \
    systemctl enable ssh.socket && \
    systemctl enable ssh

ENV NOTVISIBLE "in users profile"
ENV USER=xpro
ENV GROUP=xpro
RUN adduser --disabled-password --quiet xpro \
 && addgroup $USER $GROUP \
 && chown -R $USER:$GROUP /home/$USER \
 && echo "xpro:docker" | chpasswd  \
 && adduser $USER sudo

RUN mkdir /root/.ssh && \
    mkdir /home/xpro/.ssh

COPY files/docker-entrypoint.sh /
COPY files/bashrc /root/.bashrc
COPY files/bashrc /home/xpro/.bashrc
COPY files/ipinfo.sh /root/
COPY files/ipinfo.sh /home/xpro
COPY files/skynetdmz.env /root/
COPY files/skynetdmz.env /home/xpro
COPY files/browse.sh /root/
COPY files/browse.sh /home/xpro
RUN  chown ${USER}:${GROUP} -R /home/xpro/* && \
     chown ${USER}:${GROUP} -R /home/xpro/.*

EXPOSE 22

ENTRYPOINT ["/docker-entrypoint.sh"]
