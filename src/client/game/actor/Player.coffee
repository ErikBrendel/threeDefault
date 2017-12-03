# the controllable player object
Person = require './Person'
Inventory = require '../collectables/Inventory'

class Player extends Person
  constructor: ->
    super 'player', 'You'
    console.dir(@)
    @inventory = new Inventory()
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
    3 + @inventory.findObjects((item) -> item.name is 'GoldIngot').length
    #TODO: balancing here

module.exports = Player
