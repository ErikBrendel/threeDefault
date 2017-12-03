# abstract parent of guards and players

SmoothVector3 = require '../../util/SmoothVector3'
PersonLight = require './PersonLight'

class Person extends THREE.Group
  constructor: (@type, @name, @waitTime = 0) ->
    super()
    @direction = new THREE.Vector3 0, 0, 0
    @position.set 0, 0, 0
    @model = AssetCache.getModel @type
    @add @model
    @moving = false
    @positionSmoother = new SmoothVector3 900
    @positionSmoother.addProgressListener (progress) =>
      unless @direction.length() < 0.001
        @setDirection(@direction)
        @rotateX(0.3 * Math.sin(progress * Math.PI) * Math.sin(progress * Math.PI * 3))
        @position.y = Math.abs(0.3 * Math.sin(progress * Math.PI * 3))
    @positionSmoother.addUpdateHandler (newPosition) =>
      @position.x = newPosition.x
      @position.z = newPosition.z
      if @moving
        if @newRoom? and @position.distanceTo(@newRoom.position) < @position.distanceTo(@currentRoom.position)
          @currentRoom.onLeave @, @newRoom
          @oldRoom = @currentRoom
          @currentRoom = @newRoom
          @newRoom = null
          @currentRoom.onEnter @, @oldRoom
    @positionSmoother.addFinishHandler =>
      @currentRoom.onArrive @oldRoom if @oldRoom?
      @oldRoom = null
      @moving = false

    @light = new PersonLight @

  setPosition: (position) ->
    @positionSmoother.set position

  lookTo: (position) ->
    @setDirection @position.clone().sub(position)

  setDirection: (direction) ->
    direction.y = 0
    @lookAt @position.clone().add(direction)


  setRoom: (newRoom) ->
    unless @moving
      if @currentRoom? and @currentRoom.canEnter(newRoom)
        @moving = true
        @newRoom = newRoom
        @direction = @newRoom.position.clone().sub(@currentRoom.position).normalize()
        @currentRoom.onDepart(@newRoom)
        @setPosition(@newRoom.position.clone())
        return true
      else if not @currentRoom?
        @moving = true
        @currentRoom = newRoom
        @setPosition(@currentRoom.position.clone())
        return true
    false

  onAction: (done) ->

module.exports = Person
