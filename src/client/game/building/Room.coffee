Wall = require './Wall'
Constants = require '../../config/Constants'
loadHoverEffect = require '../actor/HoverEffect'
{ Group } = THREE

class Room extends Group
  constructor: ({up, right, down, left, @objectClickHandler}) ->
    super()
    @seen = false
    @description = 'Default Room'
    @details = 'Some boring room'
    @addWalls up, right, down, left
    @addGround()
    @doors = {}
    @neighbourRooms = {}
    @objects = []
    @currentPersons = new Set

  addWalls: (up, right, down, left) ->
    @wallUp = new Wall Math.PI * 0.5, up
    @wallLeft = new Wall Math.PI, left
    @wallDown = new Wall Math.PI * 1.5, down
    @wallRight = new Wall 0, right
    @add wall for wall in [@wallUp, @wallRight, @wallDown, @wallLeft]

  addGround: ->
    @ground = AssetCache.getModel 'ground',
      copyMaterials: true

    @groundMaterial = @ground.material
    @ground.material = new THREE.MeshPhongMaterial
      color: 0

    @userData.mouseEnterHandler = =>
      @showDescription? @description, @details
    @add @ground

    loadHoverEffect @ground,
      => @getSharedDoorWith(gs.player.currentRoom)? and (not gs.camera.focusMode or gs.camera.focusedObject.allowRoomMovement)
      => @onGroundClick? @

  getSharedDoorWith: (otherRoom) ->
    for direction, neighbourRoom of @neighbourRooms
      if neighbourRoom is otherRoom
        return @doors[direction]

  canEnter: (newRoom) ->
    door = @getSharedDoorWith(newRoom)
    door?

  onDepart: (newRoom) ->
    # door animation
    usedDoor = @getSharedDoorWith newRoom
    goesUpOrRight = @neighbourRooms.up is newRoom or @neighbourRooms.right is newRoom
    usedDoor?.playOpenCloseAnimation(goesUpOrRight)

  onLeave: (person, newRoom) ->
    @currentPersons.delete(person)
    object.onLeave person, newRoom for object in @objects
    @doors[direction]?.onPersonLeavesAdjacentRoom person for direction, neighbourRoom of @neighbourRooms
    #console.log 'LEAVE'

  onEnter: (person, oldRoom) =>
    @currentPersons.add(person)
    @getPlayerInRoom()?.damage(@currentPersons.size - 1)
    @ground.userData.resetHover()
    @discover() if person.type == 'player'
    object.onEnter person, oldRoom for object in @objects
    @doors[direction]?.onPersonEntersAdjacentRoom person for direction, neighbourRoom of @neighbourRooms

    #console.log 'ENTER'

  getPlayerInRoom: =>
    (Array.from(@currentPersons).filter (person) ->
      person.type is 'player')[0]

  isPlayerInRoom: =>
    @getPlayerInRoom()?

  isPlayerInAdjacentRoom: =>
    ((n for d, n of @neighbourRooms).filter (neighbourRoom) ->
      neighbourRoom?.isPlayerInRoom())[0]?

  onPeek: (person) ->
    return if @seen
    if person.type is 'player'
      @discover()
      return Constants.basePeekDelay

  onArrive: (oldRoom) ->
    # Nothing so far

  discover: ->
    return if @seen
    @seen = true
    @ground.material = @groundMaterial
    @addObjects? @objectClickHandler

module.exports = Room
