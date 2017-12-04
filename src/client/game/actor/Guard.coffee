# the feared watching enemy who wants to find the Players
Person = require './Person'
Constants = require '../../config/Constants'
SmoothValue = require '../../util/SmoothValue'
SmoothVector3 = require '../../util/SmoothVector3'

GuardCounter = 0

class Guard extends Person
  constructor: (@floor, @onClickHandler) ->
    super 'guard', "Guard #{GuardCounter++}", 1
    @userData.description =
      header: 'A Guard'
      text: 'Stay away from him! He will cost you a life.'
    @alerted = false
    @questionMark = AssetCache.getModel 'questionMark'
    @add @questionMark

    @questionMarkPositionAnimator = new SmoothVector3 700, new THREE.Vector3 0, 0, 0
    switchDirection = =>
      @questionMarkPositionAnimator.set new THREE.Vector3(0, 0.4, 0).sub @questionMarkPositionAnimator.get()
    @questionMarkPositionAnimator.addFinishHandler switchDirection
    switchDirection()
    @questionMarkPositionAnimator.addUpdateHandler (position) =>
      if @alerted
        @questionMark.position.copy position
      else
        @questionMark.position.x = 10000

    @questionMarkRotator = new SmoothValue 2000, 0, 0
    @questionMarkRotator.addFinishHandler =>
      @questionMarkRotator.set @questionMarkRotator.get() + 2 * Math.PI
    @questionMarkRotator.addUpdateHandler (rotation) =>
      @questionMark.rotation.y = rotation
    @questionMarkRotator.set 2 * Math.PI


  onClick: ->
    @onClickHandler()

  onInteract: (person) ->


  setAlerted: ->
    Jukebox.fadeTo 'fast', 500 unless @alerted
    @alerted = true
    @numActionsAlerted = Constants.baseNumActionsAlerted

  updateAlerted: ->
    @numActionsAlerted--
    if @numActionsAlerted <= 0 and @alerted
      Jukebox.fadeTo 'slow', 500
      @alerted = false


  onAction: (done) ->
    console.log 'onAction'

    if @currentRoom is @targetRoom or not @targetRoom?
      @targetRoom.deactivateAlarm?() if @targetRoom?
      @targetRoom = @chooseRoom()

    @nextRoom = @findNextRoom()

    @setRoom @nextRoom

    @updateAlerted()

    @waitTime = @getMoveCost()
    setTimeout done, Constants.msToMoveToRoom

  getMoveCost: ->
    #TODO: balance here
    return Constants.baseMoveDelay - (if @alerted then 1 else 0)


  chooseRoom: ->
    newTarget = @currentRoom
    roomX = 0
    roomY = 0
    while newTarget is @currentRoom
      roomX = Math.floor Math.random() * @floor.floorSize.x
      roomY = Math.floor Math.random() * @floor.floorSize.y
      newTarget = @floor.rooms[roomX][roomY]
    return newTarget

  findNextRoom: ->
    foundRooms = [@targetRoom]
    finishedRooms = new Set
    newNextRoom = undefined

    while not newNextRoom?
      currentRoom = foundRooms.shift()
      continue if finishedRooms.has(currentRoom)

      neighbours = currentRoom.neighbourRooms
      for name, room of neighbours
        if currentRoom.canEnter(room) and room is @currentRoom
          return currentRoom
        if currentRoom.canEnter(room) and not finishedRooms.has(room) then foundRooms.push(room)
      finishedRooms.add(currentRoom)

module.exports = Guard
