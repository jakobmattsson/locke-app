_ = require 'underscore'
store = require 'store'
nameify = require 'nameify'
jsonrpc = require 'jsonrpc-http-browser-client'

newArray = (args...) -> args

humane.clickToClose = true
humane.timeout = 3000



module = angular.module('lockeapp', [])




# Backend
# =============================================================================

module.factory 'backend', newArray '$rootScope', '$timeout', '$location', ($rootScope, $timeout, $location) ->

  locke = jsonrpc.construct
    endpoint: if $location.host() == 'localapi.localhost' then 'http://localhost:6002' else 'https://locke.herokuapp.com'
    jQuery: jQuery

  methods = [
    'createUser'
    'authPassword'
    'authToken'
    'createApp'
    'getApps'
    'closeSession'
    'closeSessions'
    'deleteUser'
    'updatePassword'
    'deleteApp'
    'sendPasswordReset'
    'resetPassword'
    'sendValidation'
    'validateUser'
  ]

  preload = {
    createApp: ['email', 'token']
    getApps: ['email', 'token']
    updatePassword: ['email', 'app']
    deleteApp: ['email']
    closeSession: ['email', 'token', 'app']
    closeSessions: ['email', 'app']
  }

  lockeDefaults = (method, params, callback) ->
    p = preload[method] ? []
    obj = store.get('auth') ? {}
    defaults = _.pick(obj, p)

    locke method, _.extend({}, defaults, params), (err, res) ->
      callback(err, res) if callback
      $rootScope.$apply()

  resultObject = methods.reduce (acc, method) ->
    acc[method] = (args, callback) ->
      lockeDefaults(method, args, callback)
    acc
  , {}

  resultObject.whoami = -> store.get('auth')?.email

  resultObject.logout = (callback) ->
    store.remove('auth')
    lockeDefaults('closeSession', {}, callback)

  resultObject.login = (app, username, password, callback) ->
    if !username || !password
      return $timeout -> callback('Please enter your login details')

    lockeDefaults 'authPassword', {
      app: app,
      email: username,
      password: password
      secondsToLive: 86400
    }, (err, data) ->
      return callback('Invalid username') if err? && err.data?.match(/^There is no user/)
      return callback(err.data?.toString()) if err?

      store.set 'auth', { app: app, email: username, token: data.token }
      callback()

  resultObject



# Views and Routing
# =============================================================================

getView = (name) ->
  matches = _(document.getElementsByTagName('script')).toArray().filter (x) ->
    x.getAttribute("data-path") == name

  if matches.length != 1
    throw "fail"

  matches[0].innerHTML

exports.defCtrl = (path, template, resolver, controller) ->
  if !controller?
    controller = resolver
    resolver = null

  module.config ($routeProvider) ->
    $routeProvider
    .when path,
      # templateUrl: template
      template: getView(template)
      controller: controller
      resolve: resolver

module.config ($routeProvider) ->
  $routeProvider.otherwise { redirectTo: '/login' }
