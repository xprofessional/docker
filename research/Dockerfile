##############################################################################
## Dockerfile: UBUNTU:18.04 baseline
##############################################################################

################################################################################
# base system
################################################################################
FROM ubuntu:18.04 
#FROM ubuntu:16.04 as system
#FROM eclipse/che
#FROM eclipse/ubuntu_python

##### BUILT-IN PKGS #####
RUN apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated curl wget

# RUN curl -fsSo /tmp/bootstrapper/bootstrapper https://che.openshift.io/agent-binaries/linux_amd64/bootstrapper/bootstrapper

CMD tail -f /dev/null
