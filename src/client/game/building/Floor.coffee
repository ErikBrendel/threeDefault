Room = require "./Room"

class Floor
  constructor: (@floorSize, scene) ->
    @rooms = []
    for x in [0..@floorSize.x - 1]
      @rooms[x] = []
      for y in [0..@floorSize.y - 1]
        @rooms[x][y] = new Room scene, {x: x, y: y}

module.exports = Floor
