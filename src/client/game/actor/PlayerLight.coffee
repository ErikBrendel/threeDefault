SmoothVector = require '../../util/SmoothVector3'

class PlayerLight extends THREE.SpotLight
  constructor: (@player) ->
    super('#fff0ca', 2, 10, Math.PI / 8, 0, 2)

    @castShadow = true;
    @shadow.mapSize.width = 1024;
    @shadow.mapSize.height = 1024;
    @player.moveLight = (position, direction) =>
      console.log(position)
      @setPosition position
      @setDirection direction

  setPosition: (position) ->
    @position.set(position.x, 0.5, position.z )

  setDirection: (direction) ->
    @target.position.copy(@position.clone().add(direction).sub(new THREE.Vector3(0, 0.2, 0)))


module.exports = PlayerLight