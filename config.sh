#!/bin/bash

PASSWORD=$1
PORT=$2
OBS_PARAM=$3

JQR=""
if [ $1 ]; then
  JQR=".password=\"$PASSWORD\""
fi
if [ $2 ]; then
  JQR="$JQR | .server_port=$PORT"
fi
if [ $3 ]; then
  JQR="$JQR | .obfs_param=\"$OBS_PARAM\""
fi

cat user-config.json | jq "$JQR" \
  > file.tmp.json && cp file.tmp.json user-config.json && rm file.tmp.json
  
echo "Edit user-config.json done!!"