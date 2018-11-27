##############################################################################
## Dockerfile: 
##############################################################################

FROM ubuntu:18.04 
MAINTAINER xprofessional "https://github.com/xprofessional"

RUN apt-get update \
    && apt-get install -y curl wget vim-tiny git openssh-server

RUN mkdir /var/run/sshd \
 && echo 'root:root' | chpasswd \
 && sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
 && mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]
# CMD tail -f /dev/null
