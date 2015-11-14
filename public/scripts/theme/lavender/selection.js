"use strict";

define("@{type.name}/@{id}/themes/lavender/selection", ["@{type.name}/@{id}/selection/Area"], function (Area) {
  return function (theme) {
    theme.selection = {
      posts: {
        selector: "[data-pid]",
        follow: [
          function () {
            var topicId = this.closest("[data-tid]").data("tid") ||
                /\/topic\/(\d+)/.exec($("a[href^=\"/topic/\"]", this).last().attr("href"))[1];
            var url = /^topic\/([^\/]+\/){2}/.exec(ajaxify.currentPage);
            ajaxify.go((url && url[0] || ("topic/" + topicId + "/x/")) + (1 + this.data("index")));
          }
        ]
      },
      topics: {
        selector: "[data-tid]",
        getArea: function () { return this.is("#post-container") ? false : new Area(this.parent()); },
        follow: [
          function () {
            var url = $("[itemprop=\"url\"]", this).attr("href");
            ajaxify.go(url ? url.substring(url.indexOf("/topic/") + 1) : "topic/" + this.data("tid"));
          }
        ]
      },
      recent_topics: {
        selector: "#recent_topics>li",
        follow: [
          function () {
            var url = $("a[href^=\"/topic/\"]", this).last().attr("href");
            ajaxify.go(url == null ? null : url.substring(1));
          }
        ]
      },
      categories: {
        selector: "[data-cid]",
        getClassElement: function () {
          if (this.hasClass("category-item")) {
            var icon = $(".category-icon", this);
            if (icon.length) { return icon; }
          }
          return this;
        },
        follow: [
          function () { ajaxify.go("category/" + this.data("cid")); }
        ]
      },
      notifications: {
        selector: "[data-nid]",
        follow: [
          function () { this.click(); }
        ]
      },
      users: {
        selector: ".users-container>li",
        follow: [
          function () {
            var url = $("a[href^=\"/user/\"]", this).attr("href");
            ajaxify.go(url == null ? null : url.substring(1));
          }
        ]
      },
      groups: {
        selector: "#groups-list>div",
        getClassElement: function () { return this.children().eq(0); },
        follow: [
          function () {
            var heading = $(".panel-heading", this)[0];
            heading && heading.click();
          }
        ]
      },
      tags: {
        selector: "h3 > a[href*=\"/tags/\"]",
        getArea: function () { return new Area(this.parent().parent()); },
        follow: [
          function () { this[0] && this[0].click(); }
        ]
      },
      chats: {
        selector: "ul.chats-list.recent-chats > li",
        getClassElement: function () {
          return $("span", this);
        },
        follow: [
          function () { this[0] && this[0].click(); }
        ]
      },
      dropDowns: {
        selector: "[data-toggle=\"dropdown\"]:not([disabled])",
        getArea: function () {
          if (this.parent().is("#header-menu *")) { return false; }
          var area = new Area(this.parent());
          area.refreshItems({
                              selector: ">ul>li:not(.divider)",
                              focus: theme.selection.dropDowns.focus,
                              blur: theme.selection.dropDowns.blur,
                              follow: theme.selection.dropDowns.follow
                            });
          return area;
        },
        focus: {
          area: function () {
            if (!this.parent.hasClass("open")) { $("[data-toggle=\"dropdown\"]:not([disabled])", this.parent).click(); }
            setTimeout(theme.utils.blurFocus, 50);
          },
          item: function () {
            var grandpa = this.parent().parent();
            if (!grandpa.hasClass("open")) { $("[data-toggle=\"dropdown\"]:not([disabled])", grandpa).click(); }
            setTimeout(theme.utils.blurFocus, 50);
          }
        },
        blur: {
          area: function () {
            if (this.parent.hasClass("open")) { $("[data-toggle=\"dropdown\"]:not([disabled])", this.parent).click(); }
          }
        },
        follow: [
          function () { $(">*", this).focus().click(); }
        ]
      }
    };
  };
});
