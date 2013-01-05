window.ctrlLogin = ($scope, $http) ->

  $scope.showApp = false
  $scope.app = ''
  $scope.username = ''
  $scope.password = ''

  $scope.anotherApp = ->
    console.log "other!!!"
    return false

  $scope.login = ->
    app = (if $scope.showApp then $scope.app else 'locke')
    backend.login $http, app, $scope.username, $scope.password, (err) ->
      if err
        $scope.error = err
        $scope.$apply()
      else
        window.location = if app == 'locke' then "#/apps" else "#/app"
