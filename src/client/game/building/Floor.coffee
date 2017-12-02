Room = require "./Room"

{ Group } = THREE

class Floor extends Group
  constructor: (layout) ->
    super()
    @lines = layout.layout.split('\n')
    @floorSize = layout.floorSize
    @rooms = []
    for x in [0..@floorSize.x - 1]
      @rooms[x] = []
      for y in [0..@floorSize.y - 1]
        @rooms[x][y] = new Room
          up: @isUp x, y
          right: @isRight x, y
          down: @isDown x, y
          left: @isLeft x, y
        @rooms[x][y].position.set(x * 4, 0, y * 4)
        @add @rooms[x][y]

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
