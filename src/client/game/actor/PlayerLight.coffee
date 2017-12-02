SmoothVector = require '../../util/SmoothVector3'

class PlayerLight extends THREE.PointLight
  constructor: (@player) ->
    super('#fff0ca', 1, 10, 2)

    @castShadow = true;
    @shadow.mapSize.width = 1024;
    @shadow.mapSize.height = 1024;
    @player.moveLight = (position) => @setPosition position

  setPosition: (position) ->
    @position.set(position.x + 0.1, 1.05, position.z + 0.3)


module.exports = PlayerLight