SmoothVector = require '../../util/SmoothVector3'

class RoomLight extends THREE.PointLight
  constructor: ->
    super('#fff0ca', 1, 10, 2)
    @position.set 1, 1, 1
    @castShadow = false;
    #@shadow.mapSize.width = 256;
    #@shadow.mapSize.height = 256;


module.exports = RoomLight