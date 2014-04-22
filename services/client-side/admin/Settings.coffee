define ->
  plugins = [
    '../../plugins/nodebb-plugin-shortcuts/services/admin/SettingsArray'
    '../../plugins/nodebb-plugin-shortcuts/services/admin/SettingsKey'
  ]

  ### Hooks a plugin can register: (all elements are JQuery-objects)
   # init(element)
   # create(type, tagName)
   # set(element, textValue, value, trim)
   # get(element, trim, empty)
  ###

  getHook = (type, name) ->
    if typeof type != 'string'
      type = $ type
      type = type.data('type') || type.attr('type') || type.prop 'tagName'
    plugin = Settings.plugins[type.toLowerCase()]
    return null if !plugin?
    plugin[name]

  Settings =
    helper:
      createElement: (tagName, data, text) ->
        el = document.createElement tagName
        el.setAttribute k, v for k, v of data
        el.appendChild document.createTextNode text if text
        el
      initElement: (element) ->
        hook = getHook element, 'init'
        return hook.call Settings, $ element if hook?
        null
      createElementOfType: (type, tagName) ->
        hook = getHook type, 'create'
        el = if hook? then hook.call Settings, type, tagName else switch type.toLowerCase()
          when 'ta', 'textarea' then Settings.helper.createElement 'textarea'
          else
            Settings.helper.createElement tagName || 'input', type: type
        Settings.helper.initElement el
        el
      cleanArray: (arr, trim, empty) ->
        return arr if !trim && empty
        cleaned = []
        for val in arr
          if trim
            val = if val == true then 1 else if val == false then 0 else if val.trim? then val.trim() else val
          cleaned.push val if empty || val.length != 0
        cleaned
      isTrue: (value) -> value == 'true' || +value == 1
      isFalse: (value) -> value == 'false' || +value == 0
      readValue: (field, forceTrim) ->
        trim = forceTrim || !Settings.helper.isFalse field.data 'trim'
        empty = Settings.helper.isTrue field.data 'empty'
        hook = getHook field, 'get'
        return hook.call Settings, field, trim, empty if hook?
        if field.is 'input[type="checkbox"]'
          val = field.prop 'checked'
          if trim then (if val then 1 else 0) else val
        else if (split = field.data 'split')?
          Settings.helper.cleanArray (field.val()?.split(split || ',') || []), trim, empty
        else
          val = field.val()
          if trim && val.trim? then val?.trim() else val
      fillField: (field, value) ->
        trim = field.data 'trim'
        trim = trim != 'false' && +trim != 0
        originalValue = value
        if value instanceof Array
          value = value.join field.data('split') || if trim then ', ' else ','
        hook = getHook field, 'set'
        return hook.call Settings, field, value, originalValue, trim if hook?
        if field.is 'input[type="checkbox"]' then field.prop 'checked', value else if value? then field.val value
    settingsKey: ''
    socketName: ''
    plugins: {}
    cfg: {}
    ready: false
    get: -> Settings.cfg.settings
    registerPlugin: (service, types = service.types) ->
      service.types = types
      service.use Settings if service.use?
      Settings.plugins[type.toLowerCase()] = service for type in types
    init: (key, prefix = "settings:", socketName = "modules.#{key}AdminSettings") ->
      Settings.settingsKey = prefix + key
      Settings.socketName = socketName
      Settings.sync()
    sync: ->
      if !Settings.ready || !app.config?
        setTimeout Settings.sync, 50
        return;
      conf = app.config[Settings.settingsKey]
      try
        conf = JSON.parse conf
      catch
        conf =
          settings: {}
      Settings.cfg = conf
      $('form [data-key]').each (ignored, field) ->
        field = $ field
        hook = getHook field, 'init'
        hook.call Settings, field if hook?
        keyParts = field.data('key').split '.'
        value = Settings.cfg.settings
        value = value[k] for k in keyParts when k && value?
        Settings.helper.fillField field, value
      $('#save').click (e) ->
        e.preventDefault()
        Settings.persist()
    persist: ->
      for field in $('form [data-key]').toArray()
        field = $ field
        value = Settings.helper.readValue field
        keyParts = field.data('key').split '.'
        parentCfg = Settings.cfg.settings
        if keyParts.length > 1
          parentCfg = parentCfg[k] for k in keyParts[0..keyParts.length - 2] when k && parentCfg?
        if parentCfg?
          parentCfg[keyParts[keyParts.length - 1]] = value
        else
          app.alert
            alert_id: new Date().getTime()
            timeout: 5000
            title: 'Attribute Not Saved'
            message: "'#{field.data('key')}' could not be saved. Please contact plugin-author!"
            type: 'danger'
      socket.emit Settings.socketName, Settings.cfg, (err) ->
        if err?
          return app.alert
            alert_id: 'config_status'
            timeout: 2500
            title: 'Changes Not Saved'
            message: 'NodeBB encountered a problem saving your changes'
            type: 'danger'
        app.config[Settings.settingsKey] = JSON.stringify Settings.cfg
        app.alert
          alert_id: 'config_status'
          timeout: 2500
          title: 'Changes Saved'
          message: 'Your changes to the NodeBB configuration have been saved.'
          type: 'success'

  require plugins, (args...) ->
    Settings.registerPlugin plugin for plugin in args
    Settings.ready = true

  Settings