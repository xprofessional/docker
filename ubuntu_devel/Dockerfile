##############################################################################
## Dockerfile: UBUNTU Base
##  Python, Pip, Selenium, Google-Chrome, Chromedriver
## https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/~/dockerfile/
##############################################################################

################################################################################
# base system
################################################################################
#FROM ubuntu:18.04 as system
FROM ubuntu:16.04 as system


##### BUILT-IN PKGS #####
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated curl wget apt-utils software-properties-common

##### ADD CUSTOM KEYS & REPOS #####
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && rm -f /etc/apt/sources.list.d/google.list \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt update

##### INSTALL PACKAGES #####
RUN apt install -y --no-install-recommends --allow-unauthenticated \
        sudo vim-tiny git p7zip unzip google-chrome-stable firefox

##### INSTALL PYTHON #####
RUN apt install -y --no-install-recommends --allow-unauthenticated python python-pip python-dev build-essential
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools \
    && pip install --no-cache-dir virtualenv

ARG CHROME_DRIVER_VERSION="latest"
RUN CD_VERSION=$(if [ ${CHROME_DRIVER_VERSION:-latest} = "latest" ]; then echo $(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE); else echo $CHROME_DRIVER_VERSION; fi) \
  && echo "Using chromedriver version: "$CD_VERSION \
  && wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CD_VERSION/chromedriver_linux64.zip \
  && rm -rf /opt/selenium/chromedriver \
  && unzip /tmp/chromedriver_linux64.zip -d /opt/selenium \
  && rm /tmp/chromedriver_linux64.zip \
  && mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CD_VERSION \
  && chmod 755 /opt/selenium/chromedriver-$CD_VERSION \
  && ln -fs /opt/selenium/chromedriver-$CD_VERSION /usr/bin/chromedriver

##### UPGRADE #####
RUN apt upgrade -y --no-install-recommends --allow-unauthenticated

##### CLEANUP #####
RUN apt autoremove -y \
    && apt autoclean -y \
    && apt purge $(dpkg -l linux-{image,headers}-"[0-9]*" | awk '/ii/{print $2}' | grep -ve "$(uname -r | sed -r 's/-[a-z]+//')") \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/*

##### CONFIGURE THE FILESYSTEM
RUN mkdir /projects && chmod 777 /projects

################################################################################
#
################################################################################
FROM system

#EXPOSE 80
WORKDIR /projects
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash

ENTRYPOINT [ "sh", "-c", "echo $HOME" ]