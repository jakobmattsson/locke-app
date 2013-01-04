window.ctrlForgot = ($scope, $http) ->

  $scope.username = ''

  $scope.sendReset = ->
    backend.sendPasswordReset $http, 'locke', $scope.username, (err) ->
      if err
        $scope.error = err
      else
        humane.log 'Instructions to reset your password has been sent to you', ->
          window.location = "#/login"
