initSockets = ->
  ModulesSockets.shortcutsCfg = (socket, data, cb) ->
    config = cfg.get()
    config.descriptions = descriptions
    cb null, config

  ModulesSockets.shortcutsAdminSettings = (socket, data, cb) -> cfg.set(data.settings).persist cb