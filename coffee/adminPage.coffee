#constants = Object.freeze
#  'name': "Shortcuts"
#  'admin':
#    'route': '/plugins/shortcuts'
#    'icon': 'fa-keyboard-o'
#  'template': 'admin/plugins/shortcuts'
#
#renderAdminPage = (req, res, ignored) ->
#  res.render constants.template, {}
#
#initAdminRoute = (app, middleware) ->
#  appGet app, "/admin#{constants.admin.route}", middleware.admin.buildHeader, renderAdminPage
#
#module.exports.adminBuild = (header, cb) ->
#  header.plugins.push
#    route: constants.admin.route
#    icon: constants.admin.icon
#    name: constants.name
#  cb null, header