define ->
  ->
    $(document).ready ->
      run = ->
        if !socket?
          setTimeout run, 50
          return;

        socket.emit 'modules.shortcutsCfg', null, (err, data) ->
          if err?
            console.error err
            return;
          actions = $ '#shortcuts-actions'
          for sectionName, section of data.descriptions
            sectionString = "<div class='col-lg-4 col-sm-6 col-xs-12'><h3>#{section._title}</h3>"
            for key, description of section when key != '_title'
              fullKey = "actions.#{sectionName}.#{key.split('_').join '.'}"
              sectionString += "<span>#{description}: </span>" +
                "<div data-key='#{fullKey}' data-attributes='{\"type\":\"key\"}'></div><br>"
            actions.append sectionString += "</div>"
          # split therefore IDE doesn't cry anymore
          require ['../../' + 'plugins/nodebb-plugin-shortcuts/services/admin/Settings'], (Settings) ->
            Settings.init 'shortcuts'
      run()