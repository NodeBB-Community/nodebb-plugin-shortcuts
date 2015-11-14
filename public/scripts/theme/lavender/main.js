"use strict";

/*
 * Latest functionality approval:
 *   2015/02/04
 *   NodeBB 0.6.0
 *   nodebb-theme-lavender 0.2.13
 */

define("@{type.name}/@{id}/themes/lavender/main", [
  "@{type.name}/@{id}/themes/lavender/selection"
], function (selection) { return function (theme) { selection(theme); }; });
