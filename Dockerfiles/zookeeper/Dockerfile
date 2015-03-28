FROM ubuntu:latest
MAINTAINER Tim <tim@midokura.com>

# Install zookeeper and requirements from repos
RUN apt-get update && apt-get install -qqy --no-install-recommends openjdk-7-jre-headless
RUN apt-get install -qqy zookeeper curl wget vim fish

# Grab confd and set it up
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.8.0/confd-0.8.0-linux-amd64
RUN chmod +x ./confd-0.8.0-linux-amd64
RUN mv ./confd-0.8.0-linux-amd64 /usr/local/bin/confd

# This requires the latest version of the script to be copied into the build context directory
ADD confd-watch-zookeeper /usr/local/bin/confd-watch-zookeeper
RUN chmod +x /usr/local/bin/confd-watch-zookeeper
ADD confd-watch-myid /usr/local/bin/confd-watch-myid
RUN chmod +x /usr/local/bin/confd-watch-myid

# Crappy script additions. THIS SHOULD BE REVERTED.
ADD crappy-script.sh /usr/local/bin/crappy-script
RUN chmod +x /usr/local/bin/crappy-script

# This requires the latest version of the confd directory structure to be copied into the build context
COPY confd/ /etc/confd/

# This removes unused config files, because they will be read
RUN rm -f /etc/confd/conf.d/cassandra.toml && rm -f /etc/confd/templates/cassandra.cfg.tmpl
RUN rm -f /etc/confd/conf.d/zookeeper-myid.toml && rm -f /etc/confd/templates/zookeeper-myid.cfg.tmpl

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV HOST_IP="localhost"

VOLUME ["/var/lib/zookeeper", "/tmp/zookeeper"]

WORKDIR /var/lib/zookeeper

EXPOSE 2181 2888 3888

ENTRYPOINT ["/usr/local/bin/confd-watch-zookeeper","/usr/local/bin/confd-watch-myid","/usr/share/zookeeper/bin/zkServer.sh"]

CMD ["start-foreground"]
