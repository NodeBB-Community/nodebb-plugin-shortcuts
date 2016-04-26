define("@{type.name}/@{id}/themes/lavender/selection", ["@{type.name}/@{id}/selection/Area"], function (Area) {
  "use strict";

  return function (shortcuts, theme) {
    var dropDownSelector = { // dropDowns
      selector: "[data-toggle=\"dropdown\"]:not([disabled])",
      isParent: true,
      force: true, // topic- and post-tools get lazy-loaded on-focus
      getArea: function () {
        if (this.parent().is("#header-menu *")) { return false; }
        var area = new Area(this.parent());
        area.setHooks({
          selector: ">ul>li:not(.divider,.dropdown-header)",
          focus: dropDownSelector.focus,
          blur: dropDownSelector.blur,
          follow: dropDownSelector.follow
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
    };

    theme.selection = [
      { // posts
        selector: "[component=\"post\"]",
        follow: [
          function () { ajaxify.go("topic/" + ajaxify.data.slug + "/" + (1 + this.data("index"))); }
        ]
      },
      { // topics
        selector: "[component=\"category/topic\"]",
        follow: [
          function () {
            var $link = this.find(".replies > a[href*=\"/topic/\"]");
            if (!$link.length) { $link = $("[component=\"topic/header\"],.topic-title", this); }
            if ($link.length) { $link[0].click(); }
          },
          function () {
            var $link = this.find("[component=\"topic/header\"],.topic-title");
            if ($link.length) { $link[0].click(); }
          }
        ]
      },
      { // categories
        selector: "[component=\"categories/category\"], .subcategories>[data-cid]",
        follow: [
          function () { ajaxify.go("category/" + this.data("cid")); }
        ],
        getClassElement: function () { return $(".category-icon", this); }
      },
      { // notifications
        selector: ".notifications-list>[data-nid]",
        follow: [
          function () {
            var $link = this.find("a");
            if ($link.length) { $link[0].click(); }
          }
        ]
      },
      { // users
        selector: ".users-container>li",
        follow: [
          function () {
            var $link = this.find("a[href*=\"/user/\"]");
            if ($link.length) { $link[0].click(); }
          }
        ]
      },
      { // groups
        selector: "[component=\"groups/summary\"]",
        getClassElement: function () { return this.children().eq(0); },
        follow: [
          function () {
            var $link = this.find(".panel-heading");
            if ($link.length) { $link[0].click(); }
          }
        ]
      },
      { // tags
        selector: ".tag-list>.tag-container",
        follow: [
          function () {
            var $link = this.find(">a");
            if ($link.length) { $link[0].click(); }
          }
        ],
        getClassElement: function () { return this.find(".tag-item,.tag-topic-count"); }
      },
      { // chats_recent
        selector: "[component=\"chat/recent\"]>li",
        getClassElement: function () { return this.find(".user-icon,.username"); },
        follow: [
          function () { this[0].click(); }
        ]
      },
      { // chats_contacts
        selector: "[component=\"chat/contacts\"]>li",
        getClassElement: function () { return this.find(".user-icon,.username"); },
        follow: [
          function () { this[0].click(); }
        ]
      },
      dropDownSelector
    ];
  };
});
