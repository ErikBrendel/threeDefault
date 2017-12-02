# abstract parent of guards and players

SmoothVector3 = require '../../util/SmoothVector3'

class Person
  constructor: (@type) ->
    @position =
      new THREE.Vector3 0, 0, 0
    @mesh = AssetCache.getModel @type
    @moving = false
    @positionSmoother = new SmoothVector3 900
    @positionSmoother.addUpdateHandler (newPosition) =>
      @mesh.position.copy newPosition
      if @moving and @newRoom?
        if @mesh.position.distanceTo(@newRoom.position) < @mesh.position.distanceTo(@currentRoom.position)
          @currentRoom.onLeave @, @newRoom
          @oldRoom = @currentRoom
          @currentRoom = @newRoom
          @newRoom = null
          @currentRoom.onEnter @, @oldRoom
    @positionSmoother.addFinishHandler =>
      @currentRoom.onArrive @oldRoom if @oldRoom?
      @oldRoom = null
      @moving = false

  setPosition: (@position) ->
    @positionSmoother.set @position


  setRoom: (newRoom) ->
    unless @moving
      if @currentRoom? and @currentRoom.canEnter(newRoom)
        @moving = true
        @newRoom = newRoom
        @currentRoom.onDepart(@newRoom)
        @setPosition(@newRoom.position)
      else if not @currentRoom?
        @moving = true
        @currentRoom = newRoom
        @setPosition(@currentRoom.position)

module.exports = Person
