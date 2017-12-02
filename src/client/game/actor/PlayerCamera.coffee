SmoothVector = require '../../util/SmoothVector3'

class PlayerCamera extends THREE.PerspectiveCamera
  constructor: (@player) ->
    super(45, 1, 0.1, 100)
    @position.set(0, 5, 0)
    @addControls()
    @smoothPosition = new SmoothVector(1000, @position, 1)
    @smoothPosition.addUpdateHandler (pos) =>
      @position.x = pos.x
      @position.z = pos.z
      @controls.target.x = pos.x
      @controls.target.z = pos.z

  setPosition: (position) ->
    @smoothPosition.set(position)

  addControls: ->
    @controls = new THREE.OrbitControls @
    @controls.enablePan = false
    @controls.enableRotate = false
    @controls.enableZoom = true
    @controls.minDistance = 3
    @controls.maxDistance = 30

module.exports = PlayerCamera