# a Building which has a couple of floors

Floor = require './Floor'
layouts = require './floors/Layouts'

class Building
  constructor: (numberOfFloors, scene) ->
    @floors = []
    for i in [1 .. numberOfFloors]
      floor = new Floor layouts[i - 1], scene
      @floors.push floor
    for i in [numberOfFloors - 2 .. 0]
      floor = @floors[i]
      for x in [0 .. floor.floorSize.x - 1]
        for y in [0 .. floor.floorSize.y - 1]
          if floor.rooms[x][y].isStairs?
            floor.rooms[x][y].neighbourRooms.above = @floors[i + 1].rooms[x][y]
            @floors[i + 1].rooms[x][y].neighbourRooms.below = floor.rooms[x][y]

module.exports = Building