FROM openjdk:8-jre-alpine

MAINTAINER Aviyam Fischer <aviyam@gmail.com>

ARG DISTRO_NAME=apache-zookeeper-3.5.5

RUN apk add --no-cache bash su-exec wget

ENV USER=zookeeper \
    CONF_DIR=/conf \
    DATA_DIR=/data \
    DATA_LOG_DIR=/datalog \
    PORT=2181 \
    TICK_TIME=2000 \
    INIT_LIMIT=5 \
    SYNC_LIMIT=2 \
    MAX_CLIENT_CNXNS=60 \
    PURGE_INTERVAL=1 \
    SNAP_RETAIN_INTERVAL=3

RUN adduser -D "$USER"; \
    mkdir -p "$DATA_LOG_DIR" "$DATA_DIR" "$CONF_DIR"; \
    chown "$USER:$USER" "$DATA_LOG_DIR" "$DATA_DIR" "$CONF_DIR"

ARG del_list="build.xml \
contrib \
dist-maven \
docs \
ivysettings.xml \
ivy.xml \
recipes \
src \
README_packaging.txt"

# Get zookeeper and clean from unneeded stuff
RUN  S_DISTRO_NAME=${DISTRO_NAME#"apache-"};  [ ! -e $DISTRO_NAME.tar.gz ] && wget -q "https://www.apache.org/dist/zookeeper/$S_DISTRO_NAME/$DISTRO_NAME-bin.tar.gz" ; \
tar xvzf "$DISTRO_NAME-bin.tar.gz" ; \ 
cd "$DISTRO_NAME-bin" ; \
for file in $del_list; do rm -rf $file;done ; \
mv "conf/"* "$CONF_DIR" ; \
cd .. ; rm -rf "$DISTRO_NAME-bin.tar.gz"

WORKDIR $DISTRO_NAME-bin

VOLUME ["$DATA_DIR", "$DATA_LOG_DIR"]

EXPOSE $PORT 2888 3888

ENV PATH=$PATH:/$DISTRO_NAME-bin/bin \
    ZOOCFGDIR=$CONF_DIR

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["bin/zkServer.sh", "start-foreground"]
