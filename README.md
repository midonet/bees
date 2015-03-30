# bees
MidoNet for Docker Swarm, CoreOS Kubernetes, Konsole, and other cluster management tools


### Quick and Dirty Instructions
---
#### Zookeeper
There are two ways you run zookeeper in a clustered mode: with and without `systemd` and `fleet`. Currently `etcd` running *somewhere* is required at the moment. Let's go over each case here:

##### Without `systemd`
The cluster is designed to be run with a series of self-standing Docker containers. Each one contains a copy of `zookeeper`, as well as `confd` and some watcher scripts to look at `etcd` keys for changes.

**Note**: At this time, confd does not manage the `myid` file necessary for `zookeeper` because, well, because "`zookeeper`". Hopefully this will change when `go` `text/template` format unfucks itself.

On a Docker host, we can run the following:

```shell
docker run -d --env HOST_IP=${COREOS_PUBLIC_IPV4} -p 2181:2181 -p 2888:2888 -p 3888:3888 timfallmk/zookeeper:hacky
```

This is designed to run a single zookeeper container with some variables overridden.

`HOST_IP` is used to pass in the host IP address to the container so it can address itself properly. Since we're *not* running this on CoreOS, we need to fake an address to pass in instead of what would be automatically input. For right now, this also needs to be where `etcd` is running, so set it to that.

`-p <port>` Maps ports exposed in the container directly to corresponding ports on the host. If you want dynamic mapping (to run more than one on the same host, for example), you can use `-P` in place of all of the `-p` arguments. The zookeeper instances are **also** designed to work this way with minimal changes!

`timfallmk/zookeeper:hacky` This is the docker image and the repository to pull it from. The `hacky` tag here pulls a version with has the hacky `myid` workarounds mentioned above.

The container should now go through some initial setup and will running everything necessary. Since we *aren't* using `fleet` to launch units here, we might need to initially set some keys in `etcd` for the first run configuration.

To do this, we can use `etcdctl` to set a key in the following place, with a `JSON` payload.

```shell
etcdctl set /service/zookeeper/<what we used for the ip earlier> '{"id":"1","address":"<same ip>","quorumport":"2888","electionport":"3888"}'
```

This should set the key for the initial run so things can be substituted properly.


**Congratulations** you're now up and running with one node. You'll notice from the output that the `zoo.cfg` and `myid` files have been configured and the cluster is up and running. If you repeat the steps above with a second container (making sure to change the id and ip accordingly), you can watch as the new key in `etcd` is detected by `confd`, and it automatically updates all the necessary configs, restarting `zookeeper` afterwards.

Boom. Done.

##### With `systemd`
The easiest (and most automated) way to launch and manage the cluster is with `systemd`. We'll be doing it in CoreOS, which already has all the components we need. This assumes you already have a cluster up and running.

The steps here are very simple. We have `systemd` unit file templates which we will load into `fleet` and then just launch then. It's that easy. Let's do it.


First clone the repo onto whatever node you'll be working on. Which node doesn't matter.

```shell
git clone https://github.com/midonet/bees.git
```

Now lets switch to the "hacky-version-that-works" branch (*sigh*)

```shell
git fetch && git checkout hacky-version-that-works
```

Finally, `systemd` can bit a little finicky, so we'll need to load our templates carefully. First lets move to the `systemd/templates` directory and upload our *templates*.

```shell
fleetctl submit ./*
```
**Important** Make sure you **don't** `load` or `start` you're template files. If you do `systemd` will get very confused and you'll need to reload the daemon. CoreOS is working on this.

Now, to make things easier, lets make some unit files that are symlinks to our templates. Go to `../systemd` and create the `instances` directory. You don't technically have to do things this way, but it makes it much easier. Once that's done, lets symlink our templates to specific unit files.

```shell
ln -s ../templates/zookeeper-discover@.service zookeeper-discovery@1.service
ln -s ../templates/zookeeper@.service zookeeper@1.service
```

You can do this as many times as you like, substituting the `1` for whatever the `id` of that instance.

Next lets load up our instances so they're ready to run.

```shell
fleetctl load ./*
```

Now we're all ready to run. Lets launch just one this time, so we can see what happens.

```shell
fleetctl start ./zookeeper@1.service
```

This should start the unit on whatever host it was scheduled on. You can watch the process with `fleetctl journal --follow zookeeper@1.service`. You'll notice the same setup as without `systemd` as it's using the same container.

Your node should now be running. If you run `etcdctl ls --recursive /services/zookeeper/` you should see an entry for the node that is now running. You can also try launching another unit and see it get scheduled somewhere else (as there is a restriction limiting one node to one host for now). You should see that a new key has been added in `etcd` and that the original node notices the change and reconfigures itself automatically. `fleet` will automatically reschedule if there are failures, and you can add or remove units in the same way as we just did.

Congratulations, scale up or down at your leisure.
