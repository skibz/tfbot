- [] configure redis: `redis.conf` 
```
Redis setup hints
We suggest deploying Redis using the Linux operating system. Redis is also tested heavily on osx, and tested from time to time on FreeBSD and OpenBSD systems. However Linux is where we do all the major stress testing, and where most production deployments are working.
Make sure to set the Linux kernel overcommit memory setting to 1. Add vm.overcommit_memory = 1 to /etc/sysctl.conf and then reboot or run the command sysctl vm.overcommit_memory=1 for this to take effect immediately.
Make sure to setup some swap in your system (we suggest as much as swap as memory). If Linux does not have swap and your Redis instance accidentally consumes too much memory, either Redis will crash for out of memory or the Linux kernel OOM killer will kill the Redis process.
Set an explicit maxmemory option limit in your instance in order to make sure that the instance will report errors instead of failing when the system memory limit is near to be reached.
If you are using Redis in a very write-heavy application, while saving an RDB file on disk or rewriting the AOF log Redis may use up to 2 times the memory normally used. The additional memory used is proportional to the number of memory pages modified by writes during the saving process, so it is often proportional to the number of keys (or aggregate types items) touched during this time. Make sure to size your memory accordingly.
Use daemonize no when run under daemontools.
Even if you have persistence disabled, Redis will need to perform RDB saves if you use replication, unless you use the new diskless replication feature, which is currently experimental.
If you are using replication, make sure that either your master has persistence enabled, or that it does not automatically restarts on crashes: slaves will try to be an exact copy of the master, so if a master restarts with an empty data set, slaves will be wiped as well.
```
- [] add the rules to hubot-rules
- [] add roles for rcon, pickup handling and super admins
- [] druid, kenny, joe and axtremes are mweb admins. assign pickup handling and rcon roles.
- [] add auth handling in each protected `robot.respond`
- [] finish porting existing tfbot code
- [] add http handlers for `antino.co.za` service calls
- [] unit testing with io-digital/actuator
- [] .travis.yml
- [] coveralls.io
- [x] ubuntu service `.conf` script
