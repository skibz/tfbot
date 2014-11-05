- [ ] configure redis: `redis.conf` 
  + [ ] Add vm.overcommit_memory = 1 to /etc/sysctl.conf and then reboot or run the command sysctl vm.overcommit_memory=1 for this to take effect immediately.
  + [ ] Make sure to setup some swap in your system (we suggest as much as swap as memory).
- [ ] add the rules to hubot-rules
- [x] add roles for rcon, pickup handling and super admins
- [ ] finish porting existing tfbot code
  + [x] check a users auth status if they try do something admin'ey
- [ ] unit testing with io-digital/actuator
- [ ] .travis.yml
- [ ] coveralls.io
- [x] ubuntu service `.conf` script
- [ ] document entire pickups script https://github.com/github/hubot/blob/master/docs/scripting.md#documenting-scripts
- [ ] encapsulate pickups script so it can be reloaded https://github.com/github/hubot/blob/master/docs/scripting.md#creating-a-script-package
- [ ] add irc emote responses https://github.com/github/hubot/blob/master/docs/scripting.md#send--reply
- [ ] add http calls for steam group announcements https://github.com/github/hubot/blob/master/docs/scripting.md#making-http-calls
- [ ] consider using the topic changer https://github.com/github/hubot/blob/master/docs/scripting.md#topic
