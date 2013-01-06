require('application').defCtrl '/login', '/views/login.html', {

  mustBeLoggedOut: ($timeout, $q, backend, $location) ->
    deferred = $q.defer()
    if backend.whoami()?
      $location.path('/apps')  ## apps eller app - vilken är startsidan? Bore nog ha en enda adress
    $timeout ->
      deferred.resolve(null)
    deferred.promise



}, ($scope, $location, backend) ->

  $scope.showApp = false
  $scope.app = ''
  $scope.username = ''
  $scope.password = ''

  $scope.login = ->
    app = (if $scope.showApp then $scope.app else 'locke')
    backend.login app, $scope.username, $scope.password, (err) ->
      if err
        $scope.error = err
      else
        $location.path(if app == 'locke' then "/apps" else "/app")
