require "./materialize.config.scss"
samjs = require "./samjs.coffee"
Vue = require "vue"
if process.env.NODE_ENV != "production"
  Vue.debug = true
login = new Vue(require("./login.vue"))
addEdits = ->
  mains = document.getElementsByClassName("main")
  EditButton = require "./editButton.vue"
  edit = new Vue(require "./edit.vue")
  for main in mains
    editButton = new Vue(EditButton)
    editButton.edit = edit
    editButton.$appendTo(main)
    editButton.filename = main.id
unless samjs.auth.authenticated
  samjs.auth.login()
  .catch (e) ->
    login.open()
  .then addEdits
  .catch ->
else
  addEdits()
