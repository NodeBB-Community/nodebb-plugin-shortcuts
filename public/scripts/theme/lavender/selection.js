"use strict";

define("@{type.name}/@{id}/themes/lavender/selection", ["@{type.name}/@{id}/selection/Area"], function (Area) {
  return function (shortcuts, theme) {
    theme.selection = {
      posts: {
        selector: "[component=\"post\"]",
        follow: [
          function () { ajaxify.go("topic/" + ajaxify.data.slug + "/" + (1 + this.data("index"))); }
        ]
      },
      topics: {
        selector: "[component=\"category/topic\"]",
        follow: [
          function () {
            var $link = $(".replies > a[href*=\"/topic/\"]", this);
            if (!$link.length) { $link = $("[component=\"topic/header\"],.topic-title", this); }
            if ($link.length) { ajaxify.go($link.attr("href")); }
          },
          function () {
            var $link = $("[component=\"topic/header\"],.topic-title", this);
            if ($link.length) { ajaxify.go($link.attr("href")); }
          }
        ]
      },
      categories: { // TODO check if working with sub-categories
        selector: "[component=\"categories/category\"]",
        follow: [
          function () { ajaxify.go("category/" + this.data("cid")); }
        ]
      },
      // TODO [ check following actions (and update to component-notation)...
      recent_topics: {
        selector: "#recent_topics>li",
        follow: [
          function () {
            var url = $("a[href^=\"/topic/\"]", this).last().attr("href");
            ajaxify.go(url == null ? null : url.substring(1));
          }
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
      // TODO ]
      dropDowns: {
        selector: "[data-toggle=\"dropdown\"]:not([disabled])",
        getArea: function () {
          if (this.parent().is("#header-menu *")) { return false; }
          var area = new Area(this.parent());
          area.setHooks({
            selector: ">ul>li:not(.divider,.dropdown-header)",
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
          function () { $(">*", this).focus()[0].click(); }
        ]
      }
    };
  };
});
