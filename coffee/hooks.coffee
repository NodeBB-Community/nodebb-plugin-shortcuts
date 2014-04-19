#module.exports.adminBuild = Route.addPlugin plugin

module.exports.appLoad = (app, middleware, ignored) ->
#  Route.templateAdmin app, middleware, plugin.adminPage.route
  initSockets()

module.exports.configDefaults = (id) ->
  cfg.setOnEmpty() if id == plugin.id