jade = require "jade"
fs = require "fs"
module.exports = (folder) -> (samjs) -> return {
  name: "markdownFiles"
  db: "files"
  files: [
    "./app/main.md"
  ]
  read: ["root"]
  write: ["root"]
  afterSet: (obj) ->
    html = jade.renderFile("./app/index.jade")
    return new samjs.Promise (resolve,reject) ->
      fs.writeFile "#{folder}/index.html",html, (err) ->
        return reject(err) if err
        resolve(obj)
}
