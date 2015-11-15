"use strict";

// define module to keep the main instance of Core
define("@{type.name}/@{id}/main", ["@{type.name}/@{id}/debug", "@{type.name}/@{id}/Core"], function (debug, Core) {
  var defer = $.Deferred();

  socket.emit("plugins.@{iD}", null, function (err, data) {
    if (err != null) {
      defer.reject(err);
      return debug.error(err);
    }
    var settings = data.settings;
    var $doc = $(document);

    $doc.ready(function () {
      // apply styles to document
      var styles = ".@{id}-selection { box-shadow:0 0 5px 1px " + settings.selectionColor + " !important; }";
      $("<style type=\"text/css\">" + styles + "</style>").appendTo("head");

      // create main instance
      var shortcuts = new Core(settings);
      shortcuts.startWatching($doc);
      defer.resolve(shortcuts);
    });
  });

  return defer;
});

require([
          "@{type.name}/@{id}/debug",
          "@{type.name}/@{id}/main",
          "@{type.name}/@{id}/theme",
          "@{type.name}/@{id}/selection/Selection",
          "@{type.name}/@{id}/theme-defaults"
        ], function (debug, shortcuts, theme, Selection, themeDefaults) {
  shortcuts.done(function (shortcuts) {
    // resolve theme module
    var SUPPORTED_THEMES = ["lavender", "persona"];
    var themeID = config["theme:id"].substring("nodebb-theme-".length);

    if (~SUPPORTED_THEMES.indexOf(themeID)) {
      debug.log("Theme detected.", themeID);

      require(["@{type.name}/@{id}/themes/" + themeID + "/main"], function (theme) {
        // add theme related actions
        var result = {};
        themeDefaults(shortcuts, result);
        theme(shortcuts, result);

        var itemSelectorsJoined = "";
        for (var key in result.selection) {
          if (result.selection.hasOwnProperty(key)) {
            itemSelectorsJoined += (result.selection[key].selector += ":visible") + ",";
          }
        }
        result.itemSelectorsJoined = itemSelectorsJoined.substring(0, itemSelectorsJoined.length - 1);

        shortcuts.attachTheme(result);

        // create new selection instance
        var selection = new Selection();
        $(window).on("action:ajaxify.end", function () { selection.reset(selection.refreshAreas()); });

        // add selection related actions
        //noinspection JSUnusedGlobalSymbols
        shortcuts.mergeActions(
            {
              selection: {
                release: function () { return selection.deselect(); },
                follow: function () { return selection.triggerAction(0); },
                highlight: function () { return selection.highlight(); },
                item: {
                  next: function () {
                    return selection.active.area == null ? selection.selectNextArea(0) : selection.selectNextItem(1);
                  },
                  prev: function () {
                    return selection.active.area == null ? selection.selectNextArea(0) : selection.selectNextItem(-1);
                  }
                },
                area: {
                  next: function () { return selection.selectNextArea(1); },
                  prev: function () { return selection.selectNextArea(-1); }
                }
              }
            }
        );
        shortcuts.prependToAction("body.focus", function () { return selection.deselect(); });

        selection.attachTheme(result);
      });
    } else {
      debug.error("Theme not supported.", themeID);
    }
  });
});
