FROM phusion/baseimage
MAINTAINER "Tim <tim@midokura.com>"

RUN apt-get update && apt-get install -y wget fish curl vim

# Set the current version of the docs to get the apt source file we want
ADD https://raw.githubusercontent.com/midonet/midonet-docs/master/docs/quick-start-guide/src/ubuntu-1404/juno/basic_environment/listitem_repo_config_midonet_en.adoc /tmp/midonet-apt-sources.adoc
RUN sed -n '/----/,/----/p' /tmp/midonet-apt-sources.adoc | awk -F '----' '{print $1}' > /etc/apt/sources.list.d/midonet.list
RUN curl -L http://repo.midonet.org/packages.midokura.key | apt-key add -

# Grab confd and set it up
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64
RUN chmod +x ./confd-0.10.0-linux-amd64
RUN mv ./confd-0.10.0-linux-amd64 /usr/local/bin/confd

ADD https://raw.githubusercontent.com/midonet/bees/master/confd/bin/confd-watch-midonet-agent /usr/local/bin/confd-watch-midonet-agent
RUN chmod +x /usr/local/bin/confd-watch-midonet-agent

# Add restart command for midonet-agent
ADD https://raw.githubusercontent.com/midonet/bees/master/confd/bin/midonet-agent-restart.sh /usr/local/bin/midonet-agent-restart.sh
RUN chmod +x /usr/local/bin/midonet-agent-restart.sh

ADD https://raw.githubusercontent.com/midonet/bees/master/confd/conf.d/midonet-agent.toml /etc/confd/conf.d/midonet-agent.toml
ADD https://raw.githubusercontent.com/midonet/bees/master/confd/templates/midonet-agent.conf.tmpl /etc/confd/templates/midonet-agent.conf.tmpl

RUN apt-get update && apt-get install -y midolman python

# Changes for phusion
RUN mkdir --parents /etc/service/confd-watch-midonet-agent
RUN mkdir --parents /etc/service/midolman
RUN ln -s /usr/local/bin/confd-watch-midonet-agent /etc/service/confd-watch-midonet-agent/run
RUN ln -s /usr/share/midolman/midolman-start /etc/service/midolman/run


ENTRYPOINT ["/sbin/my_init"]
