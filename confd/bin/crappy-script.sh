#!/bin/bash
SERVER_LIST=$(grep "server" /etc/zookeeper/conf/zoo.cfg | grep -v "#")
for i in $(echo $SERVER_LIST); do
  TEMP=$(echo $SERVER_LIST | awk -F= '{print $2}' | awk -F: '{print $1}')
  if [ "$TEMP" == "$HOST_IP" ]
    then
    PRINT=$(echo $SERVER_LIST | awk -F. '{print $2}' | awk -F= '{print $1}')
    echo "[crappy-start] changing myid to $PRINT"
  fi
done
rm -f /etc/zookeeper/conf/myid
touch /etc/zookeeper/conf/myid
echo $PRINT > /etc/zookeeper/conf/myid
