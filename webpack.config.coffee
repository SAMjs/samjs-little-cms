webpack = require "webpack"

module.exports =
  entry:
    index: "./app/index.coffee"
    "install": "./app/install/install.coffee"

  output:
    filename: "[name].js"
  module:
    loaders: [
      { test: /\.vue$/, loader: "vue"}
      { test: /\.coffee$/, loader: "coffee"}
      { test: /\.png$/, loader: "url?limit=8192" }
      { test: /\.jpg$/, loader: "url?limit=8192" }
      { test: /\.woff(\d*)\??(\d*)$/, loader: "url?limit=10000&mimetype=application/font-woff" }
      { test: /\.ttf\??(\d*)$/,    loader: "file" }
      { test: /\.eot\??(\d*)$/,    loader: "file" }
      { test: /\.svg\??(\d*)$/,    loader: "file" }
    ]
    postLoaders: [
      { test: /vue-icons/, loader: "callback-loader"}
    ]
  callbackLoader:
    require("vue-icons/icon-loader")(["material-vpn_key","material-person","material-mode_edit","material-save"])
if process.env.NODE_ENV == "production"
  ExtractTextPlugin = require("extract-text-webpack-plugin")
  module.exports.plugins = [
      new webpack.DefinePlugin 'process.env': NODE_ENV: '"production"'
      new webpack.optimize.UglifyJsPlugin compress: warnings: false
      new webpack.optimize.OccurenceOrderPlugin
      new ExtractTextPlugin("[name].css")
    ]
  module.exports.output.path = "./deploy/app_build"
  module.exports.module.loaders.push test: /\.css$/, loader: ExtractTextPlugin.extract("style", "css")
  module.exports.module.loaders.push test: /\.styl$/, loader: ExtractTextPlugin.extract("style", "css!stylus")
  module.exports.module.loaders.push test: /\.scss$/, loader: ExtractTextPlugin.extract("style", "css!sass")
else
  module.exports.devtool = '#source-map'
  module.exports.output.path = "./app_build"
  module.exports.module.loaders.push test: /\.css$/, loader: "style!css"
  module.exports.module.loaders.push test: /\.styl$/, loader: "style!css!stylus"
  module.exports.module.loaders.push test: /\.scss$/, loader: "style!css!sass"
