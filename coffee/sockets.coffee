initSockets = ->
  ModulesSockets.shortcutsCfg = (socket, data, cb) ->
    cb null, getConfig()