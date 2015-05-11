# Running
#### Getting Started
If you're running on a system using `systemd` (specifically CoreOS) you already have everything you need. If you're not running on a system that already has these things, you'll need a few prerequisites.

- [ ] Docker (all componenets are currently docker containers)
- [ ] `etcd` (we can use a containerized version)
- [ ] Coffee (or other organic caffeine suspension)

### Running `etcd`
Each of the service components relies on `confd` to properly monitor and configure itself. `confd` gets it's information from a state-store, in this case `etcd`. We'll need at least one instance of `etcd` running to keep track of info. Luckily we can do this with a container.

First things first, lets set a discovery token so we can cluster any `etcd` instances we create. We can create a new token by going to https://discovery.etcd.io/new? or with curl.

```shell
curl -w "\n" 'https://discovery.etcd.io/new?'
```

>**Note**: You can optionally add `size=n` at the end of the url to specify the size of the cluster. The default size is 3.

Next, we can pull down and run the container with our token. Substitute your own values for the token and IP. You can add more instances if you want.

```shell
docker run \
  -d \
  -p 2379:2379 \
  -p 2380:2380 \
  -p 4001:4001 \
  -p 7001:7001 \
  -v /data/backup/dir:/data \
  --name <some-etcd> \
  elcolio/etcd:latest \
  -name <some-etcd> \
  -discovery=https://discovery.etcd.io/blahblahblahblah \
  -advertise-client-urls http://192.168.1.99:4001 \
  -initial-advertise-peer-urls http://192.168.1.99:7001
  ```

You're `etcd` instance is now running, and can be accessed with `curl`.

### Services
Each service comes as a container, which makes it very simple to run. If we are using a non-`systemd` system the only additional step we must take is to set some initial configuration information in `etcd`.

What information we need to set depends on which service we're running. To see the current required information we can look at what is being set in the [`systemd` unit files](https://github.com/midonet/bees/tree/master/systemd/templates) for the discovery service. For example, setting the values for `zookeeper` would look like:
```shell
curl -L -X PUT http://<ip of etcd>:4001/v2/keys/<ip of zookeeper instance> '{"id":"<id of zookeeper>", "address":"<ip of zookeeper instance>", "quorumport":"2888", "electionport":"3888"}'
```
>You can update this information at any time using the `-X DELETE` and `-X GET` options

Once you have this information set (and you should check that it's been properly set by querying the `etcd` cluster after setting) we can start the service. Again, we can get the proper run command from the [`systemd` unit files](https://github.com/midonet/bees/tree/master/systemd/templates). For running zookeeper we would use:

```shell
docker run --name=zookeeper-node-<#> --env HOST_IP=<ip address of zookeeper instance> -p 2181:2181 -p 2888:2888 -p 3888:3888 timfallmk/bees:zookeeper
```
>If you want to make the data directory persistent between restarts you can use the `-v /var/lib/zookeeper:/var/lib/zookeeper` flag

You should now have a running service. You can repeat the steps above to run other services.
