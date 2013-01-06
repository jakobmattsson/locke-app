assert = require 'assert'

genUsername = do ->
  counter = 0
  -> "specuser-#{new Date().getTime()}-#{++counter}@gmail.com"

exports.defTest = ({ domain }) ->

  ##
  ## Attempting to login with an invalid username
  ##

  @get domain

  @await 'spec-title'
  assert.equal @text('.spec-title'), 'Login to Locke'

  @type '.spec-username', 'some-invalid-user'
  @type '.spec-password', 'some-invalid-password'
  @clickElement '.spec-login'

  @await 'spec-error'
  assert.equal @text('.spec-error'), 'Invalid username'



  ##
  ## Signing up a user erroneously
  ##

  @get domain
  @await 'spec-title'

  @clickElement '.spec-signup'
  @await 'spec-title-signup'
  assert.equal @text('.spec-title-signup'), 'Sign up for a Locke-account'

  user1 = genUsername()

  @type '.spec-username', user1
  @type '.spec-password', '123'
  @clickElement '.spec-signup'

  @await 'spec-error'
  assert.equal @text('.spec-error'), 'Password too short - use at least 6 characters'



  ##
  ## Signing up a user successfully
  ##

  @get domain
  @await 'spec-title'

  @clickElement '.spec-signup'
  @await 'spec-title-signup'
  assert.equal @text('.spec-title-signup'), 'Sign up for a Locke-account'

  user2 = genUsername()

  @type '.spec-username', user2
  @type '.spec-password', 'specpassword'
  @clickElement '.spec-signup'

  @await 'spec-appstitle'
  assert.equal @text('.spec-appstitle'), 'Apps'



  ##
  ## Attempting to go to the login page while logged in
  ##

  currentUrl = @url()
  @get domain

  assert.equal @url(), currentUrl



  ##
  ## Actually loggin out
  ##
  @clickElement '.spec-logout'

  @await 'spec-title'
  assert.equal @text('.spec-title'), 'Login to Locke'



  ##
  ## Attempting to go to the apps page while logged out
  ##

  currentUrl = @url()
  @get "#{domain}/#/apps"
  assert.equal @url(), currentUrl



  ##
  ## Attempting to logging in with a non-existing user
  ##  
  @get domain

  @type '.spec-username', user1
  @type '.spec-password', '123'
  @clickElement '.spec-login'

  @await 'spec-error'
  assert.equal @text('.spec-error'), 'Invalid username'



  ##
  ## Attempting to logging in with an incorrect password
  ##

  @get domain

  @type '.spec-username', user2
  @type '.spec-password', 'some-invalid-password'
  @clickElement '.spec-login'

  @await 'spec-error'
  assert.equal @text('.spec-error'), 'Incorrect password'



  ##
  ## Attempting to logging in with the correct password
  ##

  @get domain

  @type '.spec-username', user2
  @type '.spec-password', 'specpassword'
  @clickElement '.spec-login'

  @await 'spec-appstitle'
  assert.equal @text('.spec-appstitle'), 'Apps'












  # @clickElement '.spec-logout'
  # @get domain
  # 
  # @await 'spec-title'
  # assert.equal @text('.spec-title'), 'Login to Locke'
  # 
  # @type '.spec-username', 'jakob.mattsson@gmail.com'
  # @type '.spec-password', 'sixten97'
  # @clickElement '.spec-login'
  # 
  # @await 'spec-appstitle'
  # 
  # assert.equal @text('.spec-appstitle'), 'Apps'
  # assert.equal @elementsByCss('.spec-appstable tr').length, 4
