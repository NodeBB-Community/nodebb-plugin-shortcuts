define ->
  id = 'shortcuts'
  version = ''
  cfg = {}
  fields = $()
  sKey = ->
    "settings:#{id}"

  createElement = (tagName, data, text) ->
    el = document.createElement tagName
    el.setAttribute k, v for k, v of data
    el.appendChild document.createTextNode text if text
    el

  elementOfType = (type) ->
    switch type.toLowerCase()
      when 'ta', 'textarea' then document.createElement 'textarea'
      when 'array', 'div' then document.createElement 'div'
      else
        el = document.createElement 'input'
        el.setAttribute 'type', type
        el

  fillElement = (el, value) ->
    if el.is 'input[type="checkbox"]'
      el.prop 'checked', value
    else
      el.val value if value?

  createRemoveButton = (elements...) ->
    rm = $ createElement 'button', class: 'btn btn-xs btn-primary remove', '-'
    rm.click (e) ->
      e.preventDefault()
      el.remove() for el in elements
      rm.remove()

  addArrayChildElement = (field, key, type, attributes, value, sep, insertCb) ->
    el = $(elementOfType type).attr 'data-parent', '_' + key
    el.attr k, v for k, v of attributes
    fillField el, value
    separator = document.createTextNode sep
    insertCb separator if $("[data-parent=\"_#{key}\"]", field).length
    insertCb el
    insertCb createRemoveButton separator, el

  fillField = (field, value) ->
    trim = field.data 'trim'
    trim = trim != 'false' && +trim != 0
    if field.is 'div'
      key = field.data('key') || field.data 'parent'
      type = field.data('type') || 'text'
      sep = field.data('split') || ', '
      newValue = field.data 'new'
      newValue = '' if !newValue?
      attributes = field.data 'attributes'
      addArrayChildElement field, key, type, attributes, val, sep, ((el) -> field.append(el)) for val in value
      addSpace = $ document.createTextNode ' '
      add = $ '<button class="btn btn-sm btn-primary add" class="add">+</button>'
      add.click (e) ->
        e.preventDefault()
        addArrayChildElement field, key, type, attributes, newValue, sep, ((el) -> addSpace.before(el))
      field.append addSpace
      field.append add
    else
      if value instanceof Array
        value = value.join field.data('split') || if trim then ', ' else ','
      fillElement field, value

  getValue = (key) ->
    keyParts = key.split '.'
    val = cfg
    val = val[k] for k in keyParts when k && val?
    val

  cleanArray = (arr, trim, empty) ->
    if trim || !empty
      cleanArr = []
      for val in arr
        if trim
          val = if val == true then 1 else if val == false then 0 else if val.trim? then val.trim() else val
        cleanArr.push val if empty || val != ''
      cleanArr
    else
      arr

  readValue = (field, arrayMember = false) ->
    trim = field.data 'trim'
    trim = trim != 'false' && +trim != 0
    empty = field.data 'empty'
    empty = empty == 'true' || +empty == 1
    if field.is 'div'
      key = field.data('key') || field.data 'parent'
      children = $("[data-parent=\"_#{key}\"]", field).toArray()
      cleanArray (readValue $(f), true for f in children), trim, empty
    else if field.is 'input[type="checkbox"]'
      val = field.prop 'checked'
      if trim && !arrayMember then (if val then 1 else 0) else val
    else if (split = field.data 'split')?
      cleanArray (field.val()?.split(split || ',') || []), trim, empty
    else
      val = field.val()
      if trim && !arrayMember && val.trim? then val?.trim() else val

  parseFields = ->
    fields.each (ignored, field) ->
      field = $ field
      value = readValue field
      keyParts = field.data('key').split '.'
      parentCfg = cfg
      if keyParts.length > 1
        parentCfg = parentCfg[k] for k in keyParts[0..keyParts.length - 2] when k && parentCfg?
      parentCfg[keyParts[keyParts.length - 1]] = value

  Settings =
    get: ->
      cfg
    init: ->
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
        fillField field, getValue field.data 'key'
      $('#save').click (e) ->
        e.preventDefault()
        Settings.persist()
    persist: ->
      parseFields()
      socket.emit 'modules.shortcutsAdminSettings',
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