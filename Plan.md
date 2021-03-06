#Midonet for Docker, Swarm, CoreOS, Kubernetes and Mesosphere

**TL;DR**: Networking for containers and their management engines can be achieved in a relatively simple manner, but will take some work.
##Background
While Linux (and *nix) based containers have been around for sometime (at least 2006), the recent rise of Docker has rapidly expanded their use and types of installations in which they are found. Initially this usage was targeted at small or single container uses for development, but has logically moved into the server and infrastructure space. To fill the orchestration role for these uses, serveral applications have been developed recently. Once scale increases, there is also a need for network creation and management. We'll be investigating how, and where, MidoNet can fill this role for Swarm, CoreOS, Kubernetes, and Mesosphere.

##What To Look At
For this integration overview we'll be looking specifically at [Docker Swarm](https://docs.docker.com/swarm/), [CoreOS](https://coreos.com/) (with [kubernetes](http://kubernetes.io/) and without), and [Mesosphere](http://mesosphere.com/). These were chosen as the initial points of interest as they would be similar in their integration setup. More things may be added later on.

##Basic Design
