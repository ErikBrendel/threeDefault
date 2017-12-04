# the (un)penetrable vault that stores all kinds of treasures

RoomObject = require './RoomObject'
loadHoverEffect = require '../../actor/HoverEffect'
Constants = require '../../../config/Constants'

class Laser extends RoomObject
  constructor: (room, clickHandler) ->
    super 'laser', room, clickHandler
    @hasFocus = true
    @mesh.userData.description =
      header: 'Laser Beams'
      text: 'They will trigger an alarm when you move normally into this Room.<br><br>Click on the lasers to move carefully into this room. This will not trigger any alarm, but will take more time.'
      cost: Constants.baseMoveThroughLaserDelay

  onInteract: (person) ->
    @room.enteredSilently = true
    person.setRoom(@room)
    gs.camera.resetFocus()
    gs.exitHandler = undefined
    return Constants.baseMoveThroughLaserDelay

  isVisible: ->
    not @room.isPlayerInRoom() and @room.isPlayerInAdjacentRoom()

module.exports = Laser
