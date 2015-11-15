"use strict";

/*
 * This files gets called from the admin-page of the module to handle settings.
 *
 * Files within the public/static/scripts/ directory get meta-replaced by default (thus @{...} gets resolved within the
 * grunt-tasks).
 */

(function () {

  var moduleId = "@{id}";
  var $wrapper = $("#" + moduleId + "-settings");
  var $actionsWrapper = $("#" + moduleId + "-actions");
  var $adminActionsWrapper = $("#" + moduleId + "-admin-actions");

  socket.emit("admin.settings.get@{Id}Defaults", null, function (err, defaultSettings) {
    if (err != null) {
      return app.alert({
                         alert_id: "config_status", timeout: 2500, type: "danger", title: "Settings Not Found",
                         message: "Your plugin-settings have not been found."
                       });
    }

    require(["settings", "translator"], function (settings, translator) {

      /*======================================= Dynamically insert action inputs =======================================*/

      function dashCase(m) { return "-" + m.toLowerCase(); }

      function getScopeField(key, id) {
        var $el = $("<div class=\"form-group\"></div>");
        var $label = $("<label class=\"col-xs-12 col-sm-5 control-label\" for=\"" + id + "\"></label>").appendTo($el);
        translator.translate("[[" + moduleId + ":" + key + "]]", function (str) { $label.text(str); });
        var $input = $("<div id=\"" + id + "\" data-key=\"" + key + "\"></div>")
            .data({attributes: {class: "form-control", type: "key"}, split: " "});
        return $el.append($label).append($("<div class=\"col-xs-12 col-sm-7\"></div>").append($input));
      }

      function addScopeFields($scopeElement, obj, key, id) {
        var current, currentId, currentKey;
        for (var k in obj) {
          if (obj.hasOwnProperty(k)) {
            current = obj[k];
            currentId = id + "-" + k;
            currentKey = key + "." + k;
            if (typeof current === "object" && !(current instanceof Array)) {
              addScopeFields($scopeElement, current, currentKey, currentId);
            } else {
              if (typeof current === "string") { current = [current]; }
              if (current instanceof Array) {
                getScopeField(currentKey, moduleId + "-" + currentId.replace(/[A-Z]/g, dashCase))
                    .appendTo($scopeElement);
              }
            }
          }
        }
      }

      function getScopeElement(scope, actions, key) {
        var $scopeElement = $("<div class=\"col-xs-12 col-sm-6\"></div>");
        var $scopeHeader = $("<h3></h3>").appendTo($scopeElement);
        translator.translate("[[" + moduleId + ":actions." + scope + "]]", function (str) { $scopeHeader.text(str); });
        addScopeFields($scopeElement, actions, key + "." + scope, "action");
        return $scopeElement;
      }

      function addFields($target, actions, key) {
        for (var scope in actions) {
          if (actions.hasOwnProperty(scope)) { getScopeElement(scope, actions[scope], key).appendTo($target); }
        }
      }

      addFields($actionsWrapper, defaultSettings._.actions, "actions");
      addFields($adminActionsWrapper, defaultSettings._.adminActions, "adminActions");

      /*========================================= Handle settings and buttons  =========================================*/

      // synchronize settings
      settings.sync(moduleId, $wrapper);

      $wrapper.find("." + moduleId + "-settings-save").click(function (event) {
        event.preventDefault();
        settings.persist(moduleId, $wrapper, function () { socket.emit("admin.settings.sync@{Id}"); });
      }).removeAttr("disabled");

      $wrapper.find("." + moduleId + "-settings-reset").click(function (event) {
        event.preventDefault();
        settings.sync(moduleId, $wrapper);
      }).removeAttr("disabled");

      $wrapper.find("." + moduleId + "-settings-purge").click(function (event) {
        event.preventDefault();
        socket.emit("admin.settings.get@{Id}Defaults", null, function (err, data) {
          settings.set(moduleId, data, $wrapper, function () { socket.emit("admin.settings.sync@{Id}"); });
        });
      }).removeAttr("disabled");
    });

  });

})();