(->
  _h = shortcuts.helper

  toggleFirstComposer = ->
    tb = $('.taskbar li[data-module="composer"]')
    id = 'cmp-uuid-' + tb.data 'uuid'
    $('> a', tb)[0]?.click()
    document.getElementById id

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
    el = _h.getActiveDialogs().parent()
    if el.length
      h = el.parent().height()
      el = el[0]
    else
      el = document.body
      h = window.innerHeight - $('.header').height()
      document.documentElement.scrollTop += h * factor
    el.scrollTop += h * factor

  scrollYTo = (percentage) ->
    el = _h.getActiveDialogs().parent()
    if el.length
      h = percentage * (el.children()[0].offsetHeight - el.height())
      el = el[0]
    else
      el = document.body
      h = percentage * (document.body.offsetHeight - window.innerHeight)
      document.documentElement.scrollTop = h
    el.scrollTop = h

  getFormElements = -> $('.form-control,input,.btn').not('button,[disabled]').filter ':visible'

  nextFormElement = (step = 1) ->
    formEl = getFormElements()
    return null if !formEl.length
    focusEl = formEl.filter(':focus')[0]
    i = if focusEl? then formEl.toArray().indexOf(focusEl) + step else if step > 0 then step - 1 else step
    i += formEl.length while i < 0
    i -= formEl.length while i >= formEl.length
    formEl.eq i

  shortcuts.addActions
    body:
      focus: ->
        $('.open>.dropdown-toggle').click()
        _h.blurFocus()
      scroll_pageDown: -> scrollPage 1
      scroll_pageUp: -> scrollPage -1
      scroll_top: -> scrollYTo 0
      scroll_bottom: -> scrollYTo 1
      reload_soft: -> ajaxify.refresh()
      reload_hard: -> location.href = /^([^#]*)(#[^\/]*)?$/.exec(location.href)[1]
      form_next: ->
        if (formEl = nextFormElement 1)?.length
          formEl.focus()
          _h.scrollIntoView formEl[0]
        else
          $('#search-button').click().length > 0
      form_prev: ->
        if (formEl = nextFormElement -1)?.length
          formEl.focus()
          _h.scrollIntoView formEl[0]
        else
          $('#search-button').click().length > 0

    header:
      home: -> ajaxify.go ''
      unread: -> ajaxify.go 'unread'
      recent: -> ajaxify.go 'recent'
      tags: -> ajaxify.go 'tags'
      popular: -> ajaxify.go 'popular'
      users: -> ajaxify.go 'users'
      notifications: -> ajaxify.go 'notifications'
      profile: -> ajaxify.go "user/#{app.username}"
      admin: ->
        if app.isAdmin
          location.pathname = RELATIVE_PATH + "/admin"
        else
          false
      search: -> $('#search-button').click().length > 0
      chats: -> $('#chat_dropdown').click()
    navPills:
      next: ->
        nP = $('>li', $('.nav-pills')[0]).not '.hide'
        if nP.css('float') == 'right' then navPills.prev nP else navPills.next nP
      prev: ->
        nP = $('>li', $('.nav-pills')[0]).not '.hide'
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
      send: -> $('button[data-action="post"]', _h.getActiveComposer())[0].click()
      discard: -> $('button[data-action="discard"]', _h.getActiveComposer())[0].click()
      closed_input: ->
        c = _h.getActiveComposer() || toggleFirstComposer()
        return false if !c?
        setTimeout (-> $('.write', c).focus()), 0
      closed_title: ->
        c = _h.getActiveComposer() || toggleFirstComposer()
        return false if !c?
        setTimeout (-> $('.title', c).focus()), 0
      preview: ->
        p = $ 'a[data-pane=".tab-preview"]', _h.getActiveComposer()
        return false if !p.length || p.parent().hasClass 'active'
        p[0].click()
      previewSend: ->
        c = _h.getActiveComposer()
        p = $ 'a[data-pane=".tab-preview"]', c
        if !p.length || p.parent().hasClass 'active' then $('button[data-action="post"]', c)[0].click() else p[0].click()
      writeSend: ->
        c = _h.getActiveComposer()
        w = $ 'a[data-pane=".tab-write"]', c
        if w.parent().hasClass 'active' then $('button[data-action="post"]', c)[0].click() else w[0].click()
      help: ->
        h = $ 'a[data-pane=".tab-help"]', _h.getActiveComposer()
        return false if h.parent().hasClass 'active'
        h[0].click()
      write: ->
        c = _h.getActiveComposer()
        w = $ 'a[data-pane=".tab-write"]', c
        if w.parent().hasClass 'active'
          $('.write', c).focus()
          return false
        w[0].click()
      bold: -> $('.formatting-bar .fa-bold', _h.getActiveComposer())[0].click()
      italic: -> $('.formatting-bar .fa-italic', _h.getActiveComposer())[0].click()
      list: -> $('.formatting-bar .fa-list', _h.getActiveComposer())[0].click()
      link: -> $('.formatting-bar .fa-link', _h.getActiveComposer())[0].click()
    dialog:
      confirm: -> _h.getActiveDialogs().each (ignored, d) -> $('.modal-footer>button', d)[1]?.click()
      close: -> _h.getActiveDialogs().each (ignored, d) -> $('.bootbox-close-button,.close', d).click()
    taskbar:
      closeAll: -> item.click() for item in $('.taskbar li.active>a').toArray()
      clickFirst: -> $('.taskbar li>a')[0]?.click()
      clickLast: -> $('.taskbar li>a').last()[0]?.click()
#
)()
