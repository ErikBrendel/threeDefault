# the un(penetrable) vault that stores all kinds of treasures
RoomObject = require './RoomObject'

class Camera extends RoomObject
  constructor: (room, clickHandler) ->
    super 'camera', room, clickHandler

  onInteract: (person) ->

  isVisible: ->
    false

module.exports = Camera
