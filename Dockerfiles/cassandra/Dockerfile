FROM timfallmk/cassandra:cluster
MAINTAINER "Tim <tim@midokura.com>"
# This is forked from spotify/cassandra:cluster to readd virtual nodes and gossip

RUN apt-get update && apt-get install -y wget fish vim

# Grab confd and set it up
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64
RUN chmod +x ./confd-0.10.0-linux-amd64
RUN mv ./confd-0.10.0-linux-amd64 /usr/local/bin/confd

ADD https://raw.githubusercontent.com/midonet/bees/master/confd/bin/confd-watch-cassandra /usr/local/bin/confd-watch-cassandra
RUN chmod +x /usr/local/bin/confd-watch-cassandra

ADD https://raw.githubusercontent.com/midonet/bees/master/confd/bin/cassandra-restart /usr/local/bin/cassandra-restart
RUN chmod +x /usr/local/bin/cassandra-restart

ADD https://raw.githubusercontent.com/midonet/bees/master/confd/conf.d/cassandra.toml /etc/confd/conf.d/cassandra.toml
ADD https://raw.githubusercontent.com/midonet/bees/master/confd/templates/cassandra.yaml.tmpl /etc/confd/templates/cassandra.yaml.tmpl

# Make our own phusion/baseimage to add `runit`
RUN apt-mark hold cassandra dsc20
ADD phusion-baseimage-build.tar.bz2 /
RUN /build/system_services.sh && \
        /build/utilities.sh && \
        /build/cleanup.sh
ADD https://raw.githubusercontent.com/midonet/bees/master/confd/bin/cassandra-runit-script /etc/service/cassandra/run
RUN chmod +x /etc/service/cassandra/run
RUN mkdir /etc/service/confd-watch-cassandra
RUN ln -s /usr/local/bin/confd-watch-cassandra /etc/service/confd-watch-cassandra/run

ENV CASSANDRA_CLUSTERNAME="midonet"
# Add default HOST_IP to localhost
#ENV HOST_IP="localhost"

VOLUME ["/var/lib/cassandra"]

WORKDIR /var/lib/cassandra

EXPOSE 7000 7001 7199 8012 9042 9160 61621

ENTRYPOINT ["/sbin/my_init"]
