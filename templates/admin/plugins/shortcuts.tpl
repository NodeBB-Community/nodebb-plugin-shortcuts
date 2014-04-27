<h1>Shortcuts</h1>
<hr />

<form id="settings_shortcuts">
  <div class="row">
    <p>
      <h2>Stuff</h2>
      Color of selection-shadow: <input data-key="selectionColor" type="color" /><br>
      Delay between repeating action while key hold down: <input data-key="timeSpace" type="number" step="50" style="width:50px;" /><span style="font-family:monospace;">ms</span>
    </p>
    <p>
      <h2>Actions</h2>
      <p id="shortcuts-actions"></p>
    </p>
  </div>
  <button class="btn btn-lg btn-warning" id="reset">Reset</button>
  <button class="btn btn-lg btn-primary" id="save">Save</button>
</form>

<script>
  function init() {
    if (!socket || !app) {
      setTimeout(run, 50);
      return;
    }
    socket.emit('modules.shortcutsCfg', null, function (err, data) {
      if (err) {
        return app.alert({
          alert_id: 'config_status',
          timeout: 2500,
          title: 'Settings Not Found',
          message: 'Your plugin-settings have not been found. Please try re-enabling this plugin.',
          type: 'danger'
        });
      }
      var actions = $('#shortcuts-actions');
      var addFieldsByDescriptions = function(descriptions) {
        for (var sectionName in descriptions) {
          if (sectionName[0] === '_')
            continue;
          var section = descriptions[sectionName];
          var sectionString = "<div class='col-lg-4 col-sm-6 col-xs-12'><h3>" + section._title + "</h3>";
          for (var key in section) {
            if (key === '_title')
              continue;
            var description = section[key];
            var fullKey = "actions." + sectionName + '.' + key.split('_').join('.');
            sectionString += "<span>" + description + ": </span>" +
              "<div data-key='" + fullKey + "' data-attributes='{\"type\":\"key\"}'></div><br>";
          }
          actions.append(sectionString + "</div>");
        }
      }
      addFieldsByDescriptions(data.descriptions);
      actions.append("<h2 style='clear: both;'>Admin Actions</h2>");
      addFieldsByDescriptions(data.descriptions._admin);
      require(['settings'], function (settings) {
        var wrapper = $('#settings_shortcuts');
        settings.sync('shortcuts', wrapper);
        $('#save').click(function(event) {
          event.preventDefault();
          settings.persist('shortcuts', wrapper, function(){
            socket.emit('modules.shortcutsRefresh');
          });
        });
        $('#reset').click(function(event) {
          event.preventDefault();
          socket.emit('modules.shortcutsDefaults', null, function (err, data) {
            settings.cfg = {"_settings": data};
            settings.helper.initFields('form');
            settings.persist('shortcuts', wrapper, function(){
              socket.emit('modules.shortcutsRefresh');
            });
          });
        });
      });
    });
  }
  init();
</script>