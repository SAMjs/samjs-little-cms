unless process.env.NODE_ENV == "production"
  require "coffee-script/register"
samjs = require "samjs"
sendfile = require "koa-sendfile"
serve = require "koa-static"
jade = require "jade"
fs = require "fs"
path = require "#{__dirname}/path"
index = ""
maxage = 0
port = 3000
if process.env.NODE_ENV == "production"
  maxage = 1000*60*60
  port = 9001
p =
  app_build: path("./app_build")
  app: path("./app")
  server: path("./server")
  resources: path("./resources")

fs.writeFileSync "#{p.app_build}/index.html",
  jade.renderFile("#{p.app}/index.jade")
fs.writeFileSync "#{p.app_build}/install.html",
  jade.renderFile("#{p.app}/install/install.jade")

koa = require("koa")()
koa.use serve(p.app_build,index:false,maxage: maxage)
koa.use serve(p.resources)
koa.use ->
  yield sendfile.call(@, index)

server = require("http").createServer(koa.callback())

samjs
.plugins(require("samjs-auth"),require("samjs-files"))
.options(require("#{p.server}/options"))
.configs()
.models(require("#{p.server}/models"))
.startup(server)
samjs.state.onceConfigureOrInstall.then ->
  index = "#{p.app_build}/install.html"

samjs.state.onceStarted.then ->
  index = "#{p.app_build}/index.html"
  if samjs.io?
    samjs.io.sockets.emit "reload"
server.listen(port)

## IF IN DEV MODE
if process.env.NODE_ENV != "production"

  fs.watch p.app_build, {persistent:false}, ->
    if samjs.io?
      samjs.io.sockets.emit "reload"
