fs = require 'fs'
wdSync = require 'wd-sync'

{browser, sync} = wdSync.remote({
  # host: "ondemand.saucelabs.com"
  # port: 80
  # username: "jakobmattsson"
  # accessKey: "<plugin secret here>"
})

browser.on "command", (meth, path) -> console.log(" > \u001b[33m%s\u001b[0m: %s", meth, path)

process.on "uncaughtException", (err) ->
  browser.quit ->
    console.log("FAILED", err)
    process.exit 1

sync ->
  saveScreenshot = (filename) => fs.writeFileSync(filename, @takeScreenshot(), 'base64')
  await = (className) => @waitForCondition("document.getElementsByClassName('#{className}').length > 0", 3000)

  enhances = ['clickElement', 'type', 'text']

  enhances.forEach (name) =>
    @[name] = do =>
      org = @[name]
      (arg, rest...) =>
        if typeof arg == 'string'
          org.apply(@, [@elementByCss(arg)].concat(rest))
        else
          org.apply(@, arguments)

  @init {
    #browserName: "chrome" # chrome|firefox|htmlunit|internet explorer|iphone
    # # version: '22.0'
    #platform: 'mac'
    # platform: "WINDOWS" # WINDOWS|XP|VISTA|MAC|LINUX|UNIX
    # tags: ["examples"]
    #name: "Test 5"
  }

  @await = await

  require('./a1').defTest.call(@, { domain: 'http://localhost:4000' })

  @quit()
