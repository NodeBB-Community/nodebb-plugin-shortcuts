(->
  selection =
    areas: []
    items: $()
    index: -1
    classified: $()
    item: ->
      this.items[this.index] || null

  ajaxifyGo = ajaxify.go
  ajaxify.go = (args...) ->
    ajaxifyGo args...
    selection.areas = []
    selection.items = $()
    selection.index = -1
    selection.classified = $()

  itemSelectors =
    '[data-pid]': ->
      tid = this.closest('[data-tid]').data('tid') ||
        /\/topic\/(\d+)/.exec($('a[href^="/topic/"]', this).last().attr('href'))[1]
      'topic/' + tid + '/#' + this.data 'pid'
    '[data-tid]': ->
      url = $('[itemprop="url"]', this).attr 'href'
      if url then url.substring url.indexOf('/topic/') + 1 else 'topic/' + this.data('tid') + '/#'
    '#recent_topics>li': ->
      $('a[href^="/topic/"]', this).last().attr('href')?.substring 1
    '[data-cid]': ->
      'category/' + this.data 'cid'

  itemSelectorsJoined = ''
  for k, v of itemSelectors
    itemSelectors[k + ':visible'] = v
    delete itemSelectors[k]
    itemSelectorsJoined += k + ':visible,'
  itemSelectorsJoined = itemSelectorsJoined.substring 0, itemSelectorsJoined.length - 1

  getTargetRoute = ->
    item = $ selection.item()
    for sel, cb of itemSelectors
      return cb.call item if item.is sel
    null

  getAreaOfItem = (el) ->
    return $() if !el?
    for sel of itemSelectors
      return el.parent().children sel if el.is sel
    el

  refreshAreas = ->
    selection.areas = []
    items = []
    $(itemSelectorsJoined).each (ignored, el) ->
      return if items.indexOf(el) >= 0
      el = $ el
      return if el.is '#post-container'
      area = getAreaOfItem el
      area.each (ignored, elem) ->
        items.push elem
      selection.areas.push area
    selection.areas

  refreshItems = ->
    selection.items = getAreaOfItem $(selection.item() || selection.items[0])

  scrollIntoView = (item = selection.item()) ->
    if item?
      if item.scrollIntoViewIfNeeded? then item.scrollIntoViewIfNeeded() else item.scrollIntoView true
      maxTop = $(item).position().top - $('#header-menu').height() - 10
      document.body.scrollTop = maxTop if document.body.scrollTop > maxTop
      document.documentElement.scrollTop = maxTop if document.documentElement.scrollTop > maxTop

  selectItem = (index) ->
    selection.classified.removeClass 'shortcut-selection'
    selection.index = index
    selection.classified = $ selection.item()
    if !selection.classified.height() # no height => search children
      for c in selection.classified.children().toArray()
        if $(c).height()
          selection.classified = $ c
          break
    if selection.classified.hasClass 'category-item' # Theme Lavender
      icon = $ '.category-icon', selection.classified
      selection.classified = icon if icon.length
    selection.classified.addClass 'shortcut-selection'
    scrollIntoView()

  selectNextItem = (step = 1) ->
    return false if !selection.items.length
    refreshItems()
    k = selection.index + step
    if k >= selection.items.length
      k %= selection.items.length
    k += selection.items.length while k < 0
    selectItem k

  selectArea = (area) ->
    return false if !area?.length
    selection.classified.removeClass 'shortcut-selection'
    selection.items = area
    refreshItems()
    selectItem 0

  findNextArea = (areas = selection.areas) ->
    return false if !areas
    return selectArea areas[0] if !selection.items.length
    isNext = areas[areas.length - 1][0] == selection.items[0]
    for area in areas
      if isNext
        selectArea area
        return
      else
        isNext = area[0] == selection.items[0]
    false

  shortcuts.addActions
    selection:
      release: ->
        selectItem -1
      follow: ->
        item = selection.item()
        return false if !item?
        route = getTargetRoute()
        return false if !route?
        ajaxify.go route
      highlight: ->
        item = selection.item()
        return false if !item?
        scrollIntoView item
        item = selection.classified
        item.addClass 'highlight-in'
        setTimeout ->
          item.addClass 'highlight-out'
          item.removeClass 'highlight-in'
        , 500
        setTimeout ->
          item.removeClass 'highlight-out'
        , 700
      item_next: (s, e) ->
        return s.trigger 'selection_area_next', e if !selection.items.length
        selectNextItem 1
      item_prev: (s, e) ->
        s.trigger 'selection_area_next', e if !selection.items.length
        selectNextItem -1
      area_next: ->
        findNextArea refreshAreas()
      area_prev: ->
        findNextArea refreshAreas().reverse()

  shortcuts.prependToAction 'body_focus', ->
    selectItem -1
#
)()