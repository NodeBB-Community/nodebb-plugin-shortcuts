(->
  _h = shortcuts.helper
  _sel = _h.selection

  #================================================= Area Definitions =================================================#

  ###*
    A class to identify a Selection-Area within DOM.
  ###
  class Area
    hooks: {}
    items: null
    parent: null
    index: 0
    constructor: (parent = $()) ->
      this.parent = parent
    refreshItems: (hooks = this.hooks) ->
      this.hooks = hooks
      this.items = $ hooks.selector, this.parent
      this.items = this.parent.children hooks.selector if !this.items.length
    item: (index = this.index) -> this.items.eq index

  ###*
    List of Selection-Area types.
    An element has to provide a selector to identify all items of the area.
    Every element may provide the following attributes:
      ; follow - item-scopes. An array of action-callbacks, sorted by grade.
      ; getArea() - item-scope. Returns false if area is invalid or an Area-Object that knows the parent of all items.
      ; focus.area(oldArea) - area-scope. Gets called when the area got selected.
      ; focus.item() - item-scope. Gets called when any item gets selected.
      ; blur.area(newArea) - area-scope. Gets called when another area got selected.
      ; getClassElement(item) - proposal elements scope. Returns the element to display box-shadow around.
  ###
  itemHooks =
    posts:
      selector: '[data-pid]'
      follow: [
        ->
          tid = this.closest('[data-tid]').data('tid') ||
            /\/topic\/(\d+)/.exec($('a[href^="/topic/"]', this).last().attr('href'))[1]
          ajaxify.go (/^topic\/([^\/]+\/){2}/.exec(ajaxify.currentPage)?[0] || "topic/#{tid}/x/") + (1 + this.data 'index')
      ]
    topics:
      selector: '[data-tid]'
      getArea: -> if this.is '#post-container' then false else new Area this.parent()
      follow: [
        ->
          url = $('[itemprop="url"]', this).attr 'href'
          ajaxify.go if url then url.substring url.indexOf('/topic/') + 1 else 'topic/' + this.data('tid')
      ]
    recent_topics:
      selector: '#recent_topics>li'
      follow: [-> ajaxify.go $('a[href^="/topic/"]', this).last().attr('href')?.substring 1]
    categories:
      selector: '[data-cid]'
      getClassElement: ->
        if this.hasClass 'category-item' # Theme Lavender
          icon = $ '.category-icon', this
          return icon if icon.length
        this
      follow: [-> ajaxify.go 'category/' + this.data 'cid']
    notifications:
      selector: '[data-nid]'
      follow: [-> this.click()]
    users:
      selector: '.users-container>li'
      follow: [-> ajaxify.go $('a[href^="/user/"]', this).attr('href')?.substring 1]
    tags:
      selector: 'div > a[href*="/tags/"]'
      getClassElement: ->
        label = $ '.label', this
        if label.length then label else this
      follow: [-> this[0]?.click()]
    dropDowns:
      selector: '[data-toggle="dropdown"]:not([disabled])'
      getArea: ->
        return false if this.parent().is '#header-menu *'
        area = new Area this.parent()
        area.refreshItems
          selector: '>ul>li:not(.divider)'
          focus: itemHooks.dropDowns.focus
          blur: itemHooks.dropDowns.blur
          follow: itemHooks.dropDowns.follow
        area
      focus:
        area: ->
          $('[data-toggle="dropdown"]:not([disabled])', this.parent).click() if !this.parent.hasClass 'open'
          setTimeout (-> _h.blurFocus()), 50
        item: ->
          grandpa = this.parent().parent()
          $('[data-toggle="dropdown"]:not([disabled])', grandpa).click() if !grandpa.hasClass 'open'
          setTimeout (-> _h.blurFocus()), 50
      blur:
        area: ->
          $('[data-toggle="dropdown"]:not([disabled])', this.parent).click() if this.parent.hasClass 'open'
      follow: [-> $('>*', this).focus().click()]

  itemSelectorsJoined = ''
  itemSelectorsJoined += (value.selector += ':visible') + ',' for ignored, value of itemHooks
  itemSelectorsJoined = itemSelectorsJoined.substring 0, itemSelectorsJoined.length - 1

  ###*
    Triggers the action of given grade and selected item.
    @param index The grade of the action to trigger.
  ###
  triggerAction = (index) ->
    follow = _sel.active.area?.hooks?.follow?[index]
    if follow? then follow.call _sel.active.item else false

  #================================================= Item Management  =================================================#

  ###*
    Selects the item of given index within given Area (defaults to active Area).
    @param index The index of the item to select.
    @param areaIndex The index of the Area to select (defaults to active Area).
    @returns Boolean Whether anything changed.
  ###
  selectItem = (index, areaIndex = _sel.index) ->
    area = _sel.areas[areaIndex]
    item = area?.item index
    return false if !item? || areaIndex == _sel.index && index == areaIndex.index
    toClassify = item
    if !toClassify.height() # no height => search children
      for c in toClassify.children().toArray()
        c = $ c
        if c.height()
          toClassify = c
          break
    toClassify = area.hooks.getClassElement.call toClassify, item if area.hooks.getClassElement?
    _sel.select areaIndex, index, toClassify
    area.hooks.focus?.item?.call item
    true

  ###*
    Selects the item that gets found the given amount of items behind the active one.
    @param step The amount of items to go ahead (may be negative too).
    @returns Boolean Whether anything changed.
  ###
  selectNextItem = (step = 1) ->
    area = _sel.active.area
    return false if !area?
    area.refreshItems()
    index = area.index + step
    length = area.items.length
    index += length while index < 0
    index -= length while index >= length
    selectItem index

  #================================================= Area Management  =================================================#

  ###*
    Generates a new array of all available Selection-Areas.
    @returns The Array of all available Areas.
  ###
  refreshAreas = ->
    areas = []
    items = []
    $(itemSelectorsJoined).each (ignored, item) ->
      return if items.indexOf(item) >= 0
      item = $ item
      area = null
      for ignored, value of itemHooks
        if item.is value.selector
          area = value.getArea?.call item
          return if area == false
          area = new Area item.parent() if !area?
          area.refreshItems value if !area.items?
          break
      area.items.each (ignored, elem) -> items.push elem
      areas.push area
    areas

  ###*
    Selects the Area at given index within {@link selection.helper.areas}.
    @param index The index of the Area to select.
    @returns Boolean Whether anything changed.
  ###
  selectArea = (index) ->
    area = _sel.areas[index]
    oldArea = _sel.active.area
    # FIXME scroll doesn't work correct if change to dropdown-area with index > 0 selected because hooks.focus.area() after scroll
    return false if !area?.items?.length || index == _sel.index || selectItem(area.index, index) == false
    oldArea?.hooks?.blur?.area?.call oldArea, area
    area.hooks.focus?.area?.call area, oldArea
    true

  ###*
    Selects the Area that gets found the given amount of Areas behind the active one.
    @param step The amount of Areas to go ahead (may be negative too).
    @returns Boolean Whether anything changed.
  ###
  selectNextArea = (step = 1) ->
    return false if !_sel.areas.length
    index = if _sel.index < 0 then step else _sel.index + step
    length = _sel.areas.length
    index += length while index < 0
    index -= length while index >= length
    selectArea index

  #================================================== Initialization ==================================================#

  shortcuts.addActions
    selection:
      release: -> _sel.deselect()
      follow: -> triggerAction 0
      highlight: -> _sel.highlight()
      item_next: ->
        return selectNextArea 0 if !_sel.active.area?
        selectNextItem 1
      item_prev: ->
        selectNextArea 0 if !_sel.active.area?
        selectNextItem -1
      area_next: -> selectNextArea 1
      area_prev: -> selectNextArea -1

  shortcuts.prependToAction 'body_focus', -> _sel.deselect()

  $(document).ready ->
    _ag = ajaxify.go
    ajaxify.go = (url, callback, quiet) ->
      _ag url, ->
        _sel.reset refreshAreas()
        callback() if typeof callback == 'function'
      , quiet

    _sel.areas = refreshAreas()
#
)()