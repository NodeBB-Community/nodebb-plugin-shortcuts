"use strict";

define("@{type.name}/@{id}/theme-defaults", [
  "@{type.name}/@{id}/theme-defaults/utils",
  "@{type.name}/@{id}/theme-defaults/scopes",
  "@{type.name}/@{id}/theme-defaults/actions"
], function (defaultUtils, defaultScopes, defaultActions) {
  return function (theme) {
    defaultUtils(theme);
    defaultScopes(theme);
    defaultActions(theme);

    theme.dialogs = {
      getOpened: function () {
        return $(".modal-dialog").not(".chat-modal>div").filter(":visible").filter(function (ignored, el) {
          return $(el).height();
        });
      },
      close: function (el) { $(".bootbox-close-button", el).click(); } // TODO figure out better way
    };

    theme.composer = {
      getActive: function () {
        var composerList = $(".composer").filter(":visible").toArray();
        for (var i = 0; i < composerList.length; i++) {
          if ($(composerList[i]).css("visibility") !== "hidden") { return composerList[i]; }
        }
        return null;
      },
      getAny: function () {
        var composerList = $(".composer").filter(":visible");
        return composerList.length ? composerList[0] : null;
      },
      toggleFirst: function () {
        var tbItems = $(".taskbar li[data-module=\"composer\"]");
        var composerId = "cmp-uuid-" + tbItems.data("uuid");
        var tbLink = $("> a", tbItems)[0];
        if (tbLink != null) { tbLink.click(); }
        return document.getElementById(composerId);
      }
    };

    /**
     * List of Selection-Area types.
     * An element has to provide a selector to identify all items of the area.
     * Every element may provide the following attributes:
     * ; follow - item-scopes. An array of action-callbacks, sorted by grade.
     * ; getArea() - item-scope. Returns false if area is invalid or an Area-Object that knows the parent of all items.
     * ; focus.area(oldArea) - area-scope. Gets called when the area got selected.
     * ; focus.item() - item-scope. Gets called when any item gets selected.
     * ; blur.area(newArea) - area-scope. Gets called when another area got selected.
     * ; getClassElement(item) - proposal elements scope. Returns the element to display box-shadow around.
     */
    theme.selection = {};
  };
});
