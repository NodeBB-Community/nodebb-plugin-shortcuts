/*
 * Latest functionality approval:
 *   2015/11/16
 *   NodeBB 0.9.0
 *   nodebb-theme-persona 4.0.39
 */

define("@{type.name}/@{id}/themes/persona/main", [
  "@{type.name}/@{id}/themes/persona/selection"
], function (selection) {
  "use strict";

  return function (shortcuts, theme) { selection(shortcuts, theme); };
});
