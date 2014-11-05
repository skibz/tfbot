- [] configure redis: `redis.conf` 
  + [] Add vm.overcommit_memory = 1 to /etc/sysctl.conf and then reboot or run the command sysctl vm.overcommit_memory=1 for this to take effect immediately.
  + [] Make sure to setup some swap in your system (we suggest as much as swap as memory).
- [] add the rules to hubot-rules
- [x] add roles for rcon, pickup handling and super admins
- [] finish porting existing tfbot code
  + [x] check a users auth status if they try do something admin'ey
- [] add http handlers for `antino.co.za` service calls
- [] unit testing with io-digital/actuator
- [] .travis.yml
- [] coveralls.io
- [x] ubuntu service `.conf` script
