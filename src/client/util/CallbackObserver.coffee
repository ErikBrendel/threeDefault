# An observer that simply executes a callback

Observer = require 'util/Observer'

class CallbackObserver extends Observer
  constructor: (@callback) ->

  registerOn: (observable, aspects...) ->
    observable.attachObserver @, @callback, aspects

  update: (notification, aspect) ->
    notification(aspect)

module.exports = CallbackObserver
