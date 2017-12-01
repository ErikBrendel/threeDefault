path = require 'path'
webpack = require 'webpack'

production = process.env.NODE_DEV is 'production'

if production
  console.log 'Running in production mode. Generating minimized files.\n'
else
  console.log 'Running in development mode mode. Keeping source files clean.\n'

config =
  entry:
    main: 'main'
  output:
    path: path.resolve('dist/bundle')
    publicPath: '/bundle/'
    filename: '[name].js'
    chunkFilename: '[name].chunk.js'
  module: rules: [
    {
      test: /\.coffee?$/
      exclude: /node_modules/
      loader: 'coffee-loader'
    }
    {
      resource:
        test: /\.json$/
        include: path.resolve('data')
      loader: 'bundle-loader?name=[name]&lazy'
    }
  ]
  resolve:
    extensions: [
      '.js'
      '.coffee'
      '.json'
    ]
    symlinks: false
    modules: [
      path.resolve('node_modules')
      path.resolve('src/client')
    ]
  devtool: 'source-map' if not production,
  plugins: []

if production
  config.plugins.push new webpack.optimize.UglifyJsPlugin
    compress: true
    mangle: true
    comments: false
    sourceMap: false

module.exports = config
