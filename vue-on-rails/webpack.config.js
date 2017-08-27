const ManifestPlugin = require('webpack-manifest-plugin');

module.exports = {
  context: __dirname + '/frontend/src/',
  entry: {
    app: "./entry.js"
  },
  output: {
    path: __dirname + '/app/assets/javascripts/',
    filename: "[name].js"
  },
  resolve: {
    alias: {
      'vue$': 'vue/dist/vue.esm.js'
    }
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader'
      }
    ]
  },
  plugins: [
    new ManifestPlugin()
  ],
}
