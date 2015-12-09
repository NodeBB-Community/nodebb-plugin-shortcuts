define("@{type.name}/@{id}/theme-defaults/scopes", function () {
  "use strict";

  return function (shortcuts, theme) {
    theme.scopes = {
      getCurrent: function () {
        // if a dialog is opened, restrict scopes
        if (theme.dialogs.getOpened().length) { return ["dialog", "body"]; }
        // if ACP, restrict scopes
        if (app.inAdmin) { return ["acp", "body"]; }

        var scopes = [];
        // enable (minimized) composer if found
        if (theme.composer.getAny() != null) {
          scopes.push(theme.composer.getActive() != null ? "composer" : "composer_closed");
        }
        // enable taskbar if found
        if ($(".taskbar li").length) { scopes.push("taskbar"); }
        // enable breadcrumb if found
        if ($(".breadcrumb").length) { scopes.push("breadcrumb"); }
        // enable topic, category, selection
        scopes.push("topic", "category", "selection");
        // enable nav-pills if found
        if ($(".nav-pills").length) { scopes.push("navPills"); }
        // enable header and body
        scopes.push("header", "body");
        return scopes;
      }
    };
  };
});
