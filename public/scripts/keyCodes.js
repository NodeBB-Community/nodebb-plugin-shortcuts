"use strict";

define("@{type.name}/@{id}/key-codes", function () {
  var mapped = {
    "": 0, "Backspace": 8, "Tab": 9, "Enter": 13, "Escape": 27, "Space": 32, "Left": 37, "Up": 38, "Right": 39,
    "Down": 40, "Insert": 45, "Delete": 46, "=": 187, "-": 189, ".": 190, "/": 191, "[": 219, "\\": 220, "]": 221
  }, inverted = {};

  for (var key in mapped) {
    if (mapped.hasOwnProperty(key)) {
      inverted[mapped[key]] = key;
    }
  }

  return {
    mapped: mapped,
    inverted: inverted,
    questionMark: 63
  };
});
