SmoothVector = require '../../util/SmoothVector3'

class PersonLight extends THREE.SpotLight
  constructor: (@person) ->
    super '#fff0ca', 2, 10, Math.PI / 8, 0, 2

    @castShadow = true
    @shadow.mapSize.width = 1024
    @shadow.mapSize.height = 1024
    @position.set(@person.position.x, 0.5, @person.position.z)
    @person.add @
    @person.add @target
    @setDirection new THREE.Vector3 0, -0.3, 1

  setDirection: (direction) ->
    @target.position.copy(@position.clone().add(direction).sub(new THREE.Vector3(0, 0.2, 0)))


module.exports = PersonLight