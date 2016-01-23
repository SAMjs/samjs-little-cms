samjs = require("samjs-client")()
samjs.plugins(require("samjs-auth-client"), require("samjs-files-client"))
samjs.io.socket.on "reload", () ->
  console.log "reloading"
  document.location.reload()
module.exports = samjs
