#!/bin/bash
SERVER_LIST=$(grep "server" /etc/zookeeper/conf/zoo.cfg | grep -v "#")
while read -r input; do
  TEMP=$(echo $input | awk -F= '{print $2}' | awk -F: '{print $1}')
  if [ "$TEMP" == "$HOST_IP" ]
    then
    PRINT=$(echo $input | awk -F. '{print $2}' | awk -F= '{print $1}')
    echo "[crappy-start] changing myid to $PRINT"
  fi
done <<< "$SERVER_LIST"
rm -f /etc/zookeeper/conf/myid
touch /etc/zookeeper/conf/myid
echo $PRINT > /etc/zookeeper/conf/myid
