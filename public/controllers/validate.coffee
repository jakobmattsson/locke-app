window.ctrlValidate = ($scope, $routeParams, $http) ->

  $scope.validate = ->
    backend.validateUser $http, $routeParams.app, $routeParams.email, $routeParams.token, (err) ->
      if err
        $scope.error = err
      else
        humane.log 'You have now been validated!', ->
          window.location = "#/login"
