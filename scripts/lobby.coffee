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
    'I am sworn to carry your burdans.'
    'I\'m invincible!'
    'Well, I am king.'
    'Yes, milord.'
    'You can be my wingman any time.'
    'Whose butt did you kiss to get in here anyway?'
    'Affirmative, Dave. I read you.'
    'You had me at \'hello.\''
    'Inform the men.'
    'Good news, everyone!'
    'tfbot is credit to team!'
  ]

  negative = [
    'meh.'
    'awww.'
    'hmmm.'
    'sigh.'
    'gosh.'
    'bleh.'
    'Help! Help! I\'m being repressed!'
    'No, it\'s too perilous.'
    'That\'s enough music for now, lads.'
    'Negative, Ghost Rider, the pattern is full.'
    'I\'m sorry, Dave. I\'m afraid I can\'t do that.'
    'What we\'ve got here is failure to communicate.'
    'You\'re gonna need a bigger boat.'
    'Bite my shiny metal ass.'
    'Use more gun'
    'BONK!'
  ]

  mistake = [
    'awkwaaard, but,'
    'silly-billy!'
    'my, oh my, you are a funny one.'
    'oops?'
    'i\'m pregnant, also,'
    'well, this is awkward.'
    'oh dear.'
    'you too slow, maing.'
    'uh-oh!'
    'um, this is embarrassing...'
    'Angry mob: \'Ooooh!\''
    'Ekki-ekki-ekki-ekki-PTANG. Zoom-Boing, z\'nourrwringmm.'
    'How does it... um... how does it work?'
    '\'Ere, he says he\'s not dead.'
    'D\'oh!'
    'Just what do you think you\'re doing, Dave?'
    'Toto, I\'ve got a feeling we\'re not in Kansas anymore.'
    'Mama always said life was like a box of chocolates.'
    'I just work here.'
    'A sexy mistake.'
    'I don\'t get it.'
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

        today = robot.brain.get 'today'

        today = { players: {}, maps: {} } unless today?

        for player in players
          if today.players.hasOwnProperty player
            today.players[player]++
          else
            today.players[player] = 1

        if today.maps.hasOwnProperty lobby.map
          today.maps[lobby.map]++
        else
          today.maps[lobby.map] = 1

        robot.brain.set 'today', today

        robot.brain.set 'lobby', null
        robot.brain.set 'previous', lobby
        msg.send "be a darling and click the link: steam://connect/#{server.host}:#{server.port}/#{server.password}"
        msg.send "no guarantee can be made that your place will still be available if you're late."
        return msg.send "also, if you're late often, a suitable punishment will be awarded."

      lobby.finalising = false
      robot.brain.set 'lobby', lobby
      return msg.send "#{msg.random(mistake)}, it looks like we didn't find enough players in time. but never fear! tfbot is here to comfort you while you cry yourself to sleep."

  robot.leave (msg) ->
    lobby = robot.brain.get 'lobby'
    return unless lobby?

    user = msg.message.user.id
    players = Object.keys(lobby.participants)

    if user in players
      delete lobby.participants[user]
      robot.brain.set 'lobby', lobby
      return msg.send "|| #{lobby.server} | #{lobby.map} | #{players.length}/12 | [ #{players.join(', ')} ] ||"

  robot.respond /rcon (say|message|msg) (.*) on (.*)/i, (msg) ->
    user = msg.message.user.id

    server = servers[msg.match[3].toLowerCase()]

    if robot.auth.hasRole(msg.envelope.user, 'rcon')

      if server?.rcon
        new Rcon(server, (ctx) ->
          ctx.exec("sm_say #{msg.match[2]}", (res) ->
            ctx.close()
            msg.reply "#{msg.random(affirmative)} your message was delivered..."
          )
        )
        return

      return msg.reply "#{msg.random(mistake)}, that's not a valid server..."

    return msg.reply "#{msg.random(mistake)}, you can't to do that..."

  robot.respond /rcon (list|the list|roster|players) on (.*)/i, (msg) ->
    user = msg.message.user.id

    if robot.auth.hasRole(msg.envelope.user, 'rcon')

      previous = robot.brain.get 'previous'
      server = servers[previous.server]

      if previous? and server?.rcon
        new Rcon(server, (ctx) ->
          ctx.exec("sm_say [ #tfbot ] #{Object.keys(previous.participants).join(' ')}", (res) ->
            ctx.close()
            msg.reply "#{msg.random(affirmative)} player roster was delivered..."
          )
        )
        return

      return msg.reply "#{msg.random(mistake)}, there's no previous game data. creepy..."

    return msg.reply "#{msg.random(mistake)}, you can't to do that..."

  robot.respond /rcon (change map|changelevel|map) on (.*) to (.*)/i, (msg) ->
    user = msg.message.user.id
    server = servers[msg.match[2].toLowerCase()]
    map = msg.match[3].toLowerCase()

    if robot.auth.hasRole(msg.envelope.user, 'rcon')

      if server?.rcon and (map in maps or filterMaps(map, maps).length is 1)
        new Rcon(server, (ctx) ->
          ctx.exec("changelevel #{map}", (res) ->
            ctx.close()
            msg.reply "#{msg.random(affirmative)} changing map as we speak..."
          )
        )
        return

      return msg.reply "#{msg.random(mistake)}, i don't know that map..."

    return msg.reply "#{msg.random(mistake)}, you can't to do that..."

  robot.respond /(sg|new) (.*)/i, (msg) ->
    user = msg.message.user.id

    if robot.auth.hasRole(msg.envelope.user, 'officer')
      lobby = robot.brain.get('lobby')
      return msg.reply "#{msg.random(mistake)}, it seems a pickup is already filling..." if lobby?

      msg.send "#{msg.random(affirmative)} starting a new pickup..."


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

    return msg.send "#{msg.random(mistake)}, you can't to do that..."

  robot.respond /(cg|kill)/i, (msg) ->
    user = msg.message.user.id

    if robot.auth.hasRole(msg.envelope.user, 'officer')
      lobby = robot.brain.get 'lobby'
      return msg.reply "#{msg.random(mistake)}, there\'s no pickup filling..." unless lobby?

      # cancel the game
      robot.brain.set 'lobby', null

      return msg.send "#{msg.random(negative)}, pickup cancelled..."

    return msg.send "#{msg.random(negative)}, you can't to do that..."

  robot.respond /add (me|.*)/i, (msg) ->

    user = msg.message.user.id
    lobby = robot.brain.get('lobby')
    target = if msg.match[1] is 'me' then user else msg.match[1].trim()

    if target is 'me' or (target isnt 'me' and robot.auth.hasRole(msg.envelope.user, 'officer'))

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

    return msg.reply "#{msg.random(mistake)}, you can't to do that..."

  robot.respond /rem (me|.*)/i, (msg) ->
    user = msg.message.user.id
    target = if msg.match[1] is 'me' then user else msg.match[1]

    if target is 'me' or (target isnt 'me' and robot.auth.hasRole(msg.envelope.user, 'officer'))
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

    return msg.reply "#{msg.random(mistake)}, you can't do that..."

  robot.respond /map (.*)/i, (msg) ->
    user = msg.message.user.id

    if robot.auth.hasRole(msg.envelope.user, 'officer')

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

    return msg.reply "#{msg.random(mistake)}, you can't do that..."

  robot.respond /server (.*)/i, (msg) ->
    user = msg.message.user.id

    if robot.auth.hasRole(msg.envelope.user, 'officer')

      lobby = robot.brain.get('lobby')

      return msg.reply "#{msg.random(mistake)}, there\'s no pickup filling..." unless lobby?

      if msg.match[1] in serverList
        lobby.server = msg.match[1]
        robot.brain.set 'lobby', lobby
        return msg.reply "#{msg.random(affirmative)} changing the server to #{msg.match[1]}..."

      return msg.reply "#{msg.random(mistake)}, #{msg.match[1]} isn't a valid server..."

    return msg.reply "#{msg.random(mistake)}, you can't do that..."

  robot.respond /(status|games)/i, (msg) ->
    lobby = robot.brain.get('lobby')

    return msg.reply "#{msg.random(mistake)}, there\'s currently no pickup..." unless lobby?

    players = Object.keys(lobby.participants)
    return msg.send "|| #{lobby.server} | #{lobby.map} | #{players.length}/12 | [ #{players.join(', ')} ] ||"

  robot.respond /(recent|recent game|previous|last game|lastgame|previous game)/i, (msg) ->
    previous = robot.brain.get 'previous'
    return msg.send "#{msg.random(negative)}, no previous match data..." unless previous?
    return msg.send "|| #{previous.principal} | #{previous.server} | #{previous.map} | [ #{Object.keys(previous.participants).join(', ')} ] | #{new Date(previous.createdAt).toString()} ||"

  robot.respond /top (maps|players)/i, (msg) ->
    today = robot.brain.get 'today'

    return msg.send "#{msg.random(negative)}, i haven't captured any daily data yet..." unless today?

    response = '||'

    if msg.match[1] is 'maps'

      if not Object.keys(today.maps).length
        return msg.send "#{msg.random(negative)}, i haven't captured any daily map data yet..."

      for map, played of today.maps
        response += " #{map}: #{played} |"

      return msg.send "#{response}|"

    else

      if not Object.keys(today.players).length
        return msg.send "#{msg.random(negative)}, i haven't captured any daily player data yet..."

      for player, played of today.players
        response += " #{player}: #{played} |"

      return msg.send "#{response}|"
