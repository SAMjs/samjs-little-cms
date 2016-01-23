require "./index.styl"

if process.env.NODE_ENV != "production"
  require ("./login/samjs.coffee")

router = require "./router.coffee"

router.add /login/, -> require.ensure ["./login/login.coffee"], (require) ->
  require "./login/login.coffee"
router.add /logout/, -> require.ensure ["./login/logout.coffee"], (require) ->
  require "./login/logout.coffee"
router.check().listen()
