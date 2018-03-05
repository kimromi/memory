import webpack = require('webpack')
import path = require('path')
import nodeExternals = require('webpack-node-externals')

const config: webpack.Configuration = {
  externals: [nodeExternals({
    modulesDir: '../node_modules',
  })],
  entry: path.join(__dirname, 'index.ts'),
  output: {
    path: path.join(__dirname),
    filename: 'index.js',
  },
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: 'ts-loader'
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.ts']
  }
}

module.exports = config
