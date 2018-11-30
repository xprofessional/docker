#!/bin/bash

set -e

echo "starting environment"
service ssh restart
dumb-init /etc/openvpn/start.sh
echo "environment started"
