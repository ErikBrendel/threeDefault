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
    if @setRoom room
      @isDran = false
      @waitTime = @walkWaitTime()
      setTimeout @doneHandler, 500

  walkWaitTime: ->
    3 + @inventory.filter((item) -> item.name is 'GoldIngot').length
    #TODO: balancing here

  onReceiveObject: (newObject) ->
    @inventory.push newObject

module.exports = Player
