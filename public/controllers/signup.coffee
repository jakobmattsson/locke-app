require('application').defCtrl '/signup', '/views/signup.html', ($scope, $location, backend) ->

  $scope.username = ''
  $scope.password = ''

  $scope.signup = ->
    backend.createUser 'locke', $scope.username, $scope.password, (err) ->
      if err
        $scope.error = err
      else
        backend.sendValidation 'locke', $scope.username, (err) ->
          if err
            $scope.error = err
          else
            humane.log 'User created. Please go to your inbox and follow the instructions before proceeding', ->
              $location.path "/login"
