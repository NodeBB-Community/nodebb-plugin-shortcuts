"use strict";

define("@{type.name}/@{id}/selection/Area", function () {
  var NO_ELEMENT = $();

  /**
   * A class to identify a Selection-Area within DOM.
   * @param $parent The parent jQuery object of the area.
   * @constructor
   */
  function Area($parent) {
    this.parent = $parent == null ? NO_ELEMENT : $parent;
    this.hooks = {};
    this.items = null;
    this.index = 0;
  }

  Area.prototype.refreshItems = function (hooks) {
    this.hooks = hooks == null ? this.hooks : hooks;
    this.items = $(this.hooks.selector, this.parent);
    if (!this.items.length) {
      this.items = this.parent.children(this.hooks.selector);
    }
  };

  Area.prototype.item = function (index) { return this.items.eq(index == null ? this.index : index); };

  return Area;
});
