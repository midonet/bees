#!/bin/bash
while true; do
  SERVER_LIST=$(grep "server" /etc/zookeeper/conf/zoo.cfg | grep -v "#")
  for i in $(echo $SERVER_LIST); do
    TEMP=$(echo $SERVER_LIST | awk -F= '{print $2}' | awk -F: '{print $1}')
    if [ "$TEMP" == "$HOST_IP" ]
      then
      PRINT=$(echo $SERVER_LIST | awk -F. '{print $2}' | awk -F= '{print $1}')
      echo $PRINT
    fi
  done
done
