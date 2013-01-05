window.ctrlApp = ($scope, $http) ->

  $scope.logout = ->
    backend.logout($http)

  $scope.deleteAccount = ->
    humane.log("Deleting accounts is not supported at the moment")

  $scope.changePassword = ->
    smoke.prompt 'Enter your current password', (currentPassword) ->
      smoke.prompt 'Enter your new password', (newPassword) ->
        backend.updatePassword $http, currentPassword, newPassword, (err, res) ->
          humane.log(if err? then err.status else 'Password updated')

  $scope.sendValidation = ->
    humane.log("Send validation")

