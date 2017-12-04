# the controllable player object
Person = require './Person'
Inventory = require '../collectables/Inventory'
Constants = require '../../config/Constants'

class Player extends Person
  constructor: (audioListener) ->
    super 'player', 'You'
    @userData.description =
      header: 'You'
      text: 'This is you. You want to get richt, so let\'s go and steal some good stuff!'
    @addEars(audioListener)
    @inventory = new Inventory()
    @isDran = false
    @health = Constants.basePlayerHealth
    @updateHealthUI()

  heal: (amount = 1) ->
    @health = Math.min(@health + amount, Constants.basePlayerHealth)
    @updateHealthUI()

  damage: (amount = 1) ->
    return unless amount > 0
    @health = @health - amount
    @updateHealthUI()
    @lost() if @health <= 0

  updateHealthUI: () ->
    hearts = document.getElementById('health-bar').children
    heart.classList.toggle('dead', i >= @health) for heart, i in hearts

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
      @waitTime = @walkWaitTime()
      setTimeout @doneHandler, Constants.msToMoveToRoom

  walkWaitTime: ->
    Constants.baseMoveDelay + @inventory.findObjects((item) -> item.name is 'GoldIngot').length * Constants.GoldIngotMoveDelay
    #TODO: balancing here

  interactWith: (roomObject) ->
    return unless @isDran
    newWaitTime = roomObject.onInteract @
    if not isNaN newWaitTime
      @isDran = false
      @waitTime = newWaitTime
      setTimeout @doneHandler, Constants.msToMoveToRoom
      return true
    return false

module.exports = Player
