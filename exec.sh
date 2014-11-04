#!/usr/env bash

export HUBOT_AUTH_ADMIN=skiba,skibabot,seamonkey,cmky

export HUBOT_IRC_SERVER=irc.shadowfire.org
export HUBOT_IRC_ROOMS=#skibachan
export HUBOT_IRC_NICK=skibabot
# export HUBOT_IRC_NICKSERV_PASSWORD=_tc_hydr0
# export HUBOT_IRC_NICKSERV_USERNAME=tfbot
# export HUBOT_IRC_DEBUG=true

bin/hubot -a irc --name skibabot --alias ! --config-check
