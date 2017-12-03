# the un(penetrable) vault that stores all kinds of treasures
RoomObject = require './RoomObject'
Inventory = require '../../collectables/Inventory'
GoldIngot = require '../../collectables/GoldIngot'
SmoothValue = require '../../../util/SmoothValue'
Constants = require '../../../config/Constants'

DOOR_X = 1.69044
DOOR_Y = 0
DOOR_Z = -1.50253

HANDLE_X = 1.00324 - DOOR_X
HANDLE_Y = 0.34733 - DOOR_Y
HANDLE_Z = 0

class Safe extends RoomObject
  constructor: (room, clickHandler) ->
    super 'safe', room, clickHandler
    @loadDoor()
    @loadHandle()
    @safeIsAnimating = false
    @inventory = new Inventory(new GoldIngot @)
    @safeOpened = false
    @doorOpened = false

  loadDoor: ->
    @doorMesh = AssetCache.getModel 'objects/safe_door'
    @doorMesh.position.set DOOR_X, DOOR_Y, DOOR_Z
    @mesh.add @doorMesh
    @doorAnimator = new SmoothValue 700, 0
    @doorAnimator.addUpdateHandler (doorOpenProgress) =>
      @doorMesh.rotation.y = doorOpenProgress * Math.PI / 2
    @doorAnimator.addFinishHandler =>
      if not @doorOpened
        @doorHandleAnimator.set 0
      else
        @safeIsAnimating = false

  loadHandle: ->
    @doorHandle = AssetCache.getModel 'objects/safe_handle'
    @doorHandle.position.set HANDLE_X, HANDLE_Y, HANDLE_Z
    @doorMesh.add @doorHandle
    @doorHandleAnimator = new SmoothValue 600, 0
    @doorHandleAnimator.addUpdateHandler (handleRotateProgress) =>
      @doorHandle.rotation.z = handleRotateProgress * Math.PI * -2
    @doorHandleAnimator.addFinishHandler =>
      if @doorOpened
        @doorAnimator.set 1
      else
        @safeIsAnimating = false


  onInteract: (person) ->
    return unless person.currentRoom is @room
    if not @safeOpened
      @startOpeningMinigame()
      return Constants.baseOpenSafeDelay

    return if @safeIsAnimating

    if not @doorOpened
      @onSafeOpenAnimation()
      if @inventory.size() == 0
        console.log 'you look into the safe... and it is empty'
      else
        @inventory.changeContentOwner(person)
        console.log 'you look into the safe... and find something'
      return Constants.baseTakeItemDelay
    else
      @onSafeCloseAnimation()
      return Constants.baseCloseSafeDelay

  startOpeningMinigame: ->
    @safeOpened = true

  onSafeOpenAnimation: ->
    @safeIsAnimating = true
    @doorOpened = true
    @doorHandleAnimator.set 1

  onSafeCloseAnimation: ->
    return if @safeIsAnimating
    @safeIsAnimating = true
    @doorOpened = false
    @doorAnimator.set 0

module.exports = Safe
