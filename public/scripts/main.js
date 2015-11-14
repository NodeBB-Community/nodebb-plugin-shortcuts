"use strict";

socket.emit("plugins.@{iD}", null, function (err, data) {
  require(["@{type.name}/@{id}/debug"], function (debug) {
    if (err != null) { return debug.error(err); }
    var settings = data.settings;

    $(document).ready(function () {
      // apply styles to document
      var styles = ".@{id}-selection { box-shadow:0 0 5px 1px " + settings.selectionColor + " !important; }";
      $("<style type=\"text/css\">" + styles + "</style>").appendTo("head");

      // define module to keep the main instance of Core
      define("@{type.name}/@{id}/main", [
        "@{type.name}/@{id}/key-codes",
        "@{type.name}/@{id}/input-fields",
        "@{type.name}/@{id}/Core",
        "@{type.name}/@{id}/theme",
        "@{type.name}/@{id}/selection/main"
      ], function (debug, keyCodes, inputFields, Core, theme, selection) {
        var shortcuts = new Core(settings);

        // watch for keyboard events and forward them (normalized) to core instance
        $(document).keydown(function (event) {
          var key;
          event = event || window.event;
          key = event.which = event.which || event.keyCode || event.key;
          if (debug.enabled) { // don't calculate logging string if disabled enyways
            debug._log("Key Down: " + (event.ctrlKey ? "C-" : "") + (event.altKey ? "A-" : "") + (event.shiftKey ? "S-" : "") + (event.metaKey ? "M-" : "") + key);
          }
          shortcuts.handleEvent(event, key);
        });
        $(document).keyup(function () {
          shortcuts.released();
        });

        // watch for "?" key pressed to show help modal
        $(document).keypress(function (event) {
          var key;
          event = event || window.event;
          if (~inputFields.indexOf(event.target.tagName)) {
            key = event.which || event.keyCode || event.key;
            if (key === keyCodes.questionMark) { shortcuts.help(); }
          }
        });

        // add selection related actions
        shortcuts.addActions(
            {
              selection: {
                release: function () { return selection.deselect(); },
                follow: function () { return selection.triggerAction(0); },
                highlight: function () { return selection.highlight(); },
                item_next: function () {
                  return selection.active.area == null ? selection.selectNextArea(0) : selection.selectNextItem(1);
                },
                item_prev: function () {
                  return selection.active.area == null ? selection.selectNextArea(0) : selection.selectNextItem(-1);
                },
                area_next: function () { return selection.selectNextArea(1); },
                area_prev: function () { return selection.selectNextArea(-1); }
              }
            }
        );
        shortcuts.prependToAction("body_focus", function () { return selection.deselect(); });

        // add theme related actions
        if (theme.actionData != null) { shortcuts.addActions(theme.actionData); }

        return shortcuts;
      });
    });
  });
});
