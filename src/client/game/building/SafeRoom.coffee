Room = require './Room'
Safe = require './objects/Safe'

class SafeRoom extends Room
  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super({up, right, down, left, type, objectClickHandler})
    @description = 'Safe Room'

  addObjects: (objectClickHandler) ->
    @objects.push new Safe @, objectClickHandler


module.exports = SafeRoom
