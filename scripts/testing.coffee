module.exports = (robot) ->

  servers =
    is1:
      name: 'is1'
      host: '196.38.180.26'
      port: 27095
      tv: ''
      password: 'games'

    is2:
      name: 'is2'
      host: '196.38.180.26'
      port: 27115
      tv: ''
      password: 'games'

    mweb1:
      name: 'mweb1'
      host: '152.111.192.250'
      port: 27015
      tv: '152.111.192.250:27030'
      password: 'games'
      rcon: ''
    mweb2:
      name: 'mweb2'
      host: '197.80.200.27'
      port: 27015
      tv: '197.80.200.27:27030'
      password: 'games'
      rcon: ''
    mweb3:
      name: 'mweb3'
      host: '152.111.192.253'
      port: 27017
      tv: '152.111.192.253:27030'
      password: 'games'
      rcon: ''
    mweb4:
      name: 'mweb4'
      host: '197.80.200.34'
      port: 27015
      tv: '197.80.200.34:27030'
      password: 'games'
      rcon: ''
    mweb5:
      name: 'mweb5',
      host: '197.80.200.21'
      port: 27015
      tv: '197.80.200.21:27030'
      password: 'games'
      rcon: ''

  serverList = [
    servers.is1.name
    servers.is2.name
    servers.mweb1.name
    servers.mweb2.name
    servers.mweb3.name
    servers.mweb4.name
    servers.mweb5.name
  ]

  maps = [
    'cp_gravelpit',
    'cp_badlands',
    'cp_freight_final1',
    'cp_granary',
    'cp_gullywash_final1',
    'cp_process_final',
    'cp_snakewater_final1',
    'cp_well',
    'cp_follower',
    'cp_intermodal_g1f',
    'cp_metalworks_rc5',
    'cp_prolane_v4',
    'cp_sunshine_rc1a',
    'cp_warmfront',
    'ctf_turbine_pro_rc2',
    'koth_pro_viaduct_rc4'
  ]

  newLobby = (map, principal, server) ->
    {
      createdAt: (new Date()).toJSON()
      map: map
      server: server
      principal: principal ? 'tfbot'
      participants: {}
      finalising: false
    }

  robot.respond /(sg|new) (.*)/i, (msg) ->

    lobby = robot.brain.get('lobby')

    return msg.reply 'a pickup is already filling...' if lobby?

    user = msg.message.user.id

    filtered = maps.filter((val, idx, arr) -> val.indexOf msg.match[2] isnt -1) if map.length > 3
    map = msg.random maps
    map = filtered[0] if filtered.length is 1

    created = newLobby(map, user, msg.random(serverList[0..2]))
    robot.brain.set('lobby', created)
    return msg.send "|| #{created.map} | #{Object.keys(created.participants).length}/12 | [  ] ||"



  robot.respond /(cg|kill)/i, (msg) ->

    lobby = msg.message.user.id
    return msg.reply 'there\'s no pickup filling...' unless lobby?

    user = msg.message.user.id # check their auth if target isn't them

    # cancel the game
    robot.brain.set 'lobby', null


  robot.respond /add (me|.*)/i, (msg) ->
    lobby = robot.brain.get('lobby')
    user = msg.message.user.id # check their auth if target isn't them
    target = if msg.match[1] is 'me' then user else msg.match[1].trim()

    if not lobby?
      msg.send 'Creating new pickup...'
      lobby = newLobby(msg.random(maps), user, msg.random(serverList[0..2]))
      robot.brain.set 'lobby', lobby

    players = Object.keys(lobby.participants)

    if players.length < 13

      if target not in players

        lobby.participants[target] = target
        robot.brain.set 'lobby', lobby
        players = Object.keys(lobby.participants)
        return msg.send "|| #{lobby.server} | #{lobby.map} | #{players.length}/12 | [ #{players.join(', ')} ] ||"

      return msg.reply "#{if msg.match[1] is 'me' then 'you are' else target + ' is'} already added..."

    return msg.reply 'the pickup is full...'

  robot.respond /rem (me|.*)/i, (msg) ->
    lobby = robot.brain.get('lobby')

    return msg.reply 'there\'s no pickup filling...' if not lobby?

    user = msg.message.user.id # check their auth if target isn't them
    target = if msg.match[1] is 'me' then user else msg.match[1]
    players = Object.keys(lobby.participants)

    if target in players
      delete lobby.participants[target]
      players = Object.keys(lobby.participants)
      robot.brain.set 'lobby', lobby
      return msg.send "|| #{lobby.server} | #{lobby.map} | #{players.length}/12 | [ #{players.join(', ')} ] ||"

    return msg.reply "#{if msg.match[1] is 'me' then 'you\'re not' else target + '\'s not'} added to the pickup..."

  robot.respond /map (.*)/i, (msg) ->
    lobby = robot.brain.get('lobby')

    return msg.reply 'there\'s no pickup filling...' unless lobby?

    map = msg.match[1]

    if map in maps

      lobby.map = map
      robot.brain.set('lobby', lobby)
      return msg.reply "changed map to #{map}..."

    else if map.length > 3

      filtered = maps.filter (m) -> m.indexOf map isnt -1

      if filtered.length is 1
        lobby.map = filtered[0]
        robot.brain.set('lobby', lobby)
        return msg.reply "changed map to #{filtered[0]}..."

      return msg.reply filtered

  robot.respond /server (.*)/i, (msg) ->
    lobby = robot.brain.get('lobby')

    return msg.reply 'there\'s no pickup filling...' unless lobby?

    user = msg.message.user.id # check their auth
    if msg.match[1] in serverList
      lobby.server = msg.match[1]
      robot.brain.set 'lobby', lobby
      return msg.reply "changed server to #{msg.match[1]}..."

    return msg.reply "#{msg.match[1]} isn't a valid server..."

  robot.respond /^status$/i, (msg) ->
    lobby = robot.brain.get('lobby')

    return msg.reply 'there\'s no pickup filling...' unless lobby?

    players = Object.keys(lobby.participants)
    return msg.send "|| #{lobby.server} | #{lobby.map} | #{players.length}/12 | [ #{players.join(', ')} ] ||"



