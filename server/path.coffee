path = require "path"
absolutePath = path.resolve(__dirname,"..")
module.exports = (relativePath) ->
  return path.resolve(absolutePath,relativePath)
