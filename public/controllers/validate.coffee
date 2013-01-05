require('application').defCtrl '/validate/:app/:email/:token', '/views/validate.html', ($scope, $routeParams, $lcoation, backend) ->

  $scope.validate = ->
    backend.validateUser $routeParams.app, $routeParams.email, $routeParams.token, (err) ->
      if err
        $scope.error = err
      else
        humane.log 'You have now been validated!', ->
          $location.path "/login"
