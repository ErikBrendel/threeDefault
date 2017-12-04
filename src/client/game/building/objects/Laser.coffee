# the (un)penetrable vault that stores all kinds of treasures

RoomObject = require './RoomObject'
loadHoverEffect = require '../../actor/HoverEffect'
Constants = require '../../../config/Constants'

class Laser extends RoomObject
  constructor: (room, clickHandler) ->
    super 'laser', room, clickHandler
    @hasFocus = true

  onInteract: (person) ->
    @room.enteredSilently = true
    person.setRoom(@room)
    gs.camera.resetFocus()
    gs.exitHandler = undefined
    return Constants.baseMoveThroughLaserDelay

  isVisible: ->
    not @room.isPlayerInRoom() and @room.isPlayerInAdjacentRoom()

module.exports = Laser
