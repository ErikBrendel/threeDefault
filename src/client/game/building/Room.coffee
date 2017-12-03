Wall = require './Wall'
loadHoverEffect = require '../actor/HoverEffect'
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

  addWalls: (up, right, down, left) ->
    @wallUp = new Wall Math.PI * 0.5, up
    @wallLeft = new Wall Math.PI, left
    @wallDown = new Wall Math.PI * 1.5, down
    @wallRight = new Wall 0, right
    @add wall for wall in [@wallUp, @wallRight, @wallDown, @wallLeft]

  addGround: ->
    @ground = AssetCache.getModel 'ground',
      copyMaterials: true
    @userData.clickHandler = =>
      @onGroundClick? @

    @groundMaterial = @ground.material
    @ground.material = new THREE.MeshPhongMaterial
      color: 0

    @userData.mouseEnterHandler = =>
      @showDescription? @description
    @add @ground

    loadHoverEffect @ground, =>
      @getSharedDoorWith(gs.player.currentRoom)?

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
    @doors[direction]?.onPersonLeavesAdjacentRoom person for direction, neighbourRoom of @neighbourRooms
    #console.log 'LEAVE'

  onEnter: (person, oldRoom) ->
    @ground.userData.resetHover()
    @discover() if person.type == 'player'
    object.onEnter person, oldRoom for object in @objects
    @doors[direction]?.onPersonEntersAdjacentRoom person for direction, neighbourRoom of @neighbourRooms

    #console.log 'ENTER'

  onPeek: (person) ->
    return if @seen
    if person.type == 'player'
      @discover()
      return 1

  onArrive: (oldRoom) ->
    # Nothing so far

  discover: ->
    return if @seen
    @seen = true
    @ground.material = @groundMaterial
    @addObjects? @objectClickHandler


module.exports = Room
