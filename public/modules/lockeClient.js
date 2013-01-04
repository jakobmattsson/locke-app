(function() {
  var __slice = [].slice;

  exports.argsToQueryString = function(args) {
    return Object.keys(args).map(function(key) {
      return encodeURIComponent(key) + '=' + encodeURIComponent(args[key]);
    }).join('&');
  };

  exports.connectApp = function(app, domain, requestMethod) {
    var makeMethods;
    makeMethods = function(methods) {
      return Object.keys(methods).reduce(function(api, method) {
        api[method] = function() {
          var args, callback, params, _i;
          args = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), callback = arguments[_i++];
          if (methods[method][0] === 'app') {
            args.unshift(app);
          }
          params = methods[method].reduce(function(acc, argName, i) {
            acc[argName] = args[i];
            return acc;
          }, {});
          return requestMethod(domain, method, params, callback);
        };
        return api;
      }, {});
    };
    return makeMethods({
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

  exports.connectAppWithJQuery = function(app, domain, jQuery) {
    return exports.connectApp(app, domain, function(domain, name, args, callback) {
      return jQuery.ajax({
        dataType: 'jsonp',
        cache: true,
        url: domain + '/' + name + '?' + exports.argsToQueryString(args),
        jsonp: 'callback',
        success: function(data) {
          console.log("got back", data)
          if (data.error) {
            callback(data.error);
          } else {
            callback(null, data.result)
          }
        },
        error: function(data) {
          return callback(data);
        }
      });
    });
  };

}).call(this);
