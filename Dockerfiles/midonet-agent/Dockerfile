FROM ubuntu
MAINTAINER "Tim <tim@midokura.com>"

RUN apt-get update && apt-get install -y wget fish curl vim

# Set the current version of the docs to get the apt source file we want
ADD https://raw.githubusercontent.com/midonet/midonet-docs/master/docs/quick-start-guide/src/ubuntu-1404/juno/basic_environment/listitem_repo_config_midonet_en.adoc /tmp/midonet-apt-sources.adoc
RUN sed -n '/----/,/----/p' /tmp/midonet-apt-sources.adoc | awk -F '----' '{print $1}' > /etc/apt/sources.list.d/midonet.list
RUN curl -L http://repo.midonet.org/packages.midokura.key | apt-key add -

# Grab confd and set it up
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.9.0/confd-0.9.0-linux-amd64
RUN chmod +x ./confd-0.9.0-linux-amd64
RUN mv ./confd-0.9.0-linux-amd64 /usr/local/bin/confd

ADD https://raw.githubusercontent.com/midonet/bees/build-refactor/confd/bin/confd-watch-midonet-agent /usr/local/bin/confd-watch-midonet-agent
RUN chmod +x /usr/local/bin/confd-watch-midonet-agent

# Add restart command for midonet-agent
ADD https://raw.githubusercontent.com/midonet/bees/build-refactor/confd/bin/midonet-restart-agent.sh /usr/local/bin/midonet-restart-agent.sh
RUN chmod +x /usr/local/bin/midonet-restart-agent.sh

ADD https://raw.githubusercontent.com/midonet/bees/build-refactor/confd/conf.d/midonet-agent.toml /etc/confd/conf.d/midonet-agent.toml
ADD https://raw.githubusercontent.com/midonet/bees/build-refactor/confd/templates/midonet-agent.conf.tmpl /etc/confd/templates/midonet-agent.conf.tmpl

RUN apt-get update && apt-get install -y midolman python

ENTRYPOINT ["confd-watch-midonet-agent"]
