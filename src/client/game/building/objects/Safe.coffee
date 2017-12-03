
RoomObject = require './RoomObject'
GoldIngot = require '../../collectables/GoldIngot'
SmoothValue = require '../../../util/SmoothValue'

DOOR_X = 1.69044
DOOR_Z = -1.50253

class Safe extends RoomObject
  constructor: (room, clickHandler) ->
    super 'safe', room, clickHandler
    @loadDoor()
    @inventory = [new GoldIngot @]
    @safeOpened = false
    @doorOpened = false

  loadDoor: ->
    @doorMesh = AssetCache.getModel 'objects/safe_door'
    @doorMesh.position.set DOOR_X, 0, DOOR_Z
    @mesh.add @doorMesh
    @doorAnimator = new SmoothValue 300, 0
    @doorAnimator.addUpdateHandler (doorOpenProgress) =>
      @doorMesh.rotation.y = doorOpenProgress * Math.PI / 2

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
    @doorAnimator.set 1
    @doorOpened = true

  onSafeCloseAnimation: ->
    @doorAnimator.set 0
    @doorOpened = false

  onObjectTaken: (object) ->
    objectIndex = @inventory.indexOf object
    console.log objectIndex
    if objectIndex > -1
      @inventory.splice objectIndex, 1

module.exports = Safe
