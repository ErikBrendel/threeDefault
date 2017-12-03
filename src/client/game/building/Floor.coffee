Room = require './Room'
StairsRoom = require './StairsRoom'
SafeRoom = require './SafeRoom'
CameraRoom = require './CameraRoom'
Door = require './Door'
shuffle = require '../../util/ArrayShuffle'

{ Group } = THREE

class Floor extends Group
  constructor: (layout, scene) ->
    super()
    @lines = layout.layout.split('\n')
    @floorSize = layout.floorSize
    @roomTypes = []

    for type, amount of layout.rooms
      for i in [1..amount]
        @roomTypes.push type

    shuffle @roomTypes

    @createRooms scene
    @createDoors()

  createRooms: (scene) ->
    @rooms = []
    @objectClickHandler = (clickedObject) ->
      if clickedObject.hasFocus
        scene.player.interactWith clickedObject
      else
        clickedObject.hasFocus = true
        offset = clickedObject.room.position
        scene.player.setPosition clickedObject.focusData.playerPosition.clone().add offset
        scene.camera.focusObject clickedObject.room.position, clickedObject.focusData
        scene.exitHandler = ->
          scene.camera.resetFocus()
          clickedObject.hasFocus = false
          scene.player.moveToRoomCenter()
          scene.exitHandler = undefined


    for x in [0..@floorSize.x - 1]
      @rooms[x] = []
      for y in [0..@floorSize.y - 1]
        room = @createRoom x, y

        room.position.set x * 4, 0, y * 4

        room.neighbourRooms.up = @rooms[x][y - 1]
        @rooms[x][y - 1]?.neighbourRooms.down = room
        room.neighbourRooms.left = @rooms[x - 1]?[y]
        @rooms[x - 1]?[y].neighbourRooms.right = room

        room.onGroundClick = (room) ->
          scene.onRoomClicked room
        room.showDescription = (description) ->
          scene.showDescription description
        @add room
        @rooms[x][y] = room

  createRoom: (x, y) ->
    roomType = @roomTypes[x + y * @floorSize.x]
    roomClass = @classFromRoomType roomType
    new roomClass
      up: @isUp x, y
      right: @isRight x, y
      down: @isDown x, y
      left: @isLeft x, y
      objectClickHandler: @objectClickHandler

  classFromRoomType: (type) ->
    {
      stairs: StairsRoom
      safe: SafeRoom
      camera: CameraRoom
      default: Room
    }[type]

  createDoors: ->
    for x in [0..@floorSize.x - 1]
      for y in [0..@floorSize.y - 1]
        if @isDown x, y
          @createDoor x, y, false
        if @isRight x, y
          @createDoor x, y, true

  createDoor: (x, y, rightAndNotDown) ->
    door = new Door not rightAndNotDown, @objectClickHandler
    offsetX = if rightAndNotDown then 2 else -0.5
    offsetZ = if rightAndNotDown then -0.5 else 2
    door.mesh.position.set 4 * x + offsetX, 0.1, 4 * y + offsetZ
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
