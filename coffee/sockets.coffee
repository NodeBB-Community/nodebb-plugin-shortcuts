initSockets = ->
  ModulesSockets.shortcutsCfg = (socket, data, cb) ->
    cfg = getConfig()
    cfg.descriptions = descriptions
    cb null, cfg