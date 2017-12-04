# the controllable player object
Person = require './Person'
Inventory = require '../items/Inventory'
Coins = require '../items/Coins'
Constants = require '../../config/Constants'
SmoothValue = require '../../util/SmoothValue'

class Player extends Person
  constructor: (audioListener) ->
    super 'player', 'You'
    @userData.description =
      header: 'You'
      text: 'This is you. You want to get rich, so let\'s go and steal some good stuff!<br>Click to wait in this room'
    @addEars(audioListener)
    @inventory = new Inventory()#(new SuitCase @), (new SuitCase @), (new SuitCase @), (new SuitCase @), (new SuitCase @), (new SuitCase @))
    @isDran = false
    @health = Constants.basePlayerHealth
    @updateHealthUI()
    @sleepSmoother = new SmoothValue Constants.msSleep, 0
    @sleepSmoother.addUpdateHandler @newSleepRotation
    @sleepSmoother.addFinishHandler (=> setTimeout (=> @standUpSmoother.set 0), Constants.msSleeping)
    @standUpSmoother = new SmoothValue Constants.msSleep, Math.PI / 2
    @standUpSmoother.addUpdateHandler @newSleepRotation
    @sleepSmoother.addFinishHandler @doneSleeping

  doneSleeping: =>
    @doneHandler()
    @sleepSmoother.inject -> 0
    @standUpSmoother.inject -> Math.PI / 2

  newSleepRotation: (rotation) =>
    @model.rotation.x = rotation

  heal: (amount = 1) ->
    @health = Math.min(@health + amount, Constants.basePlayerHealth)
    @updateHealthUI()

  onClick: (clickedObject) =>
    @interactWith clickedObject

  damage: (amount = 1) ->
    return unless amount > 0
    @health = @health - amount
    @updateHealthUI()
    @lost() if @health <= 0

  updateHealthUI: ->
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
    if @hidden
      @waitTime = 1
      done()
    @doneHandler = done

  onRoomClicked: (room) ->
    return unless @isDran
    if @setRoom room
      @isDran = false
      @waitTime = @walkWaitTime()
      setTimeout @doneHandler, Constants.msToMoveToRoom

  walkWaitTime: (baseDelay = Constants.baseMoveDelay) ->
    baseDelay + @inventory.findObjects((item) -> item.name is 'GoldIngot').length * Constants.Items.GoldIngot.moveDelay
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

  onInteract: (person) ->
    #@model.rotation.x = Math.PI / 2
    @sleepSmoother.set Math.PI / 2
    return 1

  ascend: ->
    unless @moving
      newRoom = @currentRoom.neighbourRooms.above
      if @currentRoom? and @currentRoom.canEnter(newRoom)
        @currentRoom.onLeave @, newRoom
        oldRoom = @currentRoom
        @position.copy(newRoom.position)
        @currentRoom = newRoom
        @currentRoom.onEnter @, oldRoom
        return true
    false

module.exports = Player
