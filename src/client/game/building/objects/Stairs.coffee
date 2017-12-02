
RoomObject = require './RoomObject'

class Stairs extends RoomObject
  constructor: (room, clickHandler) ->
    super 'stairs', room, clickHandler

  onInteract: (person) ->
    return unless person.currentRoom is @room
    console.log 'YOU WON THIS LEVEL!'


module.exports = Stairs
