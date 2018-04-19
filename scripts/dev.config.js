var path = require('path');
var webpack = require("webpack");
var cfg = {
  devtool: 'source-map',
  module: {
    rules: [
      { test: /\.coffee$/, use: "coffee-loader"},
      { test: /\.(xml|html|txt|md|glsl|svg)$/, loader: "raw-loader" },
      { test: /\.(less)$/, use: ['style-loader','css-loader','less-loader'] },
       { test: /\.(css)$/, use: ['style-loader','css-loader'] },
      { test: /\.(woff|woff2|eot|ttf|png)$/,loader: 'url-loader?limit=65000' }
    ]
  },
  entry: { 
    main: "./client/main.coffee"
  },
  resolve: {
    // "modules": [__dirname+"/node_modules"],
  },
  output: {
    path: path.join(__dirname,'..','/public/'),
    publicPath: '/public/',
    filename: "[name].js"
  },
  devServer: {
    port: 4444,
    contentBase: path.join(__dirname,'..','/public/')
  }
}
module.exports = cfg;