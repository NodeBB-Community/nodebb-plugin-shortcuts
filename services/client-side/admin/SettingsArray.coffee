define ->
  ###
    Example 2D-Array:
      <div data-key="my.config" data-split="<br>" data-attributes='{"data-type":"array", "data-attributes":{"type":"number"}}' data-new='["42","21",10.5]'></div>
    Used data:
      * split (def: ', '): Separator between
      * new (def: ''): value to insert when a new element should get added
      * attributes (def: {}): attributes for elements
          data-xyz: set data of elements
          tagName: tag-name of elements
  ###

  Settings = null
  helper = null

  createRemoveButton = (elements...) ->
    rm = $ helper.createElement 'button',
      class: 'btn btn-xs btn-primary remove'
      title: 'Remove Item'
    , '-'
    rm.click (e) ->
      e.preventDefault()
      el.remove() for el in elements
      rm.remove()

  addArrayChildElement = (field, key, attributes, value, sep, insertCb) ->
    type = attributes['data-type'] || attributes.type || 'text'
    tagName = attributes.tagName
    el = $(helper.createElementOfType type, tagName).attr 'data-parent', '_' + key
    for k, v of attributes when k != 'tagName'
      if k.search('data-') == 0 then el.data k.substring(5), v else el.attr k, v
    helper.fillField el, value
    try
      sep = $ sep
    catch
      sep = document.createTextNode sep
    insertCb sep if $("[data-parent=\"_#{key}\"]", field).length
    insertCb el
    insertCb createRemoveButton sep, el

  SettingsArray =
    types: ['array', 'div']
    use: (settings) ->
      helper = (Settings = settings).helper
    create: (type, tagName) ->
      helper.createElement tagName || 'div', 'data-type': type
    set: (element, ignored, value) ->
      key = element.data('key') || element.data 'parent'
      sep = element.data('split') || ', '
      newValue = element.data 'new'
      newValue = '' if !newValue?
      attributes = element.data 'attributes'
      attributes = {} if typeof attributes != 'object'
      addArrayChildElement element, key, attributes, val, sep, ((elem) -> element.append(elem)) for val in value || []
      addSpace = $ document.createTextNode ' '
      add = $ helper.createElement 'button',
        class: 'btn btn-sm btn-primary add'
        title: 'Expand Array'
      , '+'
      add.click (event) ->
        event.preventDefault()
        addArrayChildElement element, key, attributes, newValue, sep, ((elem) -> addSpace.before(elem))
      element.append addSpace
      element.append add
    get: (element, trim, empty) ->
      key = element.data('key') || element.data 'parent'
      children = $("[data-parent=\"_#{key}\"]", element).toArray()
      helper.cleanArray (helper.readValue $(f), true for f in children), trim, empty

  SettingsArray