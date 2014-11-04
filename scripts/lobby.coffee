class Rcon

  constructor: (server, fn) ->
    @server = server
    ctx = new (require 'simple-rcon')(@server.host, @server.port, @server.rcon)
    ctx.on('error', (err) -> console.error 'rcon error', err)
        .on('authenticated', -> return fn(ctx))

module.exports = (robot) ->

  affirmative = [
    'as you wish, master.'
    'i exist to serve.'
    'yes ma\'am!'
    'man, oh man.'
    'you da main maing, maing!'
    'yes, yes, very well.'
    'work, work.'
    'very well, friend.'
  ]

  negative = [
    'meh'
    'awww'
    'hmmm'
    'sigh'
    'gosh'
    'bleh'
  ]

  mistake = [
    'silly-billy'
    'my, oh my, you are a funny one'
    'oops'
    'i\'m pregnant, also'
    'well, this is awkward'
    'oh dear'
    'you too slow, maing'
    'uh-oh'
    'um, this is embarrassing'
  ]

  servers =
    is1:
      name: 'is1'
      host: '196.38.180.26'
      port: 27095
      tv: ''
      password: 'games'
      rcon: process.env.RCON_IS1 ? ''
    is2:
      name: 'is2'
      host: '196.38.180.26'
      port: 27115
      tv: ''
      password: 'games'
      rcon: process.env.RCON_IS2 ? ''
    mweb1:
      name: 'mweb1'
      host: '152.111.192.250'
      port: 27015
      tv: '152.111.192.250:27030'
      password: 'games'
      rcon: process.env.RCON_MWEB1 ? ''
    mweb2:
      name: 'mweb2'
      host: '197.80.200.27'
      port: 27015
      tv: '197.80.200.27:27030'
      password: 'games'
      rcon: process.env.RCON_MWEB2 ? ''
    mweb3:
      name: 'mweb3'
      host: '152.111.192.253'
      port: 27017
      tv: '152.111.192.253:27030'
      password: 'games'
      rcon: process.env.RCON_MWEB3 ? ''
    mweb4:
      name: 'mweb4'
      host: '197.80.200.34'
      port: 27015
      tv: '197.80.200.34:27030'
      password: 'games'
      rcon: process.env.RCON_MWEB4 ? ''
    mweb5:
      name: 'mweb5',
      host: '197.80.200.21'
      port: 27015
      tv: '197.80.200.21:27030'
      password: 'games'
      rcon: process.env.RCON_MWEB5 ? ''

  serverList = Object.keys servers

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

  filterMaps = (desired, mapList) ->

    mapList.filter (map) -> map.indexOf(desired) isnt -1

  newLobby = (map, principal, server) ->
    {
      createdAt: (new Date()).toJSON()
      map: map
      server: server
      principal: principal ? 'tfbot'
      participants: {}
      finalising: false
    }

  finalising = (robot, msg) ->
    lobby = robot.brain.get 'lobby'
    server = servers[lobby.server]

    if lobby?
      players = Object.keys lobby.participants

      if players.length is 12

        new Rcon(server, (ctx) ->
          ctx.exec('sm_say [ #tfbot ] Pickup is full!')
          ctx.exec("sm_say [ #tfbot ] Map: #{lobby.map}")
          ctx.exec("sm_say [ #tfbot ] Players: #{players.join(' ')}")
          ctx.exec("sm_say [ #tfbot ] irc.shadowfire.org / antino.co.za/tfbot")
          ctx.close()
        )

        robot.brain.set 'lobby', null
        robot.brain.set 'previous', lobby
        msg.send "be a darling and click the link: steam://connect/#{server.host}:#{server.port}/#{server.password}"
        msg.send "no guarantee can be made that your place will still be available if you're late."
        return msg.send "also, if you're late often, a suitable punishment will be given."
      else
        lobby.finalising = false
        robot.brain.set 'lobby', lobby
        return msg.send "darn, it looks like we didn't find enough players in time. but never fear! tfbot is here to comfort you while you cry yourself to sleep."

  robot.leave (msg) ->
    lobby = robot.brain.get 'lobby'
    return unless lobby?

    user = msg.message.user.id
    players = Object.keys(lobby.participants)

    if lobby? and user in players
      delete lobby.participants[user]
      robot.brain.set 'lobby', lobby
      return msg.send "|| #{lobby.server} | #{lobby.map} | #{players.length}/12 | [ #{players.join(', ')} ] ||"

  robot.respond /rcon (say|message|msg) (.*) on (.*)/i, (msg) ->
    server = servers[msg.match[3].toLowerCase()]

    return unless server?.rcon

    new Rcon(server, (ctx) ->
      ctx.exec("sm_say #{msg.match[2]}", (res) ->
        ctx.close()
        return msg.reply "#{msg.random(affirmative)} your message was delivered..."
      )
    )

  robot.respond /rcon (list|the list|roster|players) on (.*)/i, (msg) ->
    previous = robot.brain.get 'previous'
    server = servers[msg.match[2].toLowerCase()]

    return unless server?.rcon and previous?

    new Rcon(server, (ctx) ->
      ctx.exec("sm_say [ #tfbot ] #{Object.keys(previous.participants).join(' ')}", (res) ->
        ctx.close()
        return msg.reply "#{msg.random(affirmative)} player roster was delivered..."
      )
    )

  robot.respond /rcon (change map|changelevel|map) on (.*) to (.*)/i, (msg) ->

    server = servers[msg.match[2].toLowerCase()]
    map = msg.match[3].toLowerCase()

    if server?.rcon and (map in maps or filterMaps(map, maps).length is 1)
      new Rcon(server, (ctx) ->
        ctx.exec("changelevel #{map}", (res) ->
          ctx.close()
          return msg.reply "#{msg.random(affirmative)} changing map as we speak..."
        )
      )
    else
      return msg.reply "um, i don't know that map. awkwaaaard..."

  robot.respond /(sg|new) (.*)/i, (msg) ->

    lobby = robot.brain.get('lobby')

    return msg.reply "#{msg.random(mistake)}, it seems a pickup is already filling..." if lobby?

    msg.send "#{msg.random(affirmative)} starting a new pickup..."
    user = msg.message.user.id

    validMap = msg.match[2] in maps
    filtered = filterMaps(msg.match[2], maps)

    if validMap
      map = msg.match[2]
    else if filtered.length is 1
      map = filtered[0]
    else
      map = msg.random maps

    created = newLobby(map, user, msg.random(serverList[0..3]))
    robot.brain.set('lobby', created)
    return msg.send "|| #{created.map} | #{Object.keys(created.participants).length}/12 | [  ] ||"

  robot.respond /(cg|kill)/i, (msg) ->

    lobby = robot.brain.get 'lobby'
    return msg.reply "#{msg.random(mistake)}, there\'s no pickup filling..." unless lobby?

    user = msg.message.user.id # check their auth if target isn't them

    # cancel the game
    robot.brain.set 'lobby', null

    return msg.send "#{msg.random(negative)}, pickup cancelled..."

  robot.respond /add (me|.*)/i, (msg) ->
    lobby = robot.brain.get('lobby')
    user = msg.message.user.id # check their auth if target isn't them
    target = if msg.match[1] is 'me' then user else msg.match[1].trim()

    if not lobby?

      lobby = newLobby(msg.random(maps), user, msg.random(serverList[0..2]))
      robot.brain.set 'lobby', lobby

    players = Object.keys(lobby.participants)

    if players.length < 12

      if target not in players

        lobby.participants[target] = target
        robot.brain.set 'lobby', lobby
        players = Object.keys(lobby.participants)
        msg.send "|| #{lobby.server} | #{lobby.map} | #{players.length}/12 | [ #{players.join(', ')} ] ||"
        return unless players.length is 12 and not lobby.finalising

        return setTimeout(finalising, 60000, robot, msg)

      return msg.reply "#{if msg.match[1] is 'me' then 'you are' else target + ' is'} already added..."

    return msg.reply "#{msg.random(mistake)}, the pickup is already full..."

  robot.respond /rem (me|.*)/i, (msg) ->
    lobby = robot.brain.get('lobby')

    return msg.reply "#{msg.random(mistake)}, there\'s no pickup filling..." if not lobby?

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

    return msg.reply "#{msg.random(mistake)}, there\'s no pickup filling..." unless lobby?

    validMap = msg.match[2] in maps
    filtered = filterMaps(msg.match[2], maps)

    if validMap
      map = msg.match[2]
    else if filtered.length is 1
      map = filtered[0]
    else
      map = msg.random maps

    lobby.map = map
    robot.brain.set('lobby', lobby)
    return msg.reply "#{msg.random(affirmative)} changing map to #{map}..."

  robot.respond /server (.*)/i, (msg) ->
    lobby = robot.brain.get('lobby')

    return msg.reply "#{msg.random(mistake)}, there\'s no pickup filling..." unless lobby?

    user = msg.message.user.id # check their auth
    if msg.match[1] in serverList
      lobby.server = msg.match[1]
      robot.brain.set 'lobby', lobby
      return msg.reply "#{msg.random(affirmative)} changing the server to #{msg.match[1]}..."

    return msg.reply "#{msg.random(mistake)}, #{msg.match[1]} isn't a valid server..."

  robot.respond /(status|games)/i, (msg) ->
    lobby = robot.brain.get('lobby')

    return msg.reply "#{msg.random(mistake)}, there\'s no pickup filling..." unless lobby?

    players = Object.keys(lobby.participants)
    return msg.send "|| #{lobby.server} | #{lobby.map} | #{players.length}/12 | [ #{players.join(', ')} ] ||"
