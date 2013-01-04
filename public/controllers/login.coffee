window.ctrlLogin = ($scope, $http) ->

  $scope.username = ''
  $scope.password = ''

  $scope.login = ->
    backend.login $http, $scope.username, $scope.password, (err) ->
      if err
        $scope.error = err
        $scope.$apply()
      else
        window.location = "#/apps"
