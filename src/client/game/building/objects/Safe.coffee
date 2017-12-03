
RoomObject = require './RoomObject'
GoldIngot = require '../../collectables/GoldIngot'

class Safe extends RoomObject
  constructor: (room, clickHandler) ->
    super 'safe', room, clickHandler
    @inventory = [new GoldIngot @]
    @safeOpened = false
    @doorOpened = false

  onInteract: (person) ->
    return unless person.currentRoom is @room
    if not @safeOpened
      return @startOpeningMinigame()

    if not @doorOpened
      @onSafeOpenAnimation()
      if @inventory.length == 0
        console.log 'you look into the safe... and it is empty'
      else
        @inventory.forEach((item) -> item.changeOwner person)
        console.log 'you look into the safe... and find something'
    else
      @onSafeCloseAnimation()

  startOpeningMinigame: ->
    @safeOpened = true

  onSafeOpenAnimation: ->
    @doorOpened = true

  onSafeCloseAnimation: ->
    @doorOpened = false

  onObjectTaken: (object) ->
    objectIndex = @inventory.indexOf object
    console.log objectIndex
    if objectIndex > -1
      @inventory.splice objectIndex, 1

module.exports = Safe
