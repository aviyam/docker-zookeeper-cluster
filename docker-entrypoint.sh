#!/bin/bash

set -e


# Generate config if it doesn't exist
if [[ ! -f "$CONF_DIR/zoo.cfg" ]]; then
    CONFIG="$CONF_DIR/zoo.cfg"

    echo "clientPort=$PORT" >> "$CONFIG"
    echo "dataDir=$DATA_DIR" >> "$CONFIG"
    echo "dataLogDir=$DATA_LOG_DIR" >> "$CONFIG"

    echo "tickTime=$TICK_TIME" >> "$CONFIG"
    echo "initLimit=$INIT_LIMIT" >> "$CONFIG"
    echo "syncLimit=$SYNC_LIMIT" >> "$CONFIG"

    echo "maxClientCnxns=$MAX_CLIENT_CNXNS" >> "$CONFIG"

    echo "autopurge.purgeInterval=$PURGE_INTERVAL" >> "$CONFIG"
    echo "autopurge.snapRetainCount=$SNAP_RETAIN_INTERVAL" >> "$CONFIG"
    
    IFS=', ' read -r -a ZOOKEEPER_SERVERS_ARRAY <<< "$ZOO_SERVERS"
    export ZOOKEEPER_SERVERS_ARRAY=$ZOOKEEPER_SERVERS_ARRAY
    
# now append information on every ZooKeeper node in the ensemble to the ZooKeeper config:
    for index in "${!ZOOKEEPER_SERVERS_ARRAY[@]}"
      do
        ZKID=$(($index+1))
        ZKIP=${ZOOKEEPER_SERVERS_ARRAY[index]}
        if [ $ZKID == $ZOO_MY_ID ]
          then
          # if IP's are used instead of hostnames, every ZooKeeper host has to specify itself as follows
          ZKIP=0.0.0.0
        fi
     echo "server.$ZKID=$ZKIP:2888:3888" >> "$CONFIG"
done
fi

echo "${MY_ID:-1}" > "$DATA_DIR/myid"

exec "$@"

