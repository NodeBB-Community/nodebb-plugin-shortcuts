module.exports =
  templateAdmin: (router, middleware, route, obj = {}, template = "admin#{route}") ->
    this.get router, middleware.admin.buildHeader, "/admin#{route}", (req, res, ignored) ->
      res.render template, obj
  template: (router, middleware, route, obj = {}, template = route.substring 1) ->
    this.get router, middleware.admin.buildHeader, route, (req, res, ignored) ->
      res.render template, obj
  addAdminNavigations: (plugins...) ->
    (header, cb) ->
      for plugin in plugins
        header.plugins.push
          name: plugin.adminPage.name
          icon: plugin.adminPage.icon
          route: plugin.adminPage.route
      cb null, header
  get: (router, middleware, url, cb, cbApi = cb) ->
    router.get url, middleware, cb
    router.get "/api#{url}", cbApi if cbApi?
  post: (router, middleware, url, cb, cbApi = cb) ->
    router.post url, middleware, cb
    router.post "/api#{url}", cbApi if cbApi?