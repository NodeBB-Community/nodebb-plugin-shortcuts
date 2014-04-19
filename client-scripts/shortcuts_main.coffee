(->
  getActiveComposer = ->
    for c in document.querySelectorAll '.composer'
      return c if $(c).css('visibility') == 'visible'
    null
  getActiveDialogs = ->
    dialogs = []
    $('.modal-dialog').each (i, d) -> dialogs.push d if $(d).height()
    dialogs
  blurFocus = ->
    $('*:focus').blur()

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
    el = $('#shortcuts_help_body')
    if el.length
      h = el.parent().height()
      el = el[0]
    else
      el = document.body
      h = window.innerHeight - $('.header').height()
    el.scrollTop += h * factor

  scrollYTo = (percentage) ->
    el = $('#shortcuts_help_body')
    if el.length
      h = percentage * ($('> div', el).height() - el.height())
      el = el[0]
    else
      el = document.body
      h = percentage * ($('body').height() - window.innerHeight)
    el.scrollTop = h

  shortcuts.addActions
    body:
      _title: "Basic actions"
      focus:
        description: "Blur focused element"
        cb: ->
          blurFocus()
      scroll_pageDown:
        description: "Scroll one page down"
        cb: ->
          scrollPage 1
      scroll_pageUp:
        description: "Scroll one page up"
        cb: ->
          scrollPage -1
      scroll_top:
        description: "Scroll to top"
        cb: ->
          scrollYTo 0
      scroll_bottom:
        description: "Scroll to bottom"
        cb: ->
          scrollYTo 1
    header:
      _title: "Navigation"
      home:
        description: "Go to home-site"
        cb: ->
          ajaxify.go ''
      unread:
        description: "Go to unread-site"
        cb: ->
          ajaxify.go 'unread'
      recent:
        description: "Go to recent-site"
        cb: ->
          ajaxify.go 'recent'
      popular:
        description: "Go to popular-site"
        cb: ->
          ajaxify.go 'popular'
      users:
        description: "Go to users-site"
        cb: ->
          ajaxify.go 'users'
      notifications:
        description: "Go to notifications-site"
        cb: ->
          ajaxify.go 'notifications'
      profile:
        description: "Go to profile-site"
        cb: ->
          ajaxify.go "user/#{app.username}"
      chats:
        description: "Open chat-popup"
        cb: ->
          $('#chat_dropdown').click()
    navPills:
      _title: "Sub-navigation (nav-pills)"
      next:
        description: "Select next pill"
        cb: ->
          nP = $ '>li', $('.nav-pills')[0]
          if nP.css('float') == 'right' then navPills.prev nP else navPills.next nP
      prev:
        description: "Select previous pill"
        cb: ->
          nP = $ '>li', $('.nav-pills')[0]
          if nP.css('float') == 'right' then navPills.next nP else navPills.prev nP
    breadcrumb:
      _title: "Navigate upwards (breadcrumb)"
      up:
        description: "Navigate upwards (topic -> category -> home)"
        cb: ->
          bc = $('.breadcrumb>li:nth-last-child(2)>a')[0]
          return false if !bc?
          bc.click()
    category:
      _title: "Actions within a Category"
      newTopic:
        description: "Create a new Topic"
        cb: ->
          btn = $('#new_post')[0]
          return false if !btn?
          btn.click()
    topic:
      _title: "Actions within a Topic"
      reply:
        description: "Create a new reply"
        cb: ->
          btn = $('.post_reply').last()[0]
          return false if !btn?
          btn.click()
      threadTools:
        description: "Open Thread Tools"
        cb: ->
          btn = $('.thread-tools>button')[0]
          return false if !btn?
          btn.click()
    composer:
      _title: "Writing a post"
      send:
        description: "Send post"
        cb: ->
          $('button[data-action="post"]', getActiveComposer())[0].click()
      discard:
        description: "Discard post"
        cb: ->
          $('button[data-action="discard"]', getActiveComposer())[0].click()
      closed_select:
        description: "Focus composer"
        cb: (ignored, e) ->
          c = getActiveComposer()
          if !c?
            $('.taskbar li[data-module="composer"]>a')[0]?.click()
            c = getActiveComposer()
          if !c?
            e.preventDefault()
            return false
          $('.write', c).focus()
          e.preventDefault()
      title:
        description: "Focus title-field"
        cb: (ignored, e) ->
          $('.title', getActiveComposer()).focus()
          e.preventDefault()
      preview:
        description: "Show preview-tab"
        cb: ->
          p = $ 'a[data-pane=".tab-preview"]', getActiveComposer()
          return false if p.parent().hasClass 'active'
          p[0].click()
      previewSend:
        description: "Show preview-tab or send post if already shown"
        cb: ->
          c = getActiveComposer()
          p = $ 'a[data-pane=".tab-preview"]', c
          if p.parent().hasClass 'active' then $('button[data-action="post"]', c)[0].click() else p[0].click()
      writeSend:
        description: "Show write-tab or send post if already shown"
        cb: ->
          c = getActiveComposer()
          w = $ 'a[data-pane=".tab-write"]', c
          if w.parent().hasClass 'active' then $('button[data-action="post"]', c)[0].click() else w[0].click()
      help:
        description: "Show help-tab"
        cb: ->
          h = $ 'a[data-pane=".tab-help"]', getActiveComposer()
          return false if h.parent().hasClass 'active'
          h[0].click()
      write:
        description: "Show write-tab"
        cb: ->
          c = getActiveComposer()
          w = $ 'a[data-pane=".tab-write"]', c
          if w.parent().hasClass 'active'
            $('.write', c).focus()
            return false
          w[0].click()
      bold:
        description: "Make selected text bold"
        cb: ->
          $('.formatting-bar .fa-bold', getActiveComposer())[0].click()
      italic:
        description: "Make selected text italic"
        cb: ->
          $('.formatting-bar .fa-italic', getActiveComposer())[0].click()
      list:
        description: "Make selected text a list-item"
        cb: ->
          $('.formatting-bar .fa-list', getActiveComposer())[0].click()
      link:
        description: "Make selected text a link-name"
        cb: ->
          $('.formatting-bar .fa-link', getActiveComposer())[0].click()
    dialog:
      _title: "Active dialog (bootbox)"
      confirm:
        description: "Confirm active dialog"
        cb: ->
          $('.modal-footer>button', d)[1]?.click() for d in getActiveDialogs()
      close:
        description: "Close active dialog"
        cb: ->
          $('.bootbox-close-button', d).click() for d in getActiveDialogs()
    taskbar:
      _title: "Using the taskbar"
      closeAll:
        description: "Close all tasks"
        cb: ->
          item.click() for item in $('.taskbar li.active>a').toArray()
      clickFirst:
        description: "Toggle first task"
        cb: ->
          $('.taskbar li>a')[0]?.click()
      clickLast:
        description: "Toggle last task"
        cb: ->
          $('.taskbar li>a').last()[0]?.click()
  # selection
#
)()