#!/bin/bash
##############################################################################
## SCRIPT HEADER
cd $(dirname $0)
echo $(date '+%Y-%m-%d %H:%M:%S') $PWD $(basename $0)
##############################################################################

### UBUNTU - CHECK VPN STATUS ###

## Display IP Info incl Geoloc
curl ipinfo.io/$(curl ipinfo.io/ip 2>/dev/null) 2>/dev/null
firefox ipinfo.io/$(curl ipinfo.io/ip 2>/dev/null) https://torrentz2.eu http://localhost:9091 2>/dev/null &
