Wall = require './Wall'
Constants = require '../../config/Constants'
loadHoverEffect = require '../actor/HoverEffect'
{ Group } = THREE

class Room extends Group
  constructor: ({up, right, down, left, @objectClickHandler, @logicalPosition}) ->
    super()
    @seen = false
    @addWalls up, right, down, left
    @addGround()
    @doors = {}
    @neighbourRooms = {}
    @objects = []
    @currentPersons = new Set
    @userData.description =
      header: 'Undiscovered Room'
      text: 'What might be there?'
      cost: => gs.player.walkWaitTime() if gs.player.currentRoom.canEnter @
    @description =
      header: 'Normal Room'
      text: 'Nothing special in here...'
      cost: => gs.player.walkWaitTime() if gs.player.currentRoom.canEnter @

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

    @add @ground

    loadHoverEffect @ground,
      => @getSharedDoorWith(gs.player.currentRoom)? and (not gs.camera.focusMode or gs.camera.focusedObject.allowRoomMovement)
      => @onGroundClick? @ if gs.player.isDran

  getSharedDoorWith: (otherRoom) ->
    for direction, neighbourRoom of @neighbourRooms
      if neighbourRoom is otherRoom
        return @doors[direction]

  canEnter: (newRoom) ->
    door = @getSharedDoorWith(newRoom)
    return door? or @neighbourRooms.above is newRoom

  onDepart: (newRoom) ->
    # door animation
    usedDoor = @getSharedDoorWith newRoom
    goesUpOrRight = @neighbourRooms.up is newRoom or @neighbourRooms.right is newRoom
    usedDoor?.playOpenCloseAnimation(goesUpOrRight)

  onLeave: (person, newRoom) ->
    @currentPersons.delete(person)
    object.onLeave person, newRoom for object in @objects

    if person.type is 'player'
      for item in person.inventory.contents
        item.onLeave @

    @doors[direction]?.onPersonLeavesAdjacentRoom person for direction, neighbourRoom of @neighbourRooms
    #console.log 'LEAVE'
    if gs.player.hidden and person.type isnt 'player'
      gs.player.moveToRoomCenter()
      gs.player.hidden = false

  onEnter: (person, oldRoom) =>
    @currentPersons.add(person)
    @getPlayerInRoom()?.damage(@currentPersons.size - 1)
    @ground.userData.resetHover()
    @discover() if person.type == 'player'
    object.onEnter person, oldRoom for object in @objects
    @doors[direction]?.onPersonEntersAdjacentRoom person for direction, neighbourRoom of @neighbourRooms
    if person.type == 'guard'
      #console.log 'took money'
      piles = @objects.filter((item) -> item.isBankNotePile)
      if piles.length > 0
        for item in piles
          @remove item.mesh
        #console.dir @objects.filter((item) -> item.isBankNotePile)
        @objects = @objects.filter((item) -> not item.isBankNotePile)
        person.setAlerted()
    #console.log 'ENTER'
    if person.type is 'player'
      if person.inventory.findObjects((item) -> item.isCoins).length > 0
        @alertNeighbourGuards()
    gs.player.hide() if gs.player?.currentRoom is gs.guard?.currentRoom

  alertNeighbourGuards: ->
    for name, room of @neighbourRooms
      for guard in Array.from(room.currentPersons).filter((person) -> person.type is 'guard')
        guard.setAlerted()


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
    @userData.description = @description
    @ground.material = @groundMaterial
    @addObjects? @objectClickHandler

module.exports = Room
