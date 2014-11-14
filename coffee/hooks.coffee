module.exports.addAdminNavigation = Route.addAdminNavigations plugin

module.exports.init = (data, callback) ->
  Route.templateAdmin data.router, data.middleware, plugin.adminPage.route
  initSockets()
  callback()