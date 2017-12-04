# the (un)penetrable vault that stores all kinds of treasures

RoomObject = require './RoomObject'
loadHoverEffect = require '../../actor/HoverEffect'
Constants = require '../../../config/Constants'

class Laser extends RoomObject
  constructor: (room, clickHandler) ->
    super 'laser', room, clickHandler
    @hasFocus = true

  onInteract: (person) ->
    person.setRoom(@room)
    return Constants.baseMoveThroughLaserDelay

  isVisible: ->
    not @room.isPlayerInRoom() and @room.isPlayerInAdjacentRoom()

module.exports = Laser
