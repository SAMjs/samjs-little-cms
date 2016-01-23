require "./materialize.config.scss"
samjs = require("samjs-client")()
samjs.plugins(require("samjs-auth-client"))
samjs.io.socket.on "reload", () ->
  console.log "reloading"
  document.location.reload()
Vue = require "vue"
install = new Vue(require("./install.vue")).$mount("#install")
install.samjs = samjs
