"use strict";

/*
 * This file identifies which theme is in use and links the theme-specific module to /theme.
 */

require(["@{type.name}/@{id}/debug"], function (debug) {
  var SUPPORTED_THEMES = ["lavender", "persona"];

  $(document).ready(function () {
    var themeID = config["theme:id"].substring("nodebb-theme-".length);

    debug.log("Theme detected:", themeID);
    if (!~SUPPORTED_THEMES.indexOf(themeID)) { return debug.error("Theme could not get identified."); }

    define("@{type.name}/@{id}/theme", [
      "@{type.name}/@{id}/themes/" + themeID + "/main",
      "@{type.name}/@{id}/theme-defaults"
    ], function (theme, defaults) {
      var result = {};
      defaults(result);
      theme(result);

      var itemSelectorsJoined = "";
      for (var key in result.selection) {
        if (result.selection.hasOwnProperty(key)) {
          itemSelectorsJoined += (result.selection[key].selector += ":visible") + ",";
        }
      }
      result.itemSelectorsJoined = itemSelectorsJoined.substring(0, itemSelectorsJoined.length - 1);

      return result;
    });
  });
});
