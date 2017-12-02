# abstract parent of guards and players

SmoothVector3 = require '../../util/SmoothVector3'

class Person
  constructor: (@type) ->
    @position =
      new THREE.Vector3 0, 0, 0
    @mesh = AssetCache.getModel @type

    @positionSmoother = new SmoothVector3 900
    @positionSmoother.addUpdateHandler (newPosition) =>
      @mesh.position.copy newPosition

  setPosition: (@position) ->
    @positionSmoother.set @position

  setRoom: (newRoom) ->
    oldRoom = @currentRoom
    @currentRoom?.onLeave newRoom
    @currentRoom = newRoom
    @setPosition(@currentRoom.position)
    @currentRoom.onEnter oldRoom

module.exports = Person
