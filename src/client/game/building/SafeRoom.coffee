Room = require './Room'
Safe = require './objects/Safe'
SafeLock = require './objects/SafeLock'

class SafeRoom extends Room
  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super({up, right, down, left, type, objectClickHandler})
    @description =
      header: 'Safe Room'
      text: 'There is a safe in this room! Crack it, to receive the treasures inside!'

  addObjects: (objectClickHandler) ->
    safe = new Safe @, objectClickHandler
    @objects.push safe
    @objects.push new SafeLock @, objectClickHandler, safe


module.exports = SafeRoom
