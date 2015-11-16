"use strict";

define("@{type.name}/@{id}/theme-defaults/utils", function () {
  return function (shortcuts, theme) {
    theme.utils = {
      blurFocus: function () { $("*:focus").blur(); },
      getTopOffset: function (element) { return $(element).offset().top - theme.utils.getHeaderHeight(); },
      getHeaderHeight: function () { return $("#header-menu").height(); },

      scroll: {
        verticalPages: function (factor) {
          var element = theme.dialogs.getOpened().parent();
          var elementHeight;
          if (element.length) {
            elementHeight = element.parent().height();
            element = element[0];
          } else {
            element = document.body;
            elementHeight = window.innerHeight - theme.utils.getHeaderHeight();
            document.documentElement.scrollTop += elementHeight * factor;
          }
          return element.scrollTop += elementHeight * factor;
        },
        verticalAbsolute: function (percentage) {
          var element = theme.dialogs.getOpened().parent();
          var value;
          if (element.length) {
            value = percentage * (element.children()[0].offsetHeight - element.height());
            element = element[0];
          } else {
            element = document.body;
            value = percentage * (document.body.offsetHeight - window.innerHeight);
            document.documentElement.scrollTop = value;
          }
          return element.scrollTop = value;
        },
        elementIntoView: function (element) {
          var maxOffsetTop;
          if (element != null) {
            if (typeof element.scrollIntoViewIfNeeded === "function") {
              element.scrollIntoViewIfNeeded();
            } else {
              element.scrollIntoView(true);
            }
            // check offset from visible top (with 10px margin)
            maxOffsetTop = theme.utils.getTopOffset(element) - 10;
            // if viewport is too low, move higher
            if (document.body.scrollTop > maxOffsetTop) { document.body.scrollTop = maxOffsetTop; }
            if (document.documentElement.scrollTop > maxOffsetTop) {
              document.documentElement.scrollTop = maxOffsetTop;
            }
          }
        }
      },

      navPills: {
        next: function ($pills) {
          var isNext = $pills.last().hasClass("active");
          var pills = $pills.toArray();
          var $current, link;
          for (var i = 0; i < pills.length; i++) {
            $current = $(pills[i]);
            if (isNext) {
              link = $current.find(">a")[0];
              if (link != null) { return link.click(); }
            } else {
              isNext = $current.hasClass("active");
            }
          }
        },
        prev: function ($pills) {
          var isNext = $pills.first().hasClass("active");
          var pills = $pills.toArray();
          var $current, link;
          for (var i = pills.length - 1; i >= 0; i--) {
            $current = $(pills[i]);
            if (isNext) {
              link = $current.find(">a")[0];
              if (link != null) { return link.click(); }
            } else {
              isNext = $current.hasClass("active");
            }
          }
        }
      },

      formElements: {
        getVisible: function () { return $(".form-control,input,.btn").not("button,[disabled],:hidden,.hidden *"); },
        getRelativeToFocused: function (step) {
          if (step == null) { step = 1; }
          var $formEl = theme.utils.formElements.getVisible();
          if (!$formEl.length) { return null; }
          var focusEl = $formEl.filter(":focus")[0];
          // find index of current focused element
          var i = focusEl != null ? $formEl.toArray().indexOf(focusEl) : step > 0 ? -1 : 0;
          // add step value
          i += step;
          // normalize index
          while (i < 0) { i += $formEl.length; }
          while (i >= $formEl.length) { i -= $formEl.length; }
          // return element
          return $formEl.eq(i);
        }
      }
    };
  };
});
