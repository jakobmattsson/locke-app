require('application').defCtrl '/forgot', '/views/forgot.html', ($scope, $location, backend) ->

  $scope.username = ''

  $scope.sendReset = ->
    backend.sendPasswordReset 'locke', $scope.username, (err) ->
      if err
        $scope.error = err
      else
        humane.log 'Instructions to reset your password has been sent to you', ->
          $location.path '/login'
