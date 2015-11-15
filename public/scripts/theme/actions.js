"use strict";

define("@{type.name}/@{id}/theme-defaults/actions", function () {
  return function (shortcuts, theme) {
    shortcuts.mergeActions(
        {
          body: {
            focus: function () {
              $(".open>.dropdown-toggle").click();
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
            unread: function () { ajaxify.go("unread"); },
            recent: function () { ajaxify.go("recent"); },
            tags: function () { ajaxify.go("tags"); },
            popular: function () { ajaxify.go("popular"); },
            users: function () { ajaxify.go("users"); },
            groups: function () { ajaxify.go("groups"); },
            notifications: function () { ajaxify.go("notifications"); },
            profile: function () { ajaxify.go("user/" + app.username); },
            search: function () { return $("#search-button").click().length > 0; },
            chats: function () { $("#chat_dropdown").click(); },
            admin: function () {
              if (app.user.isAdmin) {
                location.pathname = RELATIVE_PATH + "/admin";
              } else {
                return false;
              }
            }
          },

          navPills: {
            next: function () {
              var $pills = $(">li", $(".nav-pills")[0]).not(".hide");
              if ($pills.css("float") === "right") {
                theme.utils.navPills.prev($pills);
              } else {
                theme.utils.navPills.next($pills);
              }
            },
            prev: function () {
              var $pills = $(">li", $(".nav-pills")[0]).not(".hide");
              if ($pills.css("float") === "right") {
                theme.utils.navPills.next($pills);
              } else {
                theme.utils.navPills.prev($pills);
              }
            }
          },

          breadcrumb: {
            up: function () {
              var breadcrumb = $("> a", $(".breadcrumb li.active").prev())[0];
              if (breadcrumb == null) { return false; }
              breadcrumb.click();
            }
          },

          category: {
            newTopic: function () {
              var newTopic = $("#new_post")[0];
              if (newTopic == null) { return false; }
              newTopic.click();
            }
          },

          topic: {
            reply: function () {
              var reply = $(".shortcut-selection .btn.quote")[0] || $(".post_reply").last()[0];
              if (reply == null) { return false; }
              reply.click();
            },
            threadTools: function () {
              var threadTools = $(".thread-tools>button")[0];
              if (threadTools == null) { return false; }
              threadTools.click();
            }
          },

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
              var $preview = $("a[data-pane=\".tab-preview\"]", theme.composer.getActive());
              if (!$preview.length || $preview.parent().hasClass("active")) { return false; }
              $preview[0].click();
            },
            previewSend: function () {
              var composer = theme.composer.getActive();
              var $preview = $("a[data-pane=\".tab-preview\"]", composer);
              if (!$preview.length || $preview.parent().hasClass("active")) {
                $("button[data-action=\"post\"]", composer)[0].click();
              } else {
                $preview[0].click();
              }
            },
            writeSend: function () {
              var composer = theme.composer.getActive();
              var $write = $("a[data-pane=\".tab-write\"]", composer);
              if (!$write.length || $write.parent().hasClass("active")) {
                $("button[data-action=\"post\"]", composer)[0].click();
              } else {
                $write[0].click();
              }
            },
            help: function () {
              var $help = $("a[data-pane=\".tab-help\"]", theme.composer.getActive());
              if ($help.length) {
                if ($help.parent().hasClass("active")) { return false; }
                $help[0].click();
              } else {
                $help = $(".help", theme.composer.getActive());
                if (!$help.length) { return false; }
                $help.click();
              }
            },
            write: function () {
              var composer = theme.composer.getActive();
              var $write = $("a[data-pane=\".tab-write\"]", composer);
              if (!$write.length || $write.parent().hasClass("active")) {
                $(".write", composer).focus();
                return false;
              }
              $write[0].click();
            },
            bold: function () { $(".formatting-bar .fa-bold", theme.composer.getActive())[0].click(); },
            italic: function () { $(".formatting-bar .fa-italic", theme.composer.getActive())[0].click(); },
            list: function () { $(".formatting-bar .fa-list", theme.composer.getActive())[0].click(); },
            link: function () { $(".formatting-bar .fa-link", theme.composer.getActive())[0].click(); }
          },

          dialog: {
            confirm: function () {
              var any = false;
              theme.dialogs.getOpened().each(function (ignored, d) {
                var confirm = $(".modal-footer>button", d)[1];
                if (confirm != null) {
                  any = true;
                  confirm.click();
                }
              });
              return any;
            },
            close: function () {
              var any = false;
              theme.dialogs.getOpened().each(function (ignored, d) {
                var close = $(".bootbox-close-button,.close", d)[1];
                if (close != null) {
                  any = true;
                  close.click();
                }
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
            clickFirst: function () {
              var link = $(".taskbar li>a")[0];
              if (link == null) { return false; }
              link.click();
            },
            clickLast: function () {
              var link = $(".taskbar li>a").last()[0];
              if (link == null) { return false; }
              link.click();
            }
          }
        }
    );
  };
});
