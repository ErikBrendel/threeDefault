Room = require './Room'
Safe = require './objects/Safe'

class SafeRoom extends Room
  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super({up, right, down, left, type, objectClickHandler})
    @description =
      header: 'Safe Room'
      text: 'There is a safe in this room! Crack it, to receive the treasures inside!'

  addObjects: (objectClickHandler) ->
    @objects.push new Safe @, objectClickHandler


module.exports = SafeRoom
