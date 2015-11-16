"use strict";

/*
 * Latest functionality approval:
 *   2015/11/16
 *   NodeBB 0.9.0
 *   nodebb-theme-lavender 3.0.0
 */

define("@{type.name}/@{id}/themes/lavender/main", [
  "@{type.name}/@{id}/themes/lavender/selection"
], function (selection) {
  return function (shortcuts, theme) { selection(shortcuts, theme); };
});
