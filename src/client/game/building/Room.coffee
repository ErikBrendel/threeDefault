Wall = require './Wall'
RoomLight = require './RoomLight'
{ Group } = THREE

class Room extends Group
  constructor: ({up, right, down, left, @objectClickHandler}) ->
    super()
    @seen = false
    @description = 'Default Room'
    @addWalls up, right, down, left
    @addGround()
    @doors = {}
    @neighbourRooms = {}
    @objects = []
    @light = new RoomLight
    @add @light

  addWalls: (up, right, down, left) ->
    @wallUp = new Wall Math.PI * 0.5, up
    @wallLeft = new Wall Math.PI, left
    @wallDown = new Wall Math.PI * 1.5, down
    @wallRight = new Wall 0, right
    @add wall for wall in [@wallUp, @wallRight, @wallDown, @wallLeft]

  addGround: ->
    @ground = AssetCache.getModel 'ground', false, true
    @userData.clickHandler = =>
      @onGroundClick? @

    @groundMaterial = @ground.material

    @ground.material = [new THREE.MeshPhongMaterial
      color: 0x111111]

    @userData.mouseEnterHandler = =>
      @showDescription? @description
    @add @ground

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
    object.onLeave person, newRoom for object in @objects
    console.log 'LEAVE'

  onEnter: (person, oldRoom) ->
    @discover()
    object.onEnter person, oldRoom for object in @objects
    console.log 'ENTER'

  onPeek: (person) ->
    @discover()

  onArrive: (oldRoom) ->
    # Nothing so far

  discover: ->
    return if @seen
    @seen = true
    @ground.material = @groundMaterial
    @addObjects? @objectClickHandler
    @light.activate()

module.exports = Room
