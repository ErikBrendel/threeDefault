express = require 'express'
path = require 'path'


app = express()


app.get '/texture/:name', (req, res) ->
  res.sendFile req.params.name, { root: path.join(__dirname, '../../res/texture') }

app.get '/model/:name', (req, res) ->
  res.sendFile req.params.name, { root: path.join(__dirname, '../../res/models') }

# all other static files
app.use express.static path.join __dirname, '../../dist'

module.exports = app
