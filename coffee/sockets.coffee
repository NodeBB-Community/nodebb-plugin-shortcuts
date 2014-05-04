initSockets = ->
  SocketModules.getShortcutsSettings = (socket, data, callback) ->
    conf = cfg.get()
    conf.descriptions = descriptions
    conf.version = pkg.version
    callback null, conf

  SocketAdmin.settings.syncShortcuts = ->
    cfg.sync()

  SocketAdmin.settings.getShortcutsDefaults = (socket, data, callback) ->
    callback null, cfg.createDefaultWrapper()