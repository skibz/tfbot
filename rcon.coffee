class Rcon

  constructor: (server) ->

    # the sanity checks for the instantiation of the rcon context
    #
    # ie. is rcon enabled in bot options?
    #     does the server exist in the bot's memory?
    #     does the bot know the rcon password for the server?

    @server = server
    @ctx = new (require('simple-rcon'))(@server.host, @server.port, @server.rcon)
    @ctx.on('error' (err) -> console.error 'rcon error', err)

  changeLevel: (map, fn) ->
    @ctx.exec("changelevel #{map}", (res) ->
      @ctx.close()
      fn res.body if res
    ) if @ctx?

  mapVote: (maps, fn) ->

    defaultMaps = "#{'"cp_badlands" "cp_snakewater_final1" "cp_process_final" "cp_gullywash_final1" "cp_granary"'}"
    maps = maps.map((m) -> "#{'"' + m + '"'}").join(' ') if maps.length

    @ctx.exec("sm_votemap #{if maps? then maps else defaultMaps}", (res) ->
      @ctx.close()
      fn res.body if res
    ) if @ctx?

  cancelVote: (fn) ->
    @ctx.exec("sm_cancelvote", (res) ->
      @ctx.close()
      fn res.body if res
    ) if @ctx?

  announce: (map, roster, fn) ->
    if @ctx?
      @ctx.exec('sm_say [ #tfbot ] Pickup is full!')
      @ctx.exec("sm_say [ #tfbot ] Map: #{map}")
      @ctx.exec("sm_say [ #tfbot ] Players: #{roster}")
      @ctx.exec("sm_say [ #tfbot ] irc.shadowfire.org / antino.co.za/tfbot")
      @ctx.close()
      fn()

module.exports = Rcon
