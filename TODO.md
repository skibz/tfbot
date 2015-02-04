- [ ] configure redis: `redis.conf`
  + [x] Add vm.overcommit_memory = 1 to /etc/sysctl.conf and then reboot or run the command sysctl vm.overcommit_memory=1 for this to take effect immediately.
  + [ ] Make sure to setup some swap in your system (we suggest as much as swap as memory).
- [ ] add the rules to hubot-rules
- [x] add roles for rcon, pickup handling and super admins
- [x] ubuntu service `.conf` script
