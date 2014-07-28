module.exports.addAdminNavigation = Route.addAdminNavigations plugin

module.exports.init = (app, middleware, ignored, callback) ->
  Route.templateAdmin app, middleware, plugin.adminPage.route
  initSockets()
  callback()