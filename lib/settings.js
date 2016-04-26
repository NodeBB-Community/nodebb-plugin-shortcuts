"use strict";

var packageJSON = require("../package.json");
var Settings = require.main.require("./src/settings");

/*
 * This file exports a NodeBB Settings Object and a few meta-data of the project.
 *
 * See https://docs.nodebb.org/en/latest/plugins/settings.html for more details on the Settings Object.
 *
 * This file by default gets meta-replaced (thus @{...} gets resolved within the grunt-tasks).
 * It is not recommended to add any more files, rather it is recommended to add additional exports here if needed.
 */

var env = "@{env}", dev = (env === "development");

var defaultSettings = {
  repeatDelay: 50,
  selectionColor: "#ff5500",
  adminActions: {
    acp: {
      home: ["A+#72", "A+S+#72"]
    },
    header: {
      admin: ["A+#65", "A+S+#65"]
    }
  },
  actions: {
    breadcrumb: {up: ["A+#38"]},
    category: {newTopic: ["A+#89", "A+S+#78", "A+#13"]},
    topic: {reply: ["A+#89", "A+S+#78", "A+#13"]},
    navPills: {next: ["#76"], prev: ["#72"]},
    dialog: {confirm: ["#89", "#79", "#90"], cancel: [], close: ["#78", "#67", "#27"]},
    taskbar: {closeAll: ["A+#67", "A+#88"], clickFirst: ["A+#86"], clickLast: ["A+S+#86"]},
    selection: {
      follow: ["#13", "#32"],
      highlight: ["S+#72"],
      area: {next: ["A+#74"], prev: ["A+#75"]},
      item: {next: ["#74", "A+S+#74"], prev: ["#75", "A+S+#75"]}
    },
    body: {
      focus: ["S+#221", "#27"],
      scroll: {pageDown: ["#68"], pageUp: ["#85"], top: ["#84"], bottom: ["#66"]},
      reload: {soft: ["#82"], hard: ["C+#82", "S+#82"]},
      form: {next: ["A+#191"], prev: ["A+S+#191"]}
    },
    composer: {
      send: ["A+#83"],
      discard: ["A+#68", "S+#27"],
      preview: ["A+#80"],
      previewSend: ["C+#13"],
      help: ["A+#72"],
      write: ["A+#87"],
      bold: ["A+#66"],
      italic: ["A+#73"],
      list: ["A+#84"],
      link: ["A+#85"],
      closed: {title: ["A+S+#84"], input: ["#73", "C+#73", "A+S+#73"]}
    },
    header: {
      home: ["A+#72", "A+S+#72"],
      categories: [],
      unread: ["A+#85", "A+S+#85"],
      recent: ["A+#82", "A+S+#82"],
      tags: ["A+#84", "A+S+#84"],
      popular: ["A+#80", "A+S+#80"],
      users: ["A+#83", "A+S+#83"],
      groups: ["A+#71", "A+S+#71"],
      notifications: ["A+#78", "A+S+#78"],
      chats: ["A+#67", "A+S+#67"],
      profile: ["A+#79", "A+S+#79"],
      search: ["#191"]
    }
  }
};

var id = "@{id}";

exports = module.exports = new Settings(id, packageJSON.version, defaultSettings, null, dev, false);

exports.id = id;
exports.Id = "@{Id}";
exports.iD = "@{iD}";
exports.ID = "@{ID}";
exports.dev = dev;
exports.env = env;
exports.pkg = packageJSON;
