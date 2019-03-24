SmoothValue = require '../../util/SmoothValue'

class AlarmLight extends THREE.SpotLight
  constructor: ->
    super '#ff010d', 2, 10, Math.PI / 2.5, 0.3, 2
    @castShadow = true
    @shadow.mapSize.width = 1024
    @shadow.mapSize.height = 1024
    @shadow.camera.near
    @shadowCameraNear = 0.1;
    @position.set(-1000, 0.5, -1000)
    @directionAngleSmoother = new SmoothValue 500, 0, 0
    @directionAngleSmoother.set 2 * Math.PI
    @directionAngleSmoother.addFinishHandler =>
      @directionAngleSmoother.set @directionAngleSmoother.get() + 2 * Math.PI
    @directionAngleSmoother.addUpdateHandler (newAngle) =>
      @setDirection new THREE.Vector3(Math.sin(newAngle), Math.cos(newAngle), 0)

  setDirection: (direction) ->
    @target.position.copy(@position.clone().add(direction))

  setRoom: (@room) ->
    @position.set(@room.position.x - 1.48, 0.84, @room.position.z - 1.66)

  deactivate: ->
    @position.set(-1000, 0.84, -1000) #lol



instance = null

AlarmLight.instance = ->
  instance = new AlarmLight() unless instance?
  instance

module.exports = AlarmLight