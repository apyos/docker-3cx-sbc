#!/bin/bash

function fail () {
    case $? in
    4|5)
        err="Unable to reach the 3CX Server at $PBX_URL\nPlease double check \"3CX Provisioning URL\" value and confirm that the SBC Trunk is created properly from within your 3CX Management Console.\n\nAlso 3CX must have a valid secure SSL Certificate so if you have a custom certificate which has expired or not renewed, the installation will fail."
        ;;
    8)
        err="The PBX does not accept the SBC AUTHENTICATION KEY ID\n$PBX_KEY"
        ;;
    *)
        err="Unknown error"
    esac

    echo $err
    exit 2
}
 
if [ -z "$PBX_URL" ] || [ -z "$PBX_KEY" ]
then
    echo "PBX_URL or PBX_KEY environment variable missing"
    exit 1
fi

wget -T 10 -t 1 -qO /etc/3cxsbc.conf $PBX_URL/sbc/$PBX_KEY || fail
