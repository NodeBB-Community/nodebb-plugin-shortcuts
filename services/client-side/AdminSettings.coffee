define ->
  id = ''
  version = ''
  cfg = {}
  fields = $()
  sKey = -> "settings:#{id}"

  fillField = (field, value) ->
    value = value.join ', ' if value instanceof Array
    if field.is 'input' && field.attr('type') == 'checkbox'
      field.prop 'checked', value
    else
      field.val value if value?

  getValue = (key) ->
    keyParts = key.split '.'
    val = cfg
    val = val[k] for k in keyParts when k && val?
    val

  setValue = (key, value) ->
    keyParts = key.split '.'
    if getValue(key) instanceof Array
      value = value.split ','
      value[i] = val.trim() for i, val of value
    parentCfg = cfg
    if keyParts.length > 1
      parentCfg = parentCfg[k] for k in keyParts[0..keyParts.length - 2] when k && parentCfg?
    parentCfg[keyParts[keyParts.length - 1]] = value

  Settings =
    get: ->
      cfg
    init: (name) ->
      id = name if name?
      if !app.config?
        setTimeout Settings.init, 125
        return;
      Settings.sync()
    sync: ->
      conf = JSON.parse app.config[sKey()]
      cfg = conf.settings
      version = conf.version
      fields = $ 'form [data-key]'
      fields.each (ignored, field) ->
        field = $ field
        fillField field, getValue field.data('key')
      $('#save').click (e) ->
        e.preventDefault()
        Settings.persist()
    persist: ->
      fields.each (ignored, field) ->
        field = $ field
        value = if field.is 'input' && field.attr('type') == 'checkbox' then field.prop 'checked' else field.val()
        setValue field.data('key'), value
      socket.emit 'modules.settingsSet',
        id: id
        settings: cfg
        version: version
      , (err) ->
        if err?
          return app.alert
            alert_id: 'config_status'
            timeout: 2500
            title: 'Changes Not Saved'
            message: 'NodeBB encountered a problem saving your changes'
            type: 'danger'
        app.config[sKey()] = JSON.stringify cfg if app.config[sKey()]?
        app.alert
          alert_id: 'config_status'
          timeout: 2500
          title: 'Changes Saved'
          message: 'Your changes to the NodeBB configuration have been saved.'
          type: 'success'