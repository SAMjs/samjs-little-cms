unless process.env.NODE_ENV == "production"
  require "coffee-script/register"
samjs = require "samjs"
sendfile = require "koa-sendfile"
serve = require "koa-static"
pug = require "pug"
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
  pug.renderFile("#{p.app}/index.pug")
fs.writeFileSync "#{p.app_build}/install.html",
  pug.renderFile("#{p.app}/install/install.pug")

koa = require("koa")()
koa.use serve(p.app_build,index:false,maxage: maxage)
koa.use serve(p.resources,hidden:true)
koa.use ->
  yield sendfile(@, index)

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


## IF IN DEV MODE
if process.env.NODE_ENV != "production"
  server.listen(port)
  fs.watch p.app_build, {persistent:false}, ->
    if samjs.io?
      samjs.io.sockets.emit "reload"
else
  server.listen(port,"localhost")
