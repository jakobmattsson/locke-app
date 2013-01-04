window.ctrlReset = ($scope, $routeParams, $http) ->

  $scope.reset = ->
    backend.resetPassword $http, $routeParams.app, $routeParams.email, $routeParams.token, $scope.newPassword, (err) ->
      if err
        $scope.error = err
      else
        humane.log 'Password successfully updated', ->
          window.location = "#/login"
