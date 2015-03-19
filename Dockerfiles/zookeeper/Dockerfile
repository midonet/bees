FROM ubuntu:latest
MAINTAINER Tim <tim@midokura.com>

# Install zookeeper and requirements from repos
RUN apt-get update && apt-get install -qqy --no-install-recommends openjdk-7-jre-headless
RUN apt-get install -qqy zookeeper curl wget vim

# Grab confd and set it up
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.8.0/confd-0.8.0-linux-amd64
RUN chmod +x ./confd-0.8.0-linux-amd64
RUN mv ./confd-0.8.0-linux-amd64 /usr/local/bin/confd

# This requires the latest version of the script to be copied into the build context directory
ADD confd-watch /usr/local/bin/confd-watch
RUN chmod +x /usr/local/bin/confd-watch

# This requires the latest version of the confd directory structure to be copied into the build context
COPY confd/ /etc/confd/

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

VOLUME ["/var/lib/zookeeper", "/tmp/zookeeper"]

WORKDIR /var/lib/zookeeper

EXPOSE 2181 2888 3888

ENTRYPOINT ["/usr/local/bin/confd-watch","/usr/share/zookeeper/bin/zkServer.sh"]

CMD ["start-foreground"]
