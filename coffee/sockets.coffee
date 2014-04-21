initSockets = ->
  ModulesSockets.shortcutsCfg = (socket, data, cb) ->
    config = cfg.get()
    config.descriptions = descriptions
    cb null, config

  ModulesSockets.settingsSet = (socket, data, cb) ->
    try
      new Configuration
        name: data.id
        version: data.version
      , data.settings, false, false, true, ->
        cfg.sync()
        cb null
    catch
      cb 'error'