Room = require "./Room"

{ Group } = THREE

class Floor extends Group
  constructor: (@floorSize, scene) ->
    super()
    @rooms = []
    for x in [0..@floorSize.x - 1]
      @rooms[x] = []
      for y in [0..@floorSize.y - 1]
        @rooms[x][y] = new Room
          up: true
          right: true
          down: true
          left: false
        @rooms[x][y].position.set(x * 4, 0, y * 4)
        @rooms[x][y].onGroundClick = (room) ->
          console.log('you clicked the floor')
          scene.onGroundClicked room
        @add @rooms[x][y]

module.exports = Floor
