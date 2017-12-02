# the controllable player object
Person = require './Person'

class Player extends Person
  constructor: ->
    super 'player', 'You'
    @inventory = []
    @isDran = false

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
      setTimeout @doneHandler, 500

  canWalkTo: (room) ->
    @position.distanceTo(room.position) <= 4 and
    not @moving and
    room isnt @currentRoom and
    @currentRoom.canEnter room

  walkWaitTime: ->
    3 + @inventory.filter((item) -> item.name is 'GoldIngot').length
    #TODO: balancing here


module.exports = Player
