Room = require './Room'
Door = require './Door'

{ Group } = THREE

class Floor extends Group
  constructor: (layout, scene) ->
    super()
    @lines = layout.layout.split('\n')
    @floorSize = layout.floorSize
    @createRooms scene
    @createDoors()

  createRooms: (scene) ->
    @rooms = []
    for x in [0..@floorSize.x - 1]
      @rooms[x] = []
      for y in [0..@floorSize.y - 1]
        room = new Room
          up: @isUp x, y
          right: @isRight x, y
          down: @isDown x, y
          left: @isLeft x, y
        room.position.set x * 4, 0, y * 4

        room.neighbourRooms.up = @rooms[x][y - 1]
        @rooms[x][y - 1]?.neighbourRooms.down = room
        room.neighbourRooms.left = @rooms[x - 1]?[y]
        @rooms[x - 1]?[y].neighbourRooms.right = room

        room.onGroundClick = (room) ->
          console.log('you clicked the floor')
          scene.onGroundClicked room
        room.onRoomHover = (room) ->
          scene.onRoomHover room
        @add room
        @rooms[x][y] = room

  createDoors: ->
    for x in [0..@floorSize.x - 2]
      for y in [0..@floorSize.y - 2]
        if @isDown x, y
          @createDoor x, y, false
        if @isRight x, y
          @createDoor x, y, true

  createDoor: (x, y, rightAndNotDown) ->
    door = new Door not rightAndNotDown
    offsetX = if rightAndNotDown then 2 else -0.5
    offsetZ = if rightAndNotDown then -0.5 else 2
    door.mesh.position.set 4 * x + offsetX, 0, 4 * y + offsetZ
    firstKey = if rightAndNotDown then 'right' else 'down'
    secondKey = if rightAndNotDown then 'left' else 'up'
    @rooms[x][y].doors[firstKey] = door
    secondRoom = if rightAndNotDown then @rooms[x + 1][y] else @rooms[x][y + 1]
    secondRoom.doors[secondKey] = door
    @add door.mesh

  isUp: (x, y) ->
    roomPos = @roomCharPos x, y
    return @isWall roomPos.x, roomPos.y - 1

  isRight: (x, y) ->
    roomPos = @roomCharPos x, y
    return @isWall roomPos.x + 1, roomPos.y

  isDown: (x, y) ->
    roomPos = @roomCharPos x, y
    return @isWall roomPos.x, roomPos.y + 1

  isLeft: (x, y) ->
    roomPos = @roomCharPos x, y
    return @isWall roomPos.x - 1, roomPos.y

  roomCharPos: (x, y) ->
    return {x: x * 2 + 1, y: y * 2 + 1}

  isWall: (x, y) ->
    return @lines[y].charAt(x) == ' '

module.exports = Floor
