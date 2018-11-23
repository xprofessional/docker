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
    && sudo apt-get update

##### INSTALL PACKAGES #####
RUN sudo apt-get install -y --no-install-recommends --allow-unauthenticated \
        vim-tiny git p7zip unzip google-chrome-stable firefox

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
