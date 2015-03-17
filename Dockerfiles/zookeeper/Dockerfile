FROM ubuntu:latest
MAINTAINER Tim <tim@midokura.com>

# Install zookeeper and requirements from repos
RUN apt-get update && apt-get install -qqy --no-install-recommends openjdk-7-jre-headless
RUN apt-get install -qqy zookeeper

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

VOLUME ["/var/lib/zookeeper", "/tmp/zookeeper"]

WORKDIR /var/lib/zookeeper

EXPOSE 2181 2888 3888

ENTRYPOINT ["/usr/share/zookeeper/bin/zkServer.sh"]

CMD ["start-foreground"]
