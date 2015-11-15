"use strict";

/*
 * This file identifies which theme is in use and links the theme-specific module to /theme.
 */

define("@{type.name}/@{id}/theme", [
  "@{type.name}/@{id}/debug",
  "@{type.name}/@{id}/theme-defaults"
], function (debug, defaults) {
  var SUPPORTED_THEMES = ["lavender", "persona"];
  var defer = $.Deferred();

  $(document).ready(function () {
    var themeID = config["theme:id"].substring("nodebb-theme-".length);

    debug.log("Theme detected:", themeID);
    if (!~SUPPORTED_THEMES.indexOf(themeID)) {
      defer.reject(new Error("Theme could not get identified."));
      return debug.error("Theme could not get identified.");
    }

    require(["@{type.name}/@{id}/themes/" + themeID + "/main"], function (theme) {
      var result = {};
      defaults(result); // TODO call with shortcuts instance
      theme(result);

      var itemSelectorsJoined = "";
      for (var key in result.selection) {
        if (result.selection.hasOwnProperty(key)) {
          itemSelectorsJoined += (result.selection[key].selector += ":visible") + ",";
        }
      }
      result.itemSelectorsJoined = itemSelectorsJoined.substring(0, itemSelectorsJoined.length - 1);

      defer.resolve(result);
    });
  });

  return defer;
});
