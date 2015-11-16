"use strict";

define("@{type.name}/@{id}/theme-defaults/actions", function () {
  return function (shortcuts, theme) {
    shortcuts.mergeActions(
        {
          body: {
            focus: function () {
              $(".open>[data-toggle=\"dropdown\"]").click();
              theme.utils.blurFocus();
            },
            scroll: {
              pageDown: function () { theme.utils.scroll.verticalPages(1); },
              pageUp: function () { theme.utils.scroll.verticalPages(-1); },
              top: function () { theme.utils.scroll.verticalAbsolute(0); },
              bottom: function () { theme.utils.scroll.verticalAbsolute(1); }
            },
            reload: {
              soft: function () { ajaxify.refresh(); },
              hard: function () { location.href = /^([^#]*)(#[^\/]*)?$/.exec(location.href)[1]; }
            },
            form: {
              next: function () {
                var formEl = theme.utils.formElements.getRelativeToFocused(1);
                if (formEl != null && formEl.length) {
                  formEl.focus();
                  theme.utils.scroll.elementIntoView(formEl[0]);
                } else {
                  return $("#search-button").click().length > 0;
                }
              },
              prev: function () {
                var formEl = theme.utils.formElements.getRelativeToFocused(-1);
                if (formEl != null && formEl.length) {
                  formEl.focus();
                  theme.utils.scroll.elementIntoView(formEl[0]);
                } else {
                  return $("#search-button").click().length > 0;
                }
              }
            }
          },

          header: {
            home: function () { ajaxify.go(""); },
            categories: function () { ajaxify.go("categories"); },
            unread: function () { ajaxify.go("unread"); },
            recent: function () { ajaxify.go("recent"); },
            tags: function () { ajaxify.go("tags"); },
            popular: function () { ajaxify.go("popular"); },
            users: function () { ajaxify.go("users"); },
            groups: function () { ajaxify.go("groups"); },
            notifications: function () { ajaxify.go("notifications"); },
            profile: function () { ajaxify.go("user/" + app.user.username); },
            search: function () { return $("#search-button").click().length > 0; },
            chats: function () { ajaxify.go("chats"); },
            admin: function () {
              if (app.user.isAdmin) { location.pathname = RELATIVE_PATH + "/admin"; } else { return false; }
            }
          },

          navPills: {
            next: function () {
              var $pills = $(".nav-pills").eq(0).find(">li").not(".hide,.hidden");
              if ($pills.css("float") === "right") {
                theme.utils.navPills.prev($pills);
              } else {
                theme.utils.navPills.next($pills);
              }
            },
            prev: function () {
              var $pills = $(".nav-pills").eq(0).find(">li").not(".hide,.hidden");
              if ($pills.css("float") === "right") {
                theme.utils.navPills.next($pills);
              } else {
                theme.utils.navPills.prev($pills);
              }
            }
          },

          breadcrumb: {
            up: function () {
              var breadcrumb = $(".breadcrumb li.active").prev().find(">a")[0];
              if (breadcrumb == null) { return false; }
              breadcrumb.click();
            }
          },

          category: {newTopic: function () { return $("#new_topic").click().length > 0; }},

          topic: {reply: function () { return $("[component=\"topic/reply\"]").first().click().length > 0; }},

          composer: {
            send: function () { $("button[data-action=\"post\"]", theme.composer.getActive())[0].click(); },
            discard: function () {
              return $("button[data-action=\"discard\"]", theme.composer.getActive())[0].click();
            },
            closed: {
              input: function () {
                var composer = theme.composer.getActive() || theme.composer.toggleFirst();
                if (composer == null) { return false; }
                setTimeout((function () { $(".write", composer).focus(); }), 0);
              },
              title: function () {
                var composer = theme.composer.getActive() || theme.composer.toggleFirst();
                if (composer == null) { return false; }
                setTimeout((function () { $(".title", composer).focus(); }), 0);
              }
            },
            preview: function () {
              var composer = theme.composer.getActive();
              return $(".toggle-preview:visible", composer).click().length > 0;
            },
            previewSend: function () {
              var composer = theme.composer.getActive();
              if (composer == null) { return false; }
              var $togglePreview = $(".toggle-preview:visible", composer);
              if ($(".preview-container:visible", composer).length || !$togglePreview.length) {
                $("button[data-action=\"post\"]", composer)[0].click();
              } else {
                return $togglePreview.click().length > 0;
              }
            },
            help: function () {
              var composer = theme.composer.getActive();
              if (composer == null) { return false; }
              $(".help", composer).click();
            },
            write: function () {
              var composer = theme.composer.getActive();
              return $(".write", composer).focus().length > 0;
            },
            bold: function () {
              return $(".formatting-bar [data-format=\"bold\"]", theme.composer.getActive()).click().length > 0;
            },
            italic: function () {
              return $(".formatting-bar [data-format=\"italic\"]", theme.composer.getActive()).click().length > 0;
            },
            list: function () {
              return $(".formatting-bar [data-format=\"list\"]", theme.composer.getActive()).click().length > 0;
            },
            link: function () {
              return $(".formatting-bar [data-format=\"link\"]", theme.composer.getActive()).click().length > 0;
            }
          },

          dialog: {
            confirm: function () {
              var any = false;
              theme.dialogs.getOpened().each(function (ignored, dialog) {
                if (theme.dialogs.confirm(dialog)) { any = true; }
              });
              return any;
            },
            cancel: function () {
              var any = false;
              theme.dialogs.getOpened().each(function (ignored, dialog) {
                if (theme.dialogs.cancel(dialog)) { any = true; }
              });
              return any;
            },
            close: function () {
              var any = false;
              theme.dialogs.getOpened().each(function (ignored, dialog) {
                if (theme.dialogs.close(dialog)) { any = true; }
              });
              return any;
            }
          },

          taskbar: {
            closeAll: function () {
              var links = $(".taskbar li.active>a").toArray();
              if (!links.length) { return false; }
              for (var i = 0; i < links.length; i++) { links[i].click(); }
            },
            clickFirst: function () { return $(".taskbar li>a").click().length > 0; },
            clickLast: function () { return $(".taskbar li>a").last().click().length > 0; }
          }
        }
    );
  };
});
