store = require('store')

exports.connect = (module, lockeClient) ->

  ## Basic auth helper
  ## =================
  makeBaseAuth = (user, pass) -> 'Basic ' + btoa(user + ':' + pass)
  lockeBaseUrl = if window.location.hostname == 'localapi.localhost' then 'http://localhost:6002' else 'https://locke.herokuapp.com'
  locke = lockeClient.connectAppWithJQuery 'locke', lockeBaseUrl, jQuery

  req = ($http, path, data) ->
    qs = Object.keys(data).map (x) ->
      encodeURIComponent(x) + '=' + encodeURIComponent(data[x])
    .join('&')
    $http.jsonp lockeBaseUrl + path + '?callback=JSON_CALLBACK&' + qs

  internalLogout = ->
    store.remove('auth')
    window.location = '#/login'


  ## Public API
  ## ==========
  createUser: ($http, app, email, password, callback) ->
    req($http, '/createUser', { app: app, email: email, password: password }).success (res) ->
      if res.error?
        callback(res.error)
      else
        callback(null, res.result)
    .error (res) ->
      callback('fail', null)

  createApp: ($http, app, callback) ->
    req($http, '/createApp', { email: store.get('auth')?.username, token: store.get('auth')?.password, app: app }).success (res) ->
      # hantera visa fel annorlunda (tex att appen finns )
      if res.status == 'App name is already in use'
        callback(res.status)
      else if res.status != 'OK'
        internalLogout()
      else
        callback(null, res)
    .error (res) ->
      internalLogout()

  getApps: ($http, callback) ->
    req($http, '/getApps', { email: store.get('auth')?.username, token: store.get('auth')?.password }).success (res) ->
      if res.error?
        internalLogout()
      else
        callback(null, res.result)
    .error (res) ->
      internalLogout()

  updatePassword: ($http, password, newPassword, callback) ->
    req($http, '/updatePassword', { app: 'locke', email: store.get('auth')?.username, password: password, newPassword: newPassword }).success (res) ->
      if res.error?
        internalLogout()
      else
        callback(res.result)
    .error (res) ->
      internalLogout()

  deleteApp: ($http, password, app, callback) ->
    req($http, '/deleteApp', { email: store.get('auth')?.username, password: password, app: app }).success (res) ->
      if res.error?
        callback(res.error)
      else
        callback(null, res.result)
    .error (res) ->
      callback('fail', null)

  sendPasswordReset: ($http, app, email, callback) ->
    req($http, '/sendPasswordReset', { app: app, email: email }).success (res) ->
      if res.error?
        callback(res.error)
      else
        callback(null, res.result)
    .error (res) ->
      callback('fail', null)

  resetPassword: ($http, app, email, resetToken, newPassword, callback) ->
    req($http, '/resetPassword', { app: app, email: email, resetToken: resetToken, newPassword: newPassword }).success (res) ->
      if res.error?
        callback(res.error)
      else
        callback(null, res.result)
    .error (res) ->
      callback('fail', null)

  sendValidation: ($http, app, email, callback) ->
    req($http, '/sendValidation', { app: app, email: email }).success (res) ->
      if res.error?
        callback(res.error)
      else
        callback(null, res.result)
    .error (res) ->
      callback('fail', null)

  validateUser: ($http, app, email, validationToken, callback) ->
    req($http, '/validateUser', { app: app, email: email, validationToken: validationToken }).success (res) ->
      if res.error?
        callback(res.error)
      else
        callback(null, res.result)
    .error (res) ->
      callback('fail', null)

  logout: ($http)->
    store.remove('auth')
    req $http, '/closeSession',
      app: 'locke'
      email: store.get('auth')?.username
      token: store.get('auth')?.password

  login: ($http, username, password, callback) ->
    if !username || !password
      setTimeout ->
        callback('Please enter your login details')
      , 1
      return

    locke.authPassword username, password, 86400, (err, data) ->
      return callback('Invalid username') if err? && err.data?.match(/^There is no user/)
      return callback(err.data?.toString()) if err?
      return callback('Email not confirmed. Check your inbox.') if !data.validated

      store.set 'auth', { username: username, password: data.token }
      callback()
