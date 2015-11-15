"use strict";

define("@{type.name}/@{id}/Core", [
  "@{type.name}/@{id}/debug",
  "@{type.name}/@{id}",
  "@{type.name}/@{id}/input-fields",
  "@{type.name}/@{id}/KeyAction",
  "@{type.name}/@{id}/theme"
], function (debug, module, inputFields, KeyAction, theme) {

  /*=================================================== Core Class ===================================================*/

  /*-------------------------------------------------- constructor  --------------------------------------------------*/

  function Shortcuts(cfg) {
    this.bindings = [];
    this.actions = {};
    this.repeatDelay = cfg.repeatDelay || 200;
    this.lastTriggered = {keyAction: null, time: 0};
    this.parseBindings(cfg.actions);
  }

  /*-------------------------------------------- bindings initialization  --------------------------------------------*/

  Shortcuts.prototype.addKeyAction = function (keyAction) {
    debug.log("addKeyAction", keyAction);
    this.bindings.push(keyAction);
    if (this.actions.hasOwnProperty(keyAction.action)) { this.actions[keyAction.action].bindings.push(keyAction); }
  };

  Shortcuts.prototype.parseBindings = function (actions, key) {
    if (!key) { key = ""; }
    var i, keyName, fullName, name;
    // clean up current bindings
    for (i = 0; i < this.actions.length; i++) {
      this.actions[i].bindings = [];
    }
    for (name in actions) {
      if (actions.hasOwnProperty(name)) {
        keyName = actions[name];
        // concatenate full name
        fullName = key.length ? key + "." + name : name;
        // process value
        if (keyName instanceof Array) {
          for (i = 0; i < keyName.length; i++) {
            this.addKeyAction(new KeyAction(keyName[i], fullName));
          }
        } else if (typeof keyName === "object") {
          this.parseBindings(keyName, fullName);
        } else {
          this.addKeyAction(new KeyAction(keyName, fullName));
        }
      }
    }
  };

  /*----------------------------------------------- action management  -----------------------------------------------*/

  Shortcuts.prototype.wrapAction = function (actionName, cb) {
    if (this.actions.hasOwnProperty(actionName)) {
      this.actions[actionName].cb = cb(this.actions[actionName].cb);
    } else {
      this.addAction(actionName, cb($.noop));
    }
  };

  Shortcuts.prototype.addAction = function (name, cb) {
    debug.log("addAction", name);
    var bindings = [];
    for (var i = 0; i < this.bindings.length; i++) {
      if (this.bindings[i].action === name) { bindings.push(this.bindings[i]); }
    }
    this.actions[name] = {cb: cb, bindings: bindings};
  };

  Shortcuts.prototype.addActions = function (actions, key) {
    if (key == null) { key = ""; }
    var value, currentKey;
    for (var name in actions) {
      if (actions.hasOwnProperty(name)) {
        value = actions[name];
        currentKey = key.length ? key + "." + name : name;
        if (typeof value === "object") {
          this.addActions(value, currentKey);
        } else if (typeof value === "function") {
          this.addAction(currentKey, value);
        }
      }
    }
  };

  Shortcuts.prototype.prependToAction = function (actionName, callback) {
    this.wrapAction(actionName, function (cb) {
      return function () {
        var result = callback.apply(null, arguments);
        if (result === false) { return false; }
        return cb.apply(null, arguments);
      };
    });
  };

  //noinspection JSUnusedGlobalSymbols
  Shortcuts.prototype.appendToAction = function (actionName, callback, force) {
    this.wrapAction(actionName, function (cb) {
      return function () {
        var result = cb.apply(null, arguments);
        if (result === false && !force) { return false; }
        return callback.apply(null, arguments);
      };
    });
  };

  /*------------------------------------------------- event handling -------------------------------------------------*/

  Shortcuts.prototype.released = function () { this.lastTriggered.time = 0; };

  Shortcuts.prototype.handleEvent = function (evt, key) {
    var isInput = !!~inputFields.indexOf(evt.target.tagName);
    var matchingList = [];
    var self = this;
    theme.done(function (theme) {
      var actionScopes = theme.scopes.getCurrent();
      var i, j;
      debug.log("Scopes matching event-target", actionScopes);

      // collect all matching keyActions
      var keyAction;
      for (i = 0; i < self.bindings.length; i++) {
        keyAction = self.bindings[i];
        if (keyAction.matches(evt, key, isInput)) {
          for (j = 0; j < actionScopes.length; j++) {
            if (keyAction.action.search(actionScopes[j] + ".") === 0) {
              matchingList.push({keyAction: keyAction, priority: j});
              break;
            }
          }
        }
      }

      if (matchingList.length) {
        // sort matching keyActions by priority (by scope they apply to)
        matchingList.sort(function (el1, el2) { return el1.priority - el2.priority; });
        // log actions to be triggered if debugging is enabled
        if (debug.enabled) {
          var actions = $.map(matchingList, function (el) { return el.keyAction.action; });
          debug._log("[" + actions.join(", ") + "] match the event.");
        }
        var now = $.now();
        // trigger actions
        for (i = 0; i < matchingList.length; i++) {
          keyAction = matchingList[i].keyAction;
          // if it's the same action that got triggered recently, delay it's re-trigger
          if (keyAction === self.lastTriggered.keyAction && now - self.lastTriggered.time <= self.repeatDelay) {
            break;
          }
          if (self.trigger(keyAction.action, evt) !== false) {
            self.lastTriggered.keyAction = keyAction;
            self.lastTriggered.time = now;
            return;
          }
        }
      }

      debug.log("No action got triggered");
    });
  };

  Shortcuts.prototype.trigger = function (actionName, evt) {
    if (this.actions.hasOwnProperty(actionName)) {
      var action = this.actions[actionName], result;
      if (action != null && typeof action.cb === "function") {
        // action has callback, so call it
        result = action.cb.call(evt && evt.target, this, evt);
        if (result !== false) {
          // stop event propagation
          if (evt != null) {
            evt.preventDefault();
            evt.stopPropagation();
          }
        }
        debug.log("action got triggered", actionName, result);
        return result;
      }
    }
    return false;
  };

  /*-------------------------------------------------- help dialog  --------------------------------------------------*/

  Shortcuts.prototype.help = function () {
    // TODO i18n
    var id = "@{id}-help-body";
    if ($("#" + id).length) {
      theme.done(function (theme) { theme.dialogs.getOpened().each(function (i, el) { theme.dialogs.close(el); }); });
      return;
    }
    var msg = "<div id=\"" + id + "\">";
    // add standard messages
    //msg += this.getHelpMessageItems(this.helpMessages);
    // show additional messages for admins
    //if (app.user.isAdmin) {
    //  msg += "<h3>Admin Actions</h3>";
    //  msg += this.getHelpMessageItems(this.helpMessages._admin);
    //}
    msg += "</div>";
    // open dialog
    bootbox.dialog({title: "NodeBB @{nbbpm.name} <small>" + module.version + "</small>", message: msg});
    // focus the dialog body to enable scrolling
    return setTimeout(function () { $("#" + id + ">div").focus(); }, 100);
  };

  Shortcuts.prototype.getHelpMessageItems = function (descriptions) {
    var msg = "", current, key, bindings;
    for (var scope in descriptions) {
      if (descriptions.hasOwnProperty(scope) && scope[0] !== "_") { // skip keys starting with "_"
        current = descriptions[scope];
        msg += "<h4>" + current._title + "</h4><ul>";
        for (var name in current) {
          if (current.hasOwnProperty(name) && name !== "_title") {
            key = scope + "_" + name;
            bindings = this.actions.hasOwnProperty(key) && this.actions[key].bindings;
            if (bindings && bindings.length) {
              msg = msg +
                  "<li class=\"clearfix\">" +
                  "<div class=\"description\">" + current[name] + "</div>" +
                  "<div class=\"keys\">" +
                  $.map(bindings, function (keyAction) { return keyAction.keyString; }).join(" | ") +
                  "</div>" +
                  "</li>";
            }
          }
        }
        msg += "</ul>";
      }
    }
    return msg;
  };

  /*===================================================== Export =====================================================*/

  return Shortcuts;
});
