# the controllable player object
Person = require './Person'
Inventory = require '../collectables/Inventory'
Constants = require '../../config/Constants'

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
      setTimeout @doneHandler, Constants.msToMoveToRoom

  walkWaitTime: ->
    Constants.baseMoveDelay + @inventory.findObjects((item) -> item.name is 'GoldIngot').length
    #TODO: balancing here

  interactWith: (roomObject) ->
    return unless @isDran
    newWaitTime = roomObject.onInteract @
    if newWaitTime?
      @waitTime = newWaitTime
    setTimeout @doneHandler, Constants.msToMoveToRoom

module.exports = Player
