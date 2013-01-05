lockeClient = require('modules/lockeClient')

module = angular.module('lockeapp', [])
window.backend = require('lib/backend').connect(module, lockeClient)

module.config ($routeProvider) ->
  $routeProvider
  .when '/login'
    templateUrl: '/views/login.html'
    controller: ctrlLogin
  .when '/signup'
    templateUrl: '/views/signup.html'
    controller: ctrlSignup
  .when '/forgot'
    templateUrl: '/views/forgot.html'
    controller: ctrlForgot
  .when '/validate/:app/:email/:token'
    templateUrl: '/views/validate.html'
    controller: ctrlValidate
  .when '/reset/:app/:email/:token'
    templateUrl: '/views/reset.html'
    controller: ctrlReset
  .when '/app'
    templateUrl: '/views/app.html'
    controller: ctrlApp
  .when '/apps'
    templateUrl: '/views/apps.html'
    controller: ctrlApps
  .otherwise
    redirectTo: '/login'


humane.clickToClose = true
humane.timeout = 5000


# resend validation email
