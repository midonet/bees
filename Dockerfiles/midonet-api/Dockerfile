FROM tomcat:8
# Inherited from library/tomcat. https://registry.hub.docker.com/_/tomcat/
MAINTAINER "Tim <tim@midokura.com>"

# Set the current version of the docs to get the apt source file we want
RUN apt-get update && apt-get install -y wget
RUN wget --https-only https://raw.githubusercontent.com/midonet/midonet-docs/master/docs/quick-start-guide/src/ubuntu-1404/juno/basic_environment/listitem_repo_config_midonet_en.adoc -O /tmp/midonet-apt-sources.adoc
RUN sed -n '/----/,/----/p' /tmp/midonet-apt-sources.adoc | awk -F '----' '{print $1}' > /etc/apt/sources.list.d/midonet.list
RUN curl -L http://repo.midonet.org/packages.midokura.key | apt-key add -

RUN apt-get update && apt-get install -y wget fish midonet-api

# Grab confd and set it up
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.9.0/confd-0.9.0-linux-amd64
RUN chmod +x ./confd-0.9.0-linux-amd64
RUN mv ./confd-0.9.0-linux-amd64 /usr/local/bin/confd

# This requires the scripts to copied into the build context
ADD confd/bin/confd-watch-tomcat /usr/local/bin/confd-watch-tomcat
RUN chmod +x /usr/local/bin/confd-watch-tomcat

# This requires the latest version of the confd directory structure to be copied into the build context
COPY confd/ /etc/confd/

# This removes unused config files, because they will be read
RUN shopt -s extglob
RUN rm -f /etc/confd/conf.d/!(midonet-api.toml) && rm -f /etc/confd/templates/!(midonet-api.cfg.tmpl)
RUN shopt -u extglob

COPY https://raw.githubusercontent.com/midonet/midonet/master/midonet-api/conf/midonet-api.xml /usr/local/tomcat/conf/Catalina/localhost/midonet-api.xml

EXPOSE 8080

ENTRYPOINT ["confd-watch-tomcat"]
