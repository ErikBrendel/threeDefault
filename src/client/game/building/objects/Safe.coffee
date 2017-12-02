
RoomObject = require './RoomObject'
GoldIngot = require '../../collectables/GoldIngot'

class Safe extends RoomObject
  constructor: (room, clickHandler) ->
    super 'safe', room, clickHandler
    @inventory = [new GoldIngot]

  onInteract: (person) ->
    return unless person.currentRoom is @room
    if @inventory.length == 0
      console.log 'you look into the safe... it is empty'
    else
      console.log (person.inventory.length)
      person.inventory = person.inventory.concat(@inventory)
      console.log (person.inventory.length)
      console.log 'you look into the safe... and found something'
      @inventory = []

module.exports = Safe
