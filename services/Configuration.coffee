meta = module.parent.parent.require '../src/meta'

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

merge = (obj1, obj2) ->
  for key, val2 of obj2
    val1 = obj1[key]
    if !obj1.hasOwnProperty key
      obj1[key] = val2
    else if typeof val2 != typeof val1
      obj1[key] = val2
    else if typeof val2 == 'object'
      merge val1, val2
  obj1

trim = (obj1, obj2) ->
  for key, val1 of obj1
    if !obj2.hasOwnProperty key
      delete obj1[key]
    else if typeof val1 == 'object'
      trim val1, obj2[key]
  obj1

mergeSettings = (cfg, defCfg) ->
  if typeof cfg.settings != typeof defCfg || typeof defCfg != 'object'
    cfg.settings = defCfg
  else
    merge cfg.settings, defCfg
    trim cfg.settings, defCfg

class Configuration
  id: ''
  defCfg: {}
  cfg: {}
  version: '0.0.0'
  debug: false
  constructor: (data, defCfg, debug = false, forceUpdate = false, reset = false) ->
    this.id = data.name
    this.version = data.version || this.version
    this.defCfg = defCfg
    this.debug = debug
    if reset
      this.reset()
    else
      this.sync()
      this.checkStructure forceUpdate
  _log: (args...) ->
    console.log "Configuration (#{this.id}):", args... if this.debug
  _list: (cb) ->
    _this = this
    meta.configs.list (args...) ->
      cb.apply _this, args
  dbg: (delay = 0) ->
    return if !this.debug
    if delay
      _this = this
      setTimeout ->
        this._log _this.get()
      , delay
    else
      this._log this.get()
  sync: ->
    (this.cfg = JSON.parse(meta.config["settings:#{this.id}"] || "{}")).settings
  persist: (cb) ->
    _this = this
    meta.configs.set "settings:#{this.id}", JSON.stringify(this.cfg), (args...) ->
      cb.apply _this, args
  persistOnEmpty: (cb) ->
    _this = this
    meta.configs.setOnEmpty "settings:#{this.id}", JSON.stringify(this.cfg), (args...) ->
      cb.apply _this, args
  get: (key = '', def = null) ->
    obj = this.cfg.settings
    parts = key.split '.'
    obj = obj[k] for k in parts when k && obj?
    if !obj?
      if !def
        def = this.defCfg
        def = def[k] for k in parts when k && def?
      return def
    obj
  set: (key, val) ->
    this.cfg.version = this.version
    if !val? || !key
      this.cfg.settings = val || key
    else
      obj = this.cfg.settings
      parts = key.split '.'
      for k in parts[0..parts.length - 2] when k
        obj[k] = {} if !obj.hasOwnProperty k
        obj = obj[k]
      obj[parts[parts.length - 1]] = val
  reset: ->
    this._log 'Reset initiated.'
    this.cleanUp ->
      this.set this.defCfg
      this.persist ->
        this.dbg()
  cleanUp: (cb) ->
    this._list (ignored, obj) ->
      regexp = new RegExp "(^|:)#{this.id}(:|$)"
      meta.configs.remove key for key of obj when regexp.test key # TODO why isn't there a callback param for remove?
      cb.call this
  checkStructure: (force) ->
    if !force && this.cfg.version == this.version
      this.dbg()
    else
      this._log 'Structure-update initiated.'
      this._list ->
        mergeSettings this.cfg, this.defCfg
        this.cfg.version = this.version
        this.persist ->
          this.dbg()

module.exports = Configuration