require('application').defCtrl '/apps', '/views/apps.html', ($scope, backend) ->

  backend.getApps {}, (err, res) ->
    apps = Object.keys(res.apps)
    $scope.apps = apps.map (app) ->
      name: app
      userCount: res.apps[app].userCount

  $scope.logout = ->
    backend.logout()

  $scope.deleteAccount = ->
    humane.log("Deleting accounts is not supported at the moment")

  $scope.changePassword = ->
    smoke.prompt 'Enter your current password', (currentPassword) ->
      smoke.prompt 'Enter your new password', (newPassword) ->
        backend.updatePassword currentPassword, newPassword, (err, res) ->
          humane.log(if err? then err.status else 'Password updated')

  $scope.createApp = ->
    smoke.prompt 'Enter a name for the new app', (name) ->
      return if !name
      backend.createApp name, (err, res) ->
        if err
          humane.log err
        else
          $scope.apps.push({ name: name, userCount: 0 })

  $scope.deleteApp = (app) ->
    counts = $scope.apps.filter((x) -> x.name == app.name).map (x) -> x.userCount
    if counts.length == 0
      return

    if counts[0] > 0
      humane.log("Deleting apps with users is not supported at the moment")
      return

    smoke.prompt 'Repeat your password in order to delete ' + app.name, (password) ->
      return if !password
      backend.deleteApp password, app.name, (err, res) ->
        if err
          humane.log('Failed to delete app: ' + err)
        else
          $scope.apps = $scope.apps.filter((x) -> x.name != app.name)
