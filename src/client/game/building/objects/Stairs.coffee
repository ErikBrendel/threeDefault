
RoomObject = require './RoomObject'

class Stairs extends RoomObject
  constructor: (room, clickHandler) ->
    super 'stairs', room, clickHandler
    @mesh.userData.description =
      header: 'Stairs'
      text: 'They will take you to the next floor. <br><br>You cannot come back, so be sure to take everything from this floor you want to steal.'
    @hasFocus = true

  onInteract: (person) ->
    return unless person.currentRoom is @room
    gs.goToNextFloor()

module.exports = Stairs
