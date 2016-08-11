pug = require "pug"
fs = require "fs"
path = require "#{__dirname}/path"
module.exports = (samjs) ->
  indexIn = path("./app/index.pug")
  indexOut = path("./app_build/index.html")
  return {
    name: "markdownFiles"
    db: "files"
    cwd: path("./app/")
    files: [
      "main.md"
    ]
    read: ["root"]
    write: ["root"]
    afterSet: (obj) ->
      html = pug.renderFile(indexIn)
      return new samjs.Promise (resolve,reject) ->
        fs.writeFile indexOut, html, (err) ->
          return reject(err) if err
          resolve(obj)
}
