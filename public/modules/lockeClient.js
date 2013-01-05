(function() {
  var nameify = require('nameify');
  var jsonrpc = require('jsonrpc-http-browser-client');

  exports.connectAppWithJQuery = function(domain, jQuery) {
    return nameify.byPosition(jsonrpc.construct({
      endpoint: domain,
      jQuery: jQuery
    }), {
      createUser: ['app', 'email', 'password'],
      authPassword: ['app', 'email', 'password', 'secondsToLive'],
      authToken: ['app', 'email', 'token'],
      createApp: ['email', 'token', 'app'],
      getApps: ['email', 'token'],
      closeSession: ['app', 'email', 'token'],
      closeSessions: ['app', 'email', 'password'],
      deleteUser: ['app', 'email', 'password'],
      updatePassword: ['app', 'email', 'password', 'newPassword'],
      deleteApp: ['email', 'password', 'app'],
      sendPasswordReset: ['app', 'email'],
      resetPassword: ['app', 'email', 'resetToken', 'newPassword'],
      sendValidation: ['app', 'email'],
      validateUser: ['app', 'email', 'validationToken']
    });
  };
}).call(this);
