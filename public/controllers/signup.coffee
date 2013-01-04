window.ctrlSignup = ($scope, $http) ->

  $scope.username = ''
  $scope.password = ''

  $scope.signup = ->
    backend.createUser $http, 'locke', $scope.username, $scope.password, (err) ->
      if err
        $scope.error = err
      else
        backend.sendValidation $http, 'locke', $scope.username, (err) ->
          if err
            $scope.error = err
          else
            humane.log 'User created. Please go to your inbox and follow the instructions before proceeding', ->
              window.location = "#/login"
