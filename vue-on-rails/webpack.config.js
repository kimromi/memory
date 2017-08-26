module.exports = {
  context: __dirname + '/frontend/src/',
  entry: {
    js: "./entry.js"
  },
  output: {
    path: __dirname + '/app/assets/javascripts/',
    filename: "app.js"
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
  }
}
