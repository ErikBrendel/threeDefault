app = require './app'
http = require 'http'
webpack = require './webpack'

port = 3000

app.set 'port', process.env.PORT || port

server = http.createServer app
server.listen port, '0.0.0.0'
server.on 'error', (err) ->
  console.error err.code
server.on 'listening', () ->
  console.info 'listening'
