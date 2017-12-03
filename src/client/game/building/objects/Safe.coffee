# the (un)penetrable vault that stores all kinds of treasures

RoomObject = require './RoomObject'
Inventory = require '../../collectables/Inventory'
GoldIngot = require '../../collectables/GoldIngot'
Coins = require '../../collectables/Coins'
SmoothValue = require '../../../util/SmoothValue'
Constants = require '../../../config/Constants'
loadHoverEffect = require '../../actor/HoverEffect'

DOOR_X = 1.69044
DOOR_Y = 0
DOOR_Z = -1.50253

HANDLE_X = 1.00324 - DOOR_X
HANDLE_Y = 0.34733 - DOOR_Y
HANDLE_Z = 0

class Safe extends RoomObject
  constructor: (room, clickHandler) ->
    super 'safe', room, clickHandler,
      cameraPosition: new THREE.Vector3 0, 1, 0
      cameraLookAt: new THREE.Vector3 1.2, 0.56, -1.4
      playerPosition: new THREE.Vector3 1.3, 0, -0.5
    @loadDoor()
    @loadHandle()
    @safeIsAnimating = false
    @inventory = new Inventory()
    count = 1 + Math.floor Math.random() * 4
    for [1 .. count]
      lootType = Math.floor Math.random() * 2
      if lootType == 1
        @inventory.addContents new GoldIngot @
      else
        @inventory.addContents new Coins @
    @updateContent()
    @safeOpened = false
    @doorOpened = false

  loadDoor: ->
    @cameraMesh = AssetCache.getModel 'objects/safe_door'
    @cameraMesh.position.set DOOR_X, DOOR_Y, DOOR_Z
    @mesh.add @cameraMesh
    @doorAnimator = new SmoothValue 700, 0
    @doorAnimator.addUpdateHandler (doorOpenProgress) =>
      @cameraMesh.rotation.y = doorOpenProgress * Math.PI / 2
    @doorAnimator.addFinishHandler =>
      if not @doorOpened
        @doorHandleAnimator.set 0
      else
        @safeIsAnimating = false

  loadHandle: ->
    @doorHandle = AssetCache.getModel 'objects/safe_handle'
    @doorHandle.position.set HANDLE_X, HANDLE_Y, HANDLE_Z
    @cameraMesh.add @doorHandle
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
      return
      if @inventory.size() is 0
        console.log 'you look into the safe... and it is empty'
      else
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
    @safeIsAnimating = true
    @doorOpened = false
    @doorAnimator.set 0

  updateContent: ->
    placeIndex = 0
    for item in @inventory.contents
      loadHoverEffect item.mesh, (-> true), (do (item) => => (@clickHandler item) and @mesh.remove item.mesh),
        speed: 400
        r: 0
        g: 1
        b: 0
        baseIntensity: 0.1
        intensityIncrease: 0.1
      @addItemMesh item.mesh, placeIndex <= 1, placeIndex % 2 is 1
      placeIndex++

  addItemMesh: (itemMesh, isTop, isRight) ->
    position = new THREE.Vector3 0.92535, 0.5053, -1.69785
    if isRight then position.x += 0.5329
    if not isTop then position.y -= 0.44
    itemMesh.position.copy position
    @mesh.add itemMesh

module.exports = Safe
