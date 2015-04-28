FROM tomcat:8
# Inherited from library/tomcat. https://registry.hub.docker.com/_/tomcat/
MAINTAINER "Tim <tim@midokura.com>"

# Set the current version of the docs to get the apt source file we want
ADD https://raw.githubusercontent.com/midonet/midonet-docs/master/docs/quick-start-guide/src/ubuntu-1404/juno/basic_environment/listitem_repo_config_midonet_en.adoc /tmp/midonet-apt-sources.adoc
RUN sed -n '/----/,/----/p' /tmp/midonet-apt-sources.adoc | awk -F '----' '{print $1}' > /etc/apt/sources.list.d/midonet.list
RUN curl -L http://repo.midonet.org/packages.midokura.key | apt-key add -

RUN apt-get update && apt-get install -y wget midonet-api vim

# Grab confd and set it up
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.9.0/confd-0.9.0-linux-amd64
RUN chmod +x ./confd-0.9.0-linux-amd64
RUN mv ./confd-0.9.0-linux-amd64 /usr/local/bin/confd

ADD https://raw.githubusercontent.com/midonet/bees/master/confd/bin/confd-watch-midonet-api /usr/local/bin/confd-watch-midonet-api
RUN chmod +x /usr/local/bin/confd-watch-midonet-api

ADD https://raw.githubusercontent.com/midonet/bees/master/confd/conf.d/midonet-api.toml /etc/confd/conf.d/midonet-api.toml
ADD https://raw.githubusercontent.com/midonet/bees/master/confd/templates/midonet-api.xml.tmpl /etc/confd/templates/midonet-api.xml.tmpl

ADD https://raw.githubusercontent.com/midonet/midonet/master/midonet-api/conf/midonet-api.xml /usr/local/tomcat/conf/Catalina/localhost/midonet-api.xml

EXPOSE 8080

ENTRYPOINT ["confd-watch-midonet-api"]
