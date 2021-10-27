#!/bin/bash

function fail () {
    echo $err
    exit 2
}
 
if [ -z "$PBX_URL" ] || [ -z "$PBX_KEY" ]
then
    echo "PBX_URL or PBX_KEY environment variable missing"
    exit 1
fi

curl -Ss -o /etc/3cxsbc.conf $PBX_URL/sbc/$PBX_KEY || {
    echo "Could not download provisioning configuration"
    exit 2
}
