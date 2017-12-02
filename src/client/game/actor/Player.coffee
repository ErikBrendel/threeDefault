# the controllable player object
Person = require './Person'

class Player extends Person
  constructor: ->
    super 'player'
    @inventory = []
    @isDran = false
    @positionSmoother.addUpdateHandler (newPosition) =>
      @moveLight? newPosition

  setPosition: (position) ->
    super position
    @moveCamera? position

  onAction: (done) ->
    @isDran = true
    @doneHandler = done

  onRoomClicked: (room) ->
    return unless @isDran
    if @canWalkTo room
      @setRoom room
      @isDran = false
      @waitTime = @walkWaitTime()
      @doneHandler()

  canWalkTo: (room) ->
    @position.distanceTo(room.position) <= 4 and
    room isnt @currentRoom

  walkWaitTime: ->
    1 #TODO: balancing here


module.exports = Player
