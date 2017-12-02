express = require 'express'
path = require 'path'


app = express()

#Assets
app.use '/assets', express.static path.join __dirname, '../../res'

# all other static files
app.use express.static path.join __dirname, '../../dist'

module.exports = app
