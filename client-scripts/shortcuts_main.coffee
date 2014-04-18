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

  shortcuts.addActions
  # dialog
    dialog_confirm: ->
      $('.modal-footer>button', d)[1]?.click() for d in getActiveDialogs()
    dialog_cancel: ->
      $('.bootbox-close-button', d).click() for d in getActiveDialogs()
  # composer
    composer_send: ->
      $('button[data-action="post"]', getActiveComposer())[0].click()
    composer_discard: ->
      $('button[data-action="discard"]', getActiveComposer())[0].click()
    composer_closed_select: (ignored, e) ->
      c = getActiveComposer()
      if !c?
        $('.taskbar li[data-module="composer"]>a')[0]?.click()
        c = getActiveComposer()
      if !c?
        e.preventDefault()
        return false
      $('.write', c).focus()
      e.preventDefault()
    composer_title: (ignored, e) ->
      $('.title', getActiveComposer()).focus()
      e.preventDefault()
    composer_preview: ->
      p = $ 'a[data-pane=".tab-preview"]', getActiveComposer()
      return false if p.parent().hasClass 'active'
      p[0].click()
    composer_previewSend: ->
      c = getActiveComposer()
      p = $ 'a[data-pane=".tab-preview"]', c
      if p.parent().hasClass 'active' then $('button[data-action="post"]', c)[0].click() else p[0].click()
    composer_writeSend: ->
      c = getActiveComposer()
      w = $ 'a[data-pane=".tab-write"]', c
      if w.parent().hasClass 'active' then $('button[data-action="post"]', c)[0].click() else w[0].click()
    composer_help: ->
      h = $ 'a[data-pane=".tab-help"]', getActiveComposer()
      return false if h.parent().hasClass 'active'
      h[0].click()
    composer_write: ->
      c = getActiveComposer()
      w = $ 'a[data-pane=".tab-write"]', c
      if w.parent().hasClass 'active'
        $('.write', c).focus()
        return false
      w[0].click()
    composer_bold: ->
      $('.formatting-bar .fa-bold', getActiveComposer())[0].click()
    composer_italic: ->
      $('.formatting-bar .fa-italic', getActiveComposer())[0].click()
    composer_list: ->
      $('.formatting-bar .fa-list', getActiveComposer())[0].click()
    composer_link: ->
      $('.formatting-bar .fa-link', getActiveComposer())[0].click()
  # taskbar
    taskbar_closeAll: ->
      item.click() for item in $('.taskbar li.active>a').toArray()
    taskbar_clickFirst: ->
      $('.taskbar li>a')[0]?.click()
    taskbar_clickLast: ->
      $('.taskbar li>a').last()[0]?.click()
  # breadcrumb
    breadcrumb_up: ->
      bc = $('.breadcrumb>li:nth-last-child(2)>a')[0]
      return false if !bc?
      bc.click()
  # topic
    topic_reply: ->
      btn = $('.post_reply').last()[0]
      return false if !btn?
      btn.click()
    topic_threadTools: ->
      btn = $('.thread-tools>button')[0]
      return false if !btn?
      btn.click()
  # category
    category_newTopic: ->
      btn = $('#new_post')[0]
      return false if !btn?
      btn.click()
  # selection
  # navPills
    navPills_next: ->
      nP = $ '>li', $('.nav-pills')[0]
      if nP.css('float') == 'right' then navPills.prev nP else navPills.next nP
    navPills_prev: ->
      nP = $ '>li', $('.nav-pills')[0]
      if nP.css('float') == 'right' then navPills.next nP else navPills.prev nP
  # header
    header_home: ->
      ajaxify.go ''
    header_unread: ->
      ajaxify.go 'unread'
    header_recent: ->
      ajaxify.go 'recent'
    header_popular: ->
      ajaxify.go 'popular'
    header_users: ->
      ajaxify.go 'users'
    header_notifications: ->
      ajaxify.go 'notifications'
    header_chats: ->
      $('#chat_dropdown').click()
    header_profile: ->
      ajaxify.go "user/#{app.username}"
  # body
    body_focus: ->
      blurFocus()
    body_scroll_pageDown: ->
      document.body.scrollTop += window.innerHeight - $('.header').height()
    body_scroll_pageUp: ->
      document.body.scrollTop -= window.innerHeight - $('.header').height()
    body_scroll_top: ->
      document.body.scrollTop = 0
    body_scroll_bottom: ->
      document.body.scrollTop = document.body.offsetHeight
#
)()