reset = false
repairConfig = false
debug = false

configPrefix = "shortcuts:"

pluginId = 'nodebb-plugin-shortcuts'

defaultConfig =
  version: '0.0.1-4'
  select_chars: 'werasdfguiohjklnm'
  actions:
    dialog:
      confirm: ['89', '79', '90'] # y, o, z
      close: ['78', '67', '27'] # n, c, Esc
    composer:
      send: ['A-83'] # A-s
      discard: ['A-68', 'S-27'] # A-d, S-Esc
      title: ['A-S-84'] # A-S-t
      preview: ['A-80'] # A-p
      previewSend: ['C-13'] # C-Enter
      writeSend: ['C-S-13'] # C-S-Enter
      help: ['A-72'] # A-h
      write: ['A-87'] # A-w
      bold: ['A-66'] # A-b
      italic: ['A-73'] # A-i
      list: ['A-76'] # A-l
      link: ['A-85'] # A-u
      closed:
        select: ['73', 'C-73', 'A-S-73'] # i, C-i, A-S-i
    taskbar:
      closeAll: ['A-67', 'A-88'] # A-c, A-x
      clickFirst: ['A-86'] # A-v
      clickLast: ['A-S-86'] # A-S-v
    breadcrumb:
      up: ['A-38'] # A-Up
    topic:
      reply: ['A-89', 'A-S-78', 'A-13'] # A-y, A-S-n, A-Enter
      threadTools: ['A-84'] # A-t
    category:
      newTopic: ['A-89', 'A-S-78', 'A-13'] # A-y, A-S-n, A-Enter
#    selection:
#      follow: ['13', '32'] # Enter, Space
#      highlight: ['S-72'] # h
#      area:
#        next: ['S-74'] # S-j
#        prev: ['S-75'] # S-k
#      item:
#        next: ['74'] # j
#        prev: ['75'] # k
    navPills:
      next: ['76'] # l
      prev: ['72'] # h
    header:
      home: ['A-72', 'A-S-72'] # A-h, A-S-h
      unread: ['A-85', 'A-S-85'] # A-u, A-S-u
      recent: ['A-82', 'A-S-82'] # A-r, A-S-r
      popular: ['A-80', 'A-S-80'] # A-p, A-S-p
      users: ['A-83', 'A-S-83'] # A-s, A-S-s
      notifications: ['A-78', 'A-S-78'] # A-n, A-S-n
      chats: ['A-67', 'A-S-67'] # A-c, A-S-c
      profile: ['A-79', 'A-S-79'] # A-o, A-S-o
    body:
      focus: ['S-221', '27'] # S-], Esc
      scroll:
        pageDown: ['68'] # d
        pageUp: ['85'] # u
        top: ['84'] # t
        bottom: ['66'] # b

stringify = (val) ->
  if val instanceof Object then JSON.stringify(val) else val

parse = (val, defVal) ->
  type = typeof defVal
  switch type
    when 'boolean' then val && val != 'false'
    when 'object'
      try
        val = JSON.parse val
      val
    else
      val

getConfig = (key = null, def = null) ->
  if !key
    obj = {}
    obj[k] = getConfig k, v for k, v of defaultConfig
    return obj
  if !def?
    def = defaultConfig[key]
  val = meta.config[configPrefix + key]
  if val then parse val, def else def

setConfig = (key, val) ->
  meta.configs.set configPrefix + key, stringify(val), ->

module.exports.configDefaults = (id) ->
  if id == pluginId
    meta.configs.setOnEmpty configPrefix + key, stringify(val), (->) for key, val of defaultConfig

if reset
  meta.configs.list (ignored, obj) ->
    meta.configs.remove key for key of obj when key.search(configPrefix) == 0
    setConfig key, val for key, val of defaultConfig
    if debug
      setTimeout ->
        console.log getConfig()
      , 100
else if repairConfig || getConfig('version', '0.0.0') != defaultConfig.version
  console.log 'config gets repaired...' if debug
  meta.configs.list (ignored, obj) ->
    conf = getConfig()
    merge = (obj1, obj2) ->
      for key, val2 of obj2
        val1 = obj1[key]
        if !obj1.hasOwnProperty(key)
          obj1[key] = val2
        else if typeof val2 == 'object'
          if typeof val1 == 'object'
            merge val1, val2
          else
            obj1[key] = val2
    merge conf, defaultConfig
    conf.version = defaultConfig.version
    meta.configs.remove key for key of obj when key.search(configPrefix) == 0
    setConfig key, conf[key] for key of defaultConfig
    if debug
      setTimeout ->
        console.log getConfig()
      , 100
else if debug
  console.log getConfig()

#appGet = (app, url, mw, cb) ->
#  app.get url, mw, cb
#  app.get "/api#{url}", cb
