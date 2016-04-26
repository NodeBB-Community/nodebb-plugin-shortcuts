define("@{type.name}/@{id}/debug", function () {
  "use strict";

  var __slice = Array.prototype.slice;
  var env = "@{env}", dev = (env === "development");

  var exports = {
    enabled: dev,

    _log: function () {
      console.log.apply(console, ["@{name} DEBUG -"].concat(__slice.call(arguments)));
    },
    error: function () {
      console.error.apply(console, ["@{name} ERROR -"].concat(__slice.call(arguments)));
    }
  };

  if (dev) {
    exports.log = exports._log;
    exports.log("Debug-mode is enabled.");
  } else {
    exports.log = $.noop;
  }

  return exports;
});
