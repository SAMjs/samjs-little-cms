samjs = require "./samjs.coffee"
if samjs.auth.authenticated
  samjs.auth.logout()
  document.location.reload()
