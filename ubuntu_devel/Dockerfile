##############################################################################
## Dockerfile: UBUNTU Base
##  Python, Pip, Selenium, Google-Chrome, Chromedriver
## https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/~/dockerfile/
## https://github.com/eclipse/che-dockerfiles/tree/master/recipes/stack-base/ubuntu
##############################################################################

################################################################################
# base system
################################################################################
#FROM ubuntu:18.04 as system
FROM ubuntu:16.04 as system

##### BUILT-IN PKGS #####
#RUN apt update \
#    && apt install -y --no-install-recommends --allow-unauthenticated curl wget apt-utils software-properties-common

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH
RUN apt-get update && \
    apt-get -y install \
    locales \
    rsync \
    openssh-server \
    sudo \
    procps \
    wget \
    unzip \
    mc \
    ca-certificates \
    curl \
    software-properties-common \
    python-software-properties \
    bash-completion && \
    mkdir /var/run/sshd && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    # Adding user to the 'root' is a workaround for https://issues.jboss.org/browse/CDK-305
    useradd -u 1000 -G users,sudo,root -d /home/user --shell /bin/bash -m user && \
    usermod -p "*" user && \
    add-apt-repository ppa:git-core/ppa && \
    add-apt-repository ppa:openjdk-r/ppa && \
    apt-get update && \
    sudo apt-get install git subversion -y && \
    apt-get clean && \
    apt-get -y autoremove && \
    sudo apt-get install openjdk-8-jdk-headless=8u171-b11-0ubuntu0.16.04.1 openjdk-8-source=8u171-b11-0ubuntu0.16.04.1 -y && \
    sudo update-ca-certificates -f && \
    sudo sudo /var/lib/dpkg/info/ca-certificates-java.postinst configure && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

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

##### CONFIGURE OpenShift CHE
# ls -la  # to check if there's a bootstrapper binary
ARG CHE_URL="https://che.openshift.io"
RUN mkdir /tmp/bootstrapper \
    && cd /tmp/bootstrapper \
    && curl ${CHE_URL}/agent-binaries/linux_amd64/bootstrapper/bootstrapper

################################################################################
#
################################################################################
FROM system

ENV LANG en_GB.UTF-8
ENV LANG en_US.UTF-8
USER user
RUN sudo locale-gen en_US.UTF-8 && \
    svn --version && \
    cd /home/user && ls -la && \
    sed -i 's/# store-passwords = no/store-passwords = yes/g' /home/user/.subversion/servers && \
    sed -i 's/# store-plaintext-passwords = no/store-plaintext-passwords = yes/g' /home/user/.subversion/servers
COPY open-jdk-source-file-location /open-jdk-source-file-location
WORKDIR /projects
#EXPOSE 80
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash

# The following instructions set the right
# permissions and scripts to allow the container
# to be run by an arbitrary user (i.e. a user
# that doesn't already exist in /etc/passwd)
ENV HOME /home/user

RUN for f in "/home/user" "/etc/passwd" "/etc/group" "/projects"; do\
           sudo chgrp -R 0 ${f} && \
           sudo chmod -R g+rwX ${f}; \
        done && \
        # Generate passwd.template \
        cat /etc/passwd | \
        sed s#user:x.*#user:x:\${USER_ID}:\${GROUP_ID}::\${HOME}:/bin/bash#g \
        > /home/user/passwd.template && \
        # Generate group.template \
        cat /etc/group | \
        sed s#root:x:0:#root:x:0:0,\${USER_ID}:#g \
        > /home/user/group.template && \
        sudo sed -ri 's/StrictModes yes/StrictModes no/g' /etc/ssh/sshd_config

COPY ["entrypoint.sh","/home/user/entrypoint.sh"]

ENTRYPOINT ["/home/user/entrypoint.sh"]

CMD tail -f /dev/null
