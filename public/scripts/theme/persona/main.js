"use strict";

/*
 * Latest functionality approval:
 *   2015/11/16
 *   NodeBB 0.9.0
 *   nodebb-theme-lavender 4.0.36
 */

define("@{type.name}/@{id}/themes/persona/main", [
  "@{type.name}/@{id}/themes/persona/selection"
], function (selection) {
  return function (shortcuts, theme) { selection(shortcuts, theme); };
});
