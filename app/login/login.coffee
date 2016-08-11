require "./materialize.config.scss"
samjs = require "./samjs.coffee"
Vue = require "vue"
Vue.use(require("vue-touch"))
if process.env.NODE_ENV != "production"
  Vue.debug = true
login = new Vue(require("./login.vue"))
router = require "../router.coffee"
addEdits = ->
  mains = document.getElementsByClassName("main")
  EditButton = require "./editButton.vue"
  edit = new Vue(require "./edit.vue")
  for main in mains
    editButton = new Vue(EditButton)
    editButton.edit = edit
    editButton.$appendTo(main)
    editButton.filename = main.id
  router.navigate()

unless samjs.auth.authenticated
  samjs.auth.login()
  .catch (e) ->
    login.open()
  .then addEdits
  .catch ->
else
  addEdits()
