(->
  toggleFirstComposer = ->
    tb = $('.taskbar li[data-module="composer"]')
    id = 'cmp-uuid-' + tb.data 'uuid'
    $('> a', tb)[0]?.click()
    document.getElementById id
  getActiveComposer = ->
    c = $('.composer')
    for comp in c.toArray()
      return comp if $(comp).css('visibility') != 'hidden'
    null
  getActiveDialogs = -> $('.modal-dialog').filter(':visible')
  blurFocus = -> $('*:focus').blur()

  navPills =
    next: (nP) ->
      isNext = nP.last().hasClass 'active'
      for pill in nP.toArray()
        $('>a', pill)[0].click() if isNext
        isNext = $(pill).hasClass 'active'
    prev: (nP) ->
      isNext = nP.first().hasClass 'active'
      for pill in nP.toArray().reverse()
        $('>a', pill)[0].click() if isNext
        isNext = $(pill).hasClass 'active'

  scrollPage = (factor) ->
    el = getActiveDialogs().parent()
    if el.length
      h = el.parent().height()
      el = el[0]
    else
      el = document.body
      h = window.innerHeight - $('.header').height()
      document.documentElement.scrollTop += h * factor
    el.scrollTop += h * factor

  scrollYTo = (percentage) ->
    el = getActiveDialogs().parent()
    if el.length
      h = percentage * (el.children()[0].offsetHeight - el.height())
      el = el[0]
    else
      el = document.body
      h = percentage * (document.body.offsetHeight - window.innerHeight)
      document.documentElement.scrollTop = h
    el.scrollTop = h

  shortcuts.addActions
    body:
      focus: -> blurFocus()
      scroll_pageDown: -> scrollPage 1
      scroll_pageUp: -> scrollPage -1
      scroll_top: -> scrollYTo 0
      scroll_bottom: -> scrollYTo 1
    header:
      home: -> ajaxify.go ''
      unread: -> ajaxify.go 'unread'
      recent: -> ajaxify.go 'recent'
      popular: -> ajaxify.go 'popular'
      users: -> ajaxify.go 'users'
      notifications: -> ajaxify.go 'notifications'
      profile: -> ajaxify.go "user/#{app.username}"
      chats: -> $('#chat_dropdown').click()
    navPills:
      next: ->
        nP = $ '>li', $('.nav-pills')[0]
        if nP.css('float') == 'right' then navPills.prev nP else navPills.next nP
      prev: ->
        nP = $ '>li', $('.nav-pills')[0]
        if nP.css('float') == 'right' then navPills.next nP else navPills.prev nP
    breadcrumb:
      up: ->
        bc = $('> a', $('.breadcrumb li.active').prev())[0]
        return false if !bc?
        bc.click()
    category:
      newTopic: ->
        btn = $('#new_post')[0]
        return false if !btn?
        btn.click()
    topic:
      reply: ->
        btn = $('.shortcut-selection .btn.quote')[0] || $('.post_reply').last()[0]
        return false if !btn?
        btn.click()
      threadTools: ->
        btn = $('.thread-tools>button')[0]
        return false if !btn?
        btn.click()
    composer:
      send: -> $('button[data-action="post"]', getActiveComposer())[0].click()
      discard: -> $('button[data-action="discard"]', getActiveComposer())[0].click()
      closed_input: ->
        c = getActiveComposer() || toggleFirstComposer()
        return false if !c?
        setTimeout (-> $('.write', c).focus()), 0
      closed_title: ->
        c = getActiveComposer() || toggleFirstComposer()
        return false if !c?
        setTimeout (-> $('.title', c).focus()), 0
      preview: ->
        p = $ 'a[data-pane=".tab-preview"]', getActiveComposer()
        return false if p.parent().hasClass 'active'
        p[0].click()
      previewSend: ->
        c = getActiveComposer()
        p = $ 'a[data-pane=".tab-preview"]', c
        if p.parent().hasClass 'active' then $('button[data-action="post"]', c)[0].click() else p[0].click()
      writeSend: ->
        c = getActiveComposer()
        w = $ 'a[data-pane=".tab-write"]', c
        if w.parent().hasClass 'active' then $('button[data-action="post"]', c)[0].click() else w[0].click()
      help: ->
        h = $ 'a[data-pane=".tab-help"]', getActiveComposer()
        return false if h.parent().hasClass 'active'
        h[0].click()
      write: ->
        c = getActiveComposer()
        w = $ 'a[data-pane=".tab-write"]', c
        if w.parent().hasClass 'active'
          $('.write', c).focus()
          return false
        w[0].click()
      bold: -> $('.formatting-bar .fa-bold', getActiveComposer())[0].click()
      italic: -> $('.formatting-bar .fa-italic', getActiveComposer())[0].click()
      list: -> $('.formatting-bar .fa-list', getActiveComposer())[0].click()
      link: -> $('.formatting-bar .fa-link', getActiveComposer())[0].click()
    dialog:
      confirm: -> getActiveDialogs().each (ignored, d) -> $('.modal-footer>button', d)[1]?.click()
      close: -> getActiveDialogs().each (ignored, d) -> $('.bootbox-close-button', d).click()
    taskbar:
      closeAll: -> item.click() for item in $('.taskbar li.active>a').toArray()
      clickFirst: -> $('.taskbar li>a')[0]?.click()
      clickLast: -> $('.taskbar li>a').last()[0]?.click()
#
)()