# abstract parent of guards and players

SmoothVector3 = require '../../util/SmoothVector3'
PersonLight = require './PersonLight'
Constants = require '../../config/Constants'
loadHoverEffect = require './HoverEffect'

class Person extends THREE.Group
  constructor: (@type, @name, @waitTime = 0) ->
    super()
    @direction = new THREE.Vector3 0, 0, 0
    @position.set 0, 0, 0
    @model = AssetCache.getModel @type
    @add @model
    @moving = false
    @positionSmoother = new SmoothVector3 Constants.msToMoveToRoom
    @positionSmoother.addProgressListener (progress) =>
      unless @direction.length() < 0.001
        @setDirection(@direction)
        @rotateZ(0.3 * Math.sin(progress * Math.PI) * Math.sin(progress * Math.PI * 3))
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
    loadHoverEffect @model, @isVisible, (=> @onClick @)
    @addSound()
    @hasFocus = true

  onClick: ->

  addSound: ->
    @sound = AssetCache.getSound 'move'
    @sound.setRefDistance 0.3
    @add @sound
    @sound.position.set 0, 0, 0

  setPosition: (position) ->
    @positionSmoother.set position

  lookTo: (position) ->
    @setDirection position.clone().sub(@position) unless @moving

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
        @sound.play()
        return true
      else if not @currentRoom?
        @moving = true
        @currentRoom = newRoom
        @currentRoom.onEnter @
        @setPosition(@currentRoom.position.clone())
        return true
    false

  moveToRoomCenter: ->
    @moving = true
    @direction = @currentRoom.position.clone().sub(@position).normalize()
    @newRoom = @currentRoom
    @oldRoom = @currentRoom
    @setPosition(@currentRoom.position.clone())


  hide: ->
    @hidden = true
    @setPosition @currentRoom.position.clone().add(new THREE.Vector3(1.6, 0, 1.6))


  onAction: (done) ->

module.exports = Person
