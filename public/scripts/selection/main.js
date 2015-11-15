"use strict";

define("@{type.name}/@{id}/selection/main", ["@{type.name}/@{id}/selection/Selection"], function (Selection) {
  var selection = new Selection();

  $(window).on("action:ajaxify.end", function () {
    selection.refreshAreas().done(function (areas) { selection.reset(areas); });
  });

  return selection;
});
