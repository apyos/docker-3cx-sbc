#!/bin/bash

if [ -z "$WATCHTOWER_API" ] || [ -z "$WATCHTOWER_TOKEN" ]
then
    echo "This container image only supports updates via Watchtower."
    echo "Enable them by passing the WATCHTOWER_API and WATCHTOWER_TOKEN environment variables."
    exit 1
fi

curl -H "Authorization: Bearer $WATCHTOWER_TOKEN" $WATCHTOWER_API/v1/update
