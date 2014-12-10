- [ ] configure redis: `redis.conf` 
  + [ ] Add vm.overcommit_memory = 1 to /etc/sysctl.conf and then reboot or run the command sysctl vm.overcommit_memory=1 for this to take effect immediately.
  + [ ] Make sure to setup some swap in your system (we suggest as much as swap as memory).
- [ ] add the rules to hubot-rules
- [x] add roles for rcon, pickup handling and super admins
- [x] ubuntu service `.conf` script
- [ ] health check - report redis status and node status
- [ ] scripts:
    + [ ] look of disapproval
    + [ ] insult
    + [ ] mindkiller
    + [ ] minime
    + [ ] mitch-hedburg
    + [ ] nice
    + [ ] nickgen
    + [ ] pinboard
    + [ ] pizza
    + [ ] points
    + [ ] reddit-random-top
    + [ ] robot-memes
    + [ ] sms
    + [ ] steam
    + [ ] sweetdude
    + [ ] web
    + [ ] webcam
    + [ ] whoisout
    + [ ] wolfram
    + [ ] advice
    + [ ] bees
    + [ ] cheer
    + [ ] conversation
    + [ ] decide
    + [ ] f-ing-weather
    + [ ] flip
    + [ ] iced-coffee-weather
    + [ ] javascript-sandbox
    + [ ] lastfm_np
    + [ ] remember
