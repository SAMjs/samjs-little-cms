require "./index.styl"

if process.env.NODE_ENV != "production"
  require ("./login/samjs.coffee")

router = require "./router.coffee"

#Vue = require "./Vue.coffee"
#Vue.use(Router)
#router = new Router(history: true)
#router.map
#  "/": component: {}
#router.start(require("./app.vue"),"#app")
impressum = document.getElementById "impressum"
main1 = document.getElementById "main"
main2 = document.getElementById "main2"
setState = (isImpressum) ->
  impressum.style.cssText = if isImpressum then "" else "display: none"
  main1.style.cssText = if isImpressum then "display: none" else ""
  main2.style.cssText = if isImpressum then "display: none" else ""
router.add /impressum/, -> setState(true)
router.add /login/, -> require.ensure ["./login/login.coffee"], (require) ->
  require "./login/login.coffee"
router.add /logout/, -> require.ensure ["./login/logout.coffee"], (require) ->
  require "./login/logout.coffee"
router.add -> setState(false)
router.check().listen()
