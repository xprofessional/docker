# https://hub.docker.com/r/haugene/transmission-openvpn/
# https://docs.docker.com/engine/examples/running_ssh_service/
FROM ubuntu:latest

VOLUME /tsfr

# Update, upgrade and install core software
RUN apt update \
    && apt -y upgrade \
    && apt -y install software-properties-common wget git curl jq \
    && apt update \
    && apt install -y sudo rar unrar zip unzip ufw iputils-ping openvpn bc tzdata \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update Repos
RUN \
    # GOOGLE CHROME
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
    && add-apt-repository "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
    # GRAFANA
    && curl https://packages.grafana.com/gpg.key | sudo apt-key add - \
    && add-apt-repository "deb https://packages.grafana.com/oss/deb stable main" \
    # INFLUX DB
    && curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://repos.influxdata.com/ubuntu $(lsb_release -cs) stable" \
    # WEBMIN
    && wget -q -O - http://www.webmin.com/jcameron-key.asc | sudo apt-key add - \
    && add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib" \
    # DOCKER
    #&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
    #&& add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    # TRUECRYPT
    && add-apt-repository ppa:stefansundin/truecrypt \
    && apt -y update

 # Install Packages
 RUN apt install -y git manpages p7zip unzip vim \
    && apt install -y net-tools openssh-server network-manager-openvpn network-manager network-manager-openvpn-gnome nfs-kernel-server \
    && apt install -y hddtemp iotop lm-sensors nethogs nmap smartmontools \
    && apt install -y snmpd snmp snmp-mibs-downloader telegraf webmin \
    && apt install -y google-chrome-stable xvfb xrdp
    && apt install -y apache2 openssl \
    && apt install -y python python-pip \
    && apt install -y influxdb grafana
 
# Cleanup installation
RUN apt autoremove \
    && apt autoclean \
    && apt purge $(dpkg -l linux-{image,headers}-"[0-9]*" | awk '/ii/{print $2}' | grep -ve "$(uname -r | sed -r 's/-[a-z]+//')") \
    && \rm -fr /var/lib/apt/lists/* /var/cache/apt*
 
 
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
COPY files/skynetweb.env /root/
COPY files/skynetweb.env /home/xpro

RUN  chown ${USER}:${GROUP} -R /home/xpro/* && \
     chown ${USER}:${GROUP} -R /home/xpro/.*

EXPOSE 22

ENTRYPOINT ["/docker-entrypoint.sh"]