define("@{type.name}/@{id}/selection/Selection", [
  "@{type.name}/@{id}/debug",
  "@{type.name}/@{id}/selection/Area"
], function (debug, Area) {
  "use strict";

  var CLASS_NAMES = {selection: "@{id}-selection", highlightIn: "highlight-in", highlightOut: "highlight-out"};
  var CLASS_DELAYS = {highlightIn: 500, highlightKeep: 0, highlightOut: 200};
  var NO_ELEMENT = $();

  function Selection() {
    this.areas = [];
    this.index = -1;
    this.active = {area: null, item: NO_ELEMENT};
    this.elementWithClass = NO_ELEMENT;
  }

  Selection.prototype.attachTheme = function (theme) {
    this.theme = theme;
    this.reset(this.refreshAreas());
  };

  Selection.prototype.select = function (areaIndex, itemIndex, $elementToAddClass) {
    var self = this;
    // default to saved container values
    if (areaIndex == null) { areaIndex = this.index; }
    if ($elementToAddClass == null) { $elementToAddClass = this.elementWithClass; }

    var area = this.active.area = this.areas[this.index = areaIndex];
    if (area == null) {
      this.active.item = null;
    } else {
      // fallback item-index to saved value within area
      // this ensures the index can be restored after another area was selected
      if (itemIndex == null) { itemIndex = area.index; }
      area.index = itemIndex;
      // get active item
      this.active.item = area.item();
    }

    if (this.elementWithClass[0] !== $elementToAddClass[0]) {
      this.elementWithClass
          .removeClass(CLASS_NAMES.selection)
          .removeClass(CLASS_NAMES.highlightIn)
          .removeClass(CLASS_NAMES.highlightOut);
      this.elementWithClass = $elementToAddClass.addClass(CLASS_NAMES.selection);
      if (this.theme != null) { this.theme.utils.scroll.elementIntoView(self.elementWithClass[0]); }
    }

    debug.log("Selection item changed", areaIndex, itemIndex);
  };

  Selection.prototype.deselect = function () { this.select(-1, 0, NO_ELEMENT); };

  Selection.prototype.reset = function (newAreas) {
    this.areas = newAreas == null ? [] : newAreas;
    this.deselect();
  };

  Selection.prototype.highlight = function () {
    var self = this;
    var element = self.elementWithClass;
    if (!element.length) { return false; }
    // viewport correction
    if (this.theme != null) { this.theme.utils.scroll.elementIntoView(element[0]); }
    // class manipulation
    element.addClass(CLASS_NAMES.highlightIn);
    setTimeout(function () {
      element.removeClass(CLASS_NAMES.highlightIn);
      setTimeout(function () {
        if (element === self.elementWithClass) {
          element.addClass(CLASS_NAMES.highlightOut);
          setTimeout(function () { element.removeClass(CLASS_NAMES.highlightOut); }, CLASS_DELAYS.highlightOut);
        }
      }, CLASS_DELAYS.highlightKeep);
    }, CLASS_DELAYS.highlightIn);
    return true;
  };


  /**
   Triggers the action of given grade and selected item.
   @param index The grade of the action to trigger.
   */
  Selection.prototype.triggerAction = function (index) {
    var area = this.active.area;
    var follow = area != null && area.hooks.follow != null && area.hooks.follow[index];
    return follow == null ? false : follow.call(this.active.item);
  };

  /**
   Selects the item of given index within given Area (defaults to active Area).
   @param index The index of the item to select.
   @param areaIndex The index of the Area to select (defaults to active Area).
   @returns Boolean Whether anything changed.
   */
  Selection.prototype.selectItem = function (index, areaIndex) {
    if (areaIndex == null) { areaIndex = this.index; }
    var area = this.areas[areaIndex];
    var item = area && area.item(index);

    if (item == null || areaIndex === this.index && index === areaIndex.index) { return false; }

    // find element to highlight
    var $elementToAddClass = item;
    if (!$elementToAddClass.height()) { // no height => find first child with height
      var children = $elementToAddClass.children().toArray(), child;
      for (var i = 0; i < children.length; i++) {
        child = $(children[i]);
        if (child.height()) {
          $elementToAddClass = child;
          break;
        }
      }
    }
    if (typeof area.hooks.getClassElement === "function") {
      $elementToAddClass = area.hooks.getClassElement.call($elementToAddClass, item);
    }
    // select item
    this.select(areaIndex, index, $elementToAddClass);
    // trigger focus hook
    if (area.hooks.focus && typeof area.hooks.focus.item === "function") { area.hooks.focus.item.call(item); }
    return true;
  };

  /**
   Selects the item that gets found the given amount of items behind the active one.
   @param step The amount of items to go ahead (may be negative too).
   @returns Boolean Whether anything changed.
   */
  Selection.prototype.selectNextItem = function (step) {
    if (step == null) { step = 1; }
    var area = this.active.area;
    if (area == null) { return false; }
    area.refreshItems();
    // normalize step
    var stepDirection = 1;
    if (step < 0) {
      stepDirection = -1;
      step = -step;
    }
    // step times select next visible item in stepDirection
    var index = area.index, result = false;
    var length = area.items.length, tries;
    while (step--) {
      tries = 0;
      // select first next item that has a height != 0 and is visible, break if no item is visible (tries counter)
      do {
        index += stepDirection;
        while (index < 0) { index += length; }
        while (index >= length) { index -= length; }
        result = this.selectItem(index);
      } while (++tries < length && this.active.item && !(this.active.item.height() && this.active.item.is(":visible")));
    }
    return result;
  };

  /**
   Generates a new array of all available Selection-Areas.
   @returns Array The Array of all available Areas.
   */
  Selection.prototype.refreshAreas = function () {
    if (this.theme == null) { return []; }
    var theme = this.theme;
    var areas = [];
    var i, selection, items, area, _len = theme.selection.length;
    for (i = 0; i < _len; i++) {
      selection = theme.selection[i];
      items = $(selection.selector);
      if (items.length) {
        if (selection.isParent) {
          items.each(addAreaByParent);
        } else {
          area = createArea(selection, items.eq(0).parent());
          if (area != null && (area.items.length || selection.force)) { areas.push(area); }
        }
      }
    }
    debug.log("Selection Areas refreshed", areas);
    return areas;

    function addAreaByParent(ignored, item) {
      var area = createArea(selection, $(item));
      if (area != null && (area.items.length || selection.force)) { areas.push(area); }
    }
  };

  /**
   * Creates a new Selection-Area with the given selector.
   * @param selector The selector object as defined by the theme.
   * @param parent The jQuery element to use as parent element.
   * @returns {null|Area}
   */
  function createArea(selector, parent) {
    var area = typeof selector.getArea === "function" ? selector.getArea.call(parent) : null;
    if (area === false) { return null; }
    if (area == null) { area = new Area(parent); }
    if (area.hooks == null) { area.setHooks(selector); }
    if (area.items == null) { area.refreshItems(); }
    return area;
  }

  /**
   Selects the Area at given index within this.areas.
   @param index The index of the Area to select.
   @returns Boolean Whether anything changed.
   */
  Selection.prototype.selectArea = function (index) {
    if (index === this.index) { return false; }
    // FIXME dropdown scroll does only ensure first item visible

    var area = this.areas[index], oldArea = this.active.area;

    if (oldArea && oldArea.hooks && oldArea.hooks.blur && typeof oldArea.hooks.blur.area === "function") {
      oldArea.hooks.blur.area.call(oldArea, area);
    }
    if (area.hooks.focus && typeof area.hooks.focus.area === "function") {
      area.hooks.focus.area.call(area, oldArea);
    }
    area.refreshItems();

    return this.selectItem(area.index, index) !== false;
  };

  /**
   Selects the Area that gets found the given amount of Areas behind the active one.
   @param step The amount of Areas to go ahead (may be negative too).
   @returns Boolean Whether anything changed.
   */
  Selection.prototype.selectNextArea = function (step) {
    if (step == null) { step = 1; }
    if (!this.areas.length) { return false; }
    var index = this.index < 0 ? step : this.index + step;
    var length = this.areas.length;
    while (index < 0) { index += length; }
    while (index >= length) { index -= length; }
    return this.selectArea(index);
  };

  return Selection;
});
