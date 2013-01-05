require('application').defCtrl '/reset/:app/:email/:token', '/views/reset.html', ($scope, $location, $routeParams, backend) ->

  $scope.reset = ->
    backend.resetPassword $routeParams.app, $routeParams.email, $routeParams.token, $scope.newPassword, (err) ->
      if err
        $scope.error = err
      else
        humane.log 'Password successfully updated', ->
          $location.path "/login"
