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
RUN sudo apt-get update \
    &&  sudo apt-get install -y --no-install-recommends --allow-unauthenticated curl wget

CMD tail -f /dev/null
