"use strict";

define("@{type.name}/@{id}/debug", function () {
  var __slice = Array.prototype.slice;
  var env = "@{env}";
  var debug = env === "development";

  var exports = {
    enabled: debug,
    _log: function () {
      var args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      console.log.apply(console, ["@{name} DEBUG -"].concat(__slice.call(args)));
    },
    log: function () {
      var args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (debug) { exports._log.apply(null, args); }
    },
    error: function () {
      console.error.apply(console, ["@{name} ERROR -"].concat(__slice.call(arguments)));
    }
  };

  exports.log("Debug-mode is enabled.");

  return exports;
});
