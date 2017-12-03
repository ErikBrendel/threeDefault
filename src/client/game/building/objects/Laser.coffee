# the (un)penetrable vault that stores all kinds of treasures

RoomObject = require './RoomObject'

class Laser extends RoomObject
  constructor: (room, clickHandler) ->
    super 'laser', room, clickHandler
    @mesh = AssetCache.getModel 'objects/laser'

  onInteract: (person) ->

module.exports = Laser
