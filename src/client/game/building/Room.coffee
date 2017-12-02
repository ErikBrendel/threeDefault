Wall = require './Wall'

{ Group } = THREE

class Room extends Group
  constructor: ({up, right, down, left}) ->
    super()
    @addWalls up, right, down, left
    @addGround()
    @doors = {}
    @neighbourRooms = {}

  addWalls: (up, right, down, left) ->
    @wallUp = new Wall Math.PI * 0.5, up
    @wallLeft = new Wall Math.PI, left
    @wallDown = new Wall Math.PI * 1.5, down
    @wallRight = new Wall 0, right
    @add wall for wall in [@wallUp, @wallRight, @wallDown, @wallLeft]

  addGround: ->
    @ground = AssetCache.getModel 'ground'
    @ground.userData.clickHandler = =>
      console.log('you clicked the ground')
      @onGroundClick? @
    @add @ground

  getSharedDoorWith: (otherRoom) ->
    for direction, neighbourRoom of @neighbourRooms
      if neighbourRoom is otherRoom
        return @doors[direction]

  onLeave: (newRoom) ->
    # door animation
    usedDoor = @getSharedDoorWith newRoom
    goesUpOrRight = @neighbourRooms.up is newRoom or @neighbourRooms.right is newRoom
    usedDoor?.playOpenCloseAnimation(goesUpOrRight)

  onEnter: (oldRoom) ->
    # nothing to do


module.exports = Room
