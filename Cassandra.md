# Cassandra
#### Quick Start
To run Cassandra using this container, head over to the [Running](Running.md) guide and follow those instructions

### Design
Cassandra is a very useful and powerful database system, but it has a few drawbacks. Namely it is not designed to be deployed and run in a distributed manner without extra configuration and management. In order to make Cassandra a little more flexible we elected to create a new container image.

Primarily we were looking to enable Cassandra's `seeds` configuration to be more dynamic (rather than having a hardcoded list of nodes) so that Cassandra would be aware of the current set of members and be able to reconfigure should one of those members change. To do this we leveraged `confd`.

Our container (for now) is built off of [spotify/docker-cassandra](https://github.com/spotify/docker-cassandra). We reverted most of the changes added here, except for the setup. We then used this as a base image upon which to build our distributed Cassandra.

### Base Changes
When running Cassandra as the only process in a container, there is no need for process control. However, since we want to be able to reconfigure Cassandra when any changes take place, we needed a way to recycle the process without losing state. The [Phusion Baseimage](https://github.com/phusion/baseimage-docker) container uses the `runit` process manager accomplish a similar task (and it's something we use for the [midonet-agent](Dockerfiles/midonet-agent) container) so we chose to use `runit` here as well. Since we're not basing this image off of `phusion/baseimage` (and we don't need all the extra features) we bring in a snapshot of `runit` from that image into the build context.

The only other component we add is [confd](https://github.com/kelseyhightower/confd). This will watch our `etcd` key store and rebuild Cassandra's configuration upon any changes.

The final bit is the crucial one. We'll need to build a template of the configuration file for Cassandra that can be read by `confd` and will input the proper key values for any configuration information.

The following snippet will fill in the values for `seeds` from the list of active nodes in our key store.

```yaml
seed_provider:
    # Addresses of hosts that are deemed contact points.
    # Cassandra nodes use this list of hosts to find each other and learn
    # the topology of the ring.  You must change this if you are running
    # multiple nodes!
    - class_name: org.apache.cassandra.locator.SimpleSeedProvider
      parameters:
          # seeds is actually a comma-delimited list of addresses.
          # Ex: "<ip1>,<ip2>,<ip3>"
          - seeds: "{{range $index,$servers := gets "/services/cassandra/*"}}{{if $index}},{{( json .Value).address}}{{else}}{{( json .Value).address}}{{end}}{{end}}"
```
### Process Management
One of the most difficult things about running Cassandra in a controlled environment is that `java` will spawn multiple child processes outside of the control group that Cassandra is running in. This is fine if you're only running the Cassandra process in the container, but `runit` requires that any process it controls be the parent process of any child processes, otherwise it is unable to tell whether the original process is up or down and to stop or start that process. Since we'll need to restart Cassandra after any configuration changes, this would be a problem.

After trying a number of different approaches we settled on putting `java` directly under the control of `runit` so that it could bring the entire runtime down and back up when recycling the service. Although inelegant, it seems to work. `runit` will also attempt to restart the process should it exit for any reason.

### Modification
This image is intended to be flexible and useful for a number of different scenarios. Currently the only limitation is that it must be run along side at least one instance of `etcd` (as mentioned in [Running](Running.md)), but a way to run it in standalone mode will likely be added in the future.

Feel free to modify and use it as you see fit. Any contributions or bug fixes would be appreciated!

#### Current Bugs
- [ ] `cluster size` is not currently set, but this doesn't appear to matter
- [ ] If `runit` repeatedly restarts Cassandra, it will also restart the `confd` process, resulting in a new `confd` process for each restart
- [ ] Requires `etcd`
