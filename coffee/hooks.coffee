module.exports.addAdminNavigation = Route.addAdminNavigations plugin

module.exports.init = (data, callback) ->
  Route.templateAdmin data.app, data.middleware, plugin.adminPage.route
  initSockets()
  callback()