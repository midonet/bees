FROM tomcat:8
# Inherited from library/tomcat. https://registry.hub.docker.com/_/tomcat/
MAINTAINER "Tim <tim@midokura.com>"

RUN apt-get update && apt-get install -y wget fish

# Grab confd and set it up
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.9.0/confd-0.9.0-linux-amd64
RUN chmod +x ./confd-0.9.0-linux-amd64
RUN mv ./confd-0.9.0-linux-amd64 /usr/local/bin/confd

# This requires the scripts to copied into the build context
ADD confd/bin/confd-watch-cassandra /usr/local/bin/confd-watch-cassandra
RUN chmod +x /usr/local/bin/confd-watch-cassandra

# This requires the latest version of the confd directory structure to be copied into the build context
COPY confd/ /etc/confd/

# This removes unused config files, because they will be read
RUN shopt -s extglob
RUN rm -f /etc/confd/conf.d/!(midonet-api.toml) && rm -f /etc/confd/templates/!(midonet-api.cfg.tmpl)
