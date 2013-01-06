require('application').defCtrl '/signup', '/views/signup.html', ($scope, $location, backend) ->

  $scope.username = ''
  $scope.password = ''

  $scope.signup = ->
    username = $scope.username
    password = $scope.password

    backend.createUser {
      app: 'locke'
      email: username
      password: password
    }, (err) ->
      if err?
        $scope.error = if err.data? then err.data else err
        return

      backend.sendValidation {
        app: 'locke'
        email: username
      }, (err) ->
        if err?
          $scope.error = err
          return

        backend.login 'locke', username, password, (err) ->
          # hantera err
          console.log err
          $location.path "/apps"
