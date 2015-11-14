"use strict";

define("@{type.name}/@{id}/KeyAction", ["@{type.name}/@{id}/key-codes"], function (keyCodes) {
  function convertKeyCodeToChar(code) {
    if (code >= 48 && code <= 90) {
      return String.fromCharCode(code).toUpperCase();
    } else if (code >= 112 && code <= 123) {
      return "F" + (code - 111);
    } else {
      return keyCodes.inverted[code] || ("#" + code);
    }
  }

  /**
   * @param keyName The short identifier of the key (formatted like "C+M+40").
   * @param actionName The name of the action to bind this instance to.
   * @constructor
   */
  function KeyAction(keyName, actionName) {
    var parts = keyName.split("+");
    var current;

    // interpret modifiers modifiers
    var last = parts.length - 1;
    for (var i = 0; i < last; i++) {
      current = parts[i];
      this.keyString += this.addModifier(current.toUpperCase());
    }

    this.action = actionName;
    this.keyCode = +(/\d+/.exec(parts[last])[0]);
    this.keyString += convertKeyCodeToChar(this.keyCode);
  }

  KeyAction.prototype.keyString = "";
  KeyAction.prototype.alt = KeyAction.prototype.ctrl = KeyAction.prototype.shift = KeyAction.prototype.meta = false;

  KeyAction.prototype.addModifier = function (char) {
    switch (char) {
      case "C":
        this.ctrl = true;
        return "Ctrl+";
      case "A":
        this.alt = true;
        return "Alt+";
      case "S":
        this.shift = true;
        return "Shift+";
      case "M":
        this.meta = true;
        return "Meta+";
    }
    return "";
  };

  KeyAction.prototype.matches = function (event, key, isInput) {
    return key === this.keyCode &&
        event.ctrlKey === this.ctrl &&
        event.altKey === this.alt &&
        event.shiftKey === this.shift &&
        event.metaKey === this.meta &&
        (!isInput || this.ctrl || this.alt || this.meta || key === keyCodes.mapped.Escape);
  };

  return KeyAction;
});
