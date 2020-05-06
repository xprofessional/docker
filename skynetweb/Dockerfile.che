##############################################################################
## Dockerfile: UBUNTU Base
##  Python, Pip, Selenium, Google-Chrome, Chromedriver
## https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/~/dockerfile/
## https://github.com/eclipse/che-dockerfiles/tree/master/recipes
## https://github.com/eclipse/che-dockerfiles/tree/master/recipes/stack-base/ubuntu
##############################################################################

################################################################################
# base system
################################################################################
#FROM ubuntu:18.04 as system
#FROM ubuntu:16.04 as system
#FROM eclipse/che
FROM eclipse/ubuntu_python

##### BUILT-IN PKGS #####
RUN sudo apt-get update \
    &&  sudo apt-get install -y --no-install-recommends --allow-unauthenticated curl wget apt-utils software-properties-common

##### ADD CUSTOM KEYS & REPOS #####
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
    && sudo rm -f /etc/apt/sources.list.d/google.list \
    && sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    && sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
    && sudo sh -c 'echo "deb http://linux.dropbox.com/ubuntu ${DISTRIB_CODENAME} main" >> /etc/apt/sources.list.d/dropbox.list'
    && curl https://packagecloud.io/gpg.key | sudo apt-key add -
    && sudo sh -c 'echo "deb https://packagecloud.io/grafana/stable/debian/ stretch main" >> /etc/apt/sources.list.d/grafana.list'
    && curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
    && sudo sh -c 'echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" >> /etc/apt/sources.list.d/influxdb.list'
    && wget -q -O - wget http://www.webmin.com/jcameron-key.asc | sudo apt-key add -
    && sudo sh -c 'echo "debh-server http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list.d/webmin.list'

    && sudo apt-get update

##### INSTALL PACKAGES #####
RUN sudo apt-get install -y --no-install-recommends --allow-unauthenticated \
        vim-tiny git p7zip unzip google-chrome-stable firefox \
        hddtemp iotop lm-sensors manpages nethogs network-manager-openvpn-gnome \
        nmap openssl openssh-server smartmontools snmpd snmp snmp-mibs-downloader \
        telegraf webmin xvfb \ #non-display h/w X server
        apt-transport-https ca-certificates curl software-properties-common \
        docker-ce apache2 espeak influxdb grafana vim xrdp nautilus-dropbox

##### INSTALL PYTHON #####
RUN sudo apt-get install -y --no-install-recommends --allow-unauthenticated python python-pip python-dev build-essential
RUN sudo pip install --upgrade pip
RUN sudo pip install --upgrade setuptools \
    && sudo pip install --no-cache-dir virtualenv
RUN sudo /usr/bin/python2.7 -m pip install --upgrade pip
RUN sudo /usr/bin/python2.7 -m pip install --upgrade setuptools \
    && sudo /usr/bin/python2.7 -m pip install --no-cache-dir virtualenv
    
ARG CHROME_DRIVER_VERSION="latest"
RUN CD_VERSION=$(if [ ${CHROME_DRIVER_VERSION:-latest} = "latest" ]; then echo $(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE); else echo $CHROME_DRIVER_VERSION; fi) \
  && echo "Using chromedriver version: "$CD_VERSION \
  && wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CD_VERSION/chromedriver_linux64.zip \
  && sudo rm -rf /opt/selenium/chromedriver \
  && sudo unzip /tmp/chromedriver_linux64.zip -d /opt/selenium \
  && rm /tmp/chromedriver_linux64.zip \
  && sudo mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CD_VERSION \
  && sudo chmod 755 /opt/selenium/chromedriver-$CD_VERSION \
  && sudo ln -fs /opt/selenium/chromedriver-$CD_VERSION /usr/bin/chromedriver

### UBUNTU APACHE2 SETUP ###
RUN sudo apt-get install apache2 \
    && sudo a2enmod proxy #enable proxy forwarding dirs ../<dir> to <url>
    && sudo a2enmod proxy_http
    && sudo a2enmod proxy_balancer
    && sudo a2enmod lbmethod_byrequests

##### UPGRADE #####
RUN sudo apt-get upgrade -y --no-install-recommends --allow-unauthenticated

##### CLEANUP #####
RUN sudo apt autoremove -y \
    && sudo apt autoclean -y \
    && sudo apt purge $(dpkg -l linux-{image,headers}-"[0-9]*" | awk '/ii/{print $2}' | grep -ve "$(uname -r | sed -r 's/-[a-z]+//')") \
    && sudo rm -rf /var/lib/apt/lists/* \
    && sudo rm -rf /var/cache/apt/*

################################################################################
#
################################################################################
CMD tail -f /dev/null
