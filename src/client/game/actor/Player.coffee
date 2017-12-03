# the controllable player object
Person = require './Person'
Inventory = require '../collectables/Inventory'
Constants = require '../../config/Constants'

class Player extends Person
  constructor: (audioListener) ->
    super 'player', 'You'
    @addEars(audioListener)
    @inventory = new Inventory()
    @isDran = false
    @health = Constants.basePlayerHealth
    @updateHealthUI()

  heal: (amount = 1) ->
    @health = Math.min(@health + amount, Constants.basePlayerHealth)
    @updateHealthUI()

  damage: (amount = 1) ->
    @health = @health - amount
    @updateHealthUI()
    @lost() if @health <= 0

  updateHealthUI: () ->
    document.getElementById('health' + i).hidden = i >= @health for i in [0..2]

  lost: ->
    console.log('you lost')

  addEars: (audioListener) ->
    @listener = audioListener
    @add @listener
    @listener.position.set 0, 0.6, 0
    @listener.rotateY Math.PI

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
      @damage()
      @waitTime = @walkWaitTime()
      setTimeout @doneHandler, Constants.msToMoveToRoom

  walkWaitTime: ->
    Constants.baseMoveDelay + @inventory.findObjects((item) -> item.name is 'GoldIngot').length * Constants.GoldIngotMoveDelay
    #TODO: balancing here

  interactWith: (roomObject) ->
    return unless @isDran
    newWaitTime = roomObject.onInteract @
    if not isNaN newWaitTime
      @waitTime = newWaitTime
      setTimeout @doneHandler, Constants.msToMoveToRoom

module.exports = Player
