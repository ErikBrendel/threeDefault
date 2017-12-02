
RoomObject = require './RoomObject'

class Safe extends RoomObject
  constructor: (room, clickHandler) ->
    super 'safe', room, clickHandler

  onInteract: (person) ->
    return unless person.currentRoom is @room
    console.log 'you look into the safe... it is empty'


module.exports = Safe
