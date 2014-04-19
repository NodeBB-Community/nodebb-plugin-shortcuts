initSockets = ->
  ModulesSockets.shortcutsCfg = (socket, data, cb) ->
    config = cfg.get()
    config.descriptions = descriptions
    cb null, config