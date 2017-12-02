Wall = require './Wall'

Safe = require './objects/Safe'
Stairs= require './objects/Stairs'

{ Group } = THREE

class Room extends Group
  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super()
    @description = 'Default Room'
    @addWalls up, right, down, left
    @addGround()
    @doors = {}
    @neighbourRooms = {}
    @addObjects type, objectClickHandler

  addWalls: (up, right, down, left) ->
    @wallUp = new Wall Math.PI * 0.5, up
    @wallLeft = new Wall Math.PI, left
    @wallDown = new Wall Math.PI * 1.5, down
    @wallRight = new Wall 0, right
    @add wall for wall in [@wallUp, @wallRight, @wallDown, @wallLeft]

  addGround: ->
    @ground = AssetCache.getModel 'ground'
    @userData.clickHandler = =>
      @onGroundClick? @

    @userData.mouseEnterHandler = =>
      @showDescription? @description
    @add @ground

  addObjects: (type, objectClickHandler) ->
    @objects = []
    if type is 'stairs'
      @objects.push new Stairs @, objectClickHandler
    if type is 'safe'
      @objects.push new Safe @, objectClickHandler

  getSharedDoorWith: (otherRoom) ->
    for direction, neighbourRoom of @neighbourRooms
      if neighbourRoom is otherRoom
        return @doors[direction]
    null

  canEnter: (newRoom) ->
    door = @getSharedDoorWith(newRoom)
    console.dir(door)
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
    object.onEnter person, oldRoom for object in @objects
    console.log 'ENTER'

  onArrive: (oldRoom) ->
    # Nothing so far


module.exports = Room
