# 3 node zookeeper cluster setup


```yaml
version: '3.4'

services:
  zk1:
    image: zookeeper:latest
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
      ZOO_MY_ID: 1
      ZOO_SERVERS: zk1,zk2,zk3
    ports:
      - "2181:2181"
    volumes:
      - zookeeper/data:/var/lib/zookeeper/data"
      - zookeeper/logs:/var/lib/zookeeper/log"
    deploy:
      placement:
        constraints: [node.labels.name == node-1]

  zk2:
    image: zookeeper:latest
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
      ZOO_MY_ID: 2
      ZOO_SERVERS: zk1,zk2,zk3
    ports:
      - "2182:2181"
    volumes:
      - zookeeper/data:/var/lib/zookeeper/data"
      - zookeeper/logs:/var/lib/zookeeper/log"
    deploy:
      placement:
        constraints: [node.labels.name == node-2]

  zk3:
    image: zookeeper:latest
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
      ZOO_MY_ID: 3
      ZOO_SERVERS: zk1,zk2,zk3
    ports:
      - "2183:2181"
    volumes:
      - zookeeper/data:/var/lib/zookeeper/data"
      - zookeeper/logs:/var/lib/zookeeper/log"
    deploy:
      placement:
        constraints: [node.labels.name == node-3]

  
```
