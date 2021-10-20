#!/bin/bash

alias sudo="sh -c"

/usr/sbin/3cxsbc-reprovision
/usr/sbin/3cxsbc -m /etc/3cxsbc.conf
