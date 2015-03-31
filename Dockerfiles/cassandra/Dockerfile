FROM timfallmk/cassandra:cluster
MAINTAINER "Tim <tim@midokura.com>"
# This is forked from spotify/cassandra:cluster to readd virtual nodes and gossip

RUN apt-get update && apt-get install -y wget fish

# Grab confd and set it up
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.8.0/confd-0.8.0-linux-amd64
RUN chmod +x ./confd-0.8.0-linux-amd64
RUN mv ./confd-0.8.0-linux-amd64 /usr/local/bin/confd

# This requires the scripts to copied into the build context
ADD confd/bin/confd-watch-cassandra /usr/local/bin/confd-watch-cassandra
RUN chmod +x /usr/local/bin/confd-watch-cassandra

# This requires the latest version of the confd directory structure to be copied into the build context
COPY confd/ /etc/confd/

# This removes unused config files, because they will be read
RUN rm -f /etc/confd/conf.d/zookeeper.toml && rm -f /etc/confd/templates/zookeeper.cfg.tmpl
# This is no longer needed for now
#RUN rm -f /etc/confd/conf.d/zookeeper-myid.toml && rm -f /etc/confd/templates/zookeeper-myid.cfg.tmpl

ENV CASSANDRA_CLUSTERNAME="midonet"
# Add default HOST_IP to localhost
#ENV HOST_IP="localhost"

VOLUME ["/var/lib/cassandra"]

WORKDIR /var/lib/cassandra

ENTRYPOINT ["confd-watch-cassandra"]
