(->
  selection =
    items: $()
    index: -1
    classified: $()
    item: -> this.items[this.index] || null

  ajaxifyGo = ajaxify.go
  ajaxify.go = (args...) ->
    ajaxifyGo args...
    selection.items = $()
    selection.index = -1
    selection.classified = $()

  getAvailableAreas = ->
    areas = []
    items = []
    $('[data-cid]:visible,[data-tid]:visible,[data-pid]:visible,#recent_topics:visible').each (ignored, el) ->
      return if items.indexOf(el) >= 0
      el = $ el
      return if el.is '#post-container'
      area = if el.is '[data-pid]' then el.parent().children '[data-pid]'
      else if el.is '[data-tid]' then el.parent().children '[data-tid]'
      else if el.is '[data-cid]' then el.parent().children '[data-cid]'
      else if el.is '#recent_topics' then el.children 'li'
      area.each (ignored, elem) ->
        items.push elem
      areas.push area
    areas

  scrollIntoView = (item = selection.item()) ->
    if item?
      if item.scrollIntoViewIfNeeded? then item.scrollIntoViewIfNeeded() else item.scrollIntoView true
      maxTop = $(item).position().top - $('#header-menu').height() - 10
      document.body.scrollTop = maxTop if document.body.scrollTop > maxTop

  selectItem = (index) ->
    selection.classified.removeClass 'shortcut-selection'
    selection.index = index
    selection.classified = $ selection.item()
    if !selection.classified.height()
      for c in selection.classified.children().toArray()
        if $(c).height()
          selection.classified = $ c
          break
    selection.classified.addClass 'shortcut-selection'
    scrollIntoView()

  selectNextItem = (step = 1) ->
    return false if !selection.items.length
    i = selection.index + step
    if i >= selection.items.length
      i %= selection.items.length
    i += selection.items.length while i < 0
    selectItem i

  getTargetRoute = ->
    item = $ selection.item()
    return if item.is '[data-pid]'
      tid = item.closest('[data-tid]').data('tid') ||
        /\/topic\/(\d+)/.exec($('a[href^="/topic/"]', item).last().attr('href'))[1]
      'topic/' + tid + '/#' + item.data 'pid'
    else if item.is '[data-tid]'
      url = $('[itemprop="url"]', item).attr('href')
      if url then url.substring url.indexOf('/topic/') + 1 else 'topic/' + item.data('tid') + '/#'
    else if item.is '#recent_topics>li'
      $('a[href^="/topic/"]', item).last().attr('href').substring 1
    else if item.is '[data-cid]' then 'category/' + item.data 'cid'
    else null

  selectArea = (area) ->
    return false if !area?.length
    selection.classified.removeClass 'shortcut-selection'
    selection.items = area
    selectItem 0

  findNextArea = (areas) ->
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
        findNextArea getAvailableAreas()
      area_prev: ->
        findNextArea getAvailableAreas().reverse()

  shortcuts.prependToAction 'body_focus', ->
    selectItem -1
#
)()