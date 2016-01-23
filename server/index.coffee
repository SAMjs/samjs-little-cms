require "coffee-script/register"
samjs = require "samjs"
sendfile = require "koa-sendfile"
serve = require "koa-static"
jade = require "jade"
fs = require "fs"
index = ""
maxage = 0
folder = "./app_build"
port = 3000
if process.env.NODE_ENV == "production"
  maxage = 1000*60*60
  folder = "./app_deploy"
  port = 80

fs.writeFileSync "#{folder}/index.html",
  jade.renderFile("./app/index.jade")
fs.writeFileSync "#{folder}/install.html",
  jade.renderFile("./app/install/install.jade")

koa = require("koa")()
koa.use serve(folder,index:false,maxage: maxage)
koa.use serve("./resources")
koa.use ->
  yield sendfile.call(@, index)

server = require("http").createServer(koa.callback())

samjs
.plugins(require("samjs-auth"),require("samjs-files"))
.options(require "./options")
.configs()
.models(require("./models")(folder))
.startup(server)
samjs.state.onceConfigureOrInstall.then ->
  index = "#{folder}/install.html"

samjs.state.onceStarted.then ->
  index = "#{folder}/index.html"
  if samjs.io?
    samjs.io.sockets.emit "reload"
server.listen(port)

## IF IN DEV MODE
if process.env.NODE_ENV != "production"

  fs.watch folder, {persistent:false}, ->
    if samjs.io?
      samjs.io.sockets.emit "reload"
