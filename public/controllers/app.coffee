require('application').defCtrl '/app', '/views/app.html', ($scope, backend) ->

  $scope.logout = ->
    backend.logout()

  $scope.deleteAccount = ->
    humane.log("Deleting accounts is not supported at the moment")

  $scope.changePassword = ->
    smoke.prompt 'Enter your current password', (currentPassword) ->
      smoke.prompt 'Enter your new password', (newPassword) ->
        backend.updatePassword currentPassword, newPassword, (err, res) ->
          humane.log(if err? then err.status else 'Password updated')

  $scope.sendValidation = ->
    humane.log("Send validation")
