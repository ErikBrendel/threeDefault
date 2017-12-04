# the feared watching enemy who wants to find the Players
Person = require './Person'
Constants = require '../../config/Constants'

GuardCounter = 0

class Guard extends Person
  constructor: (@floor, @onClickHandler) ->
    super 'guard', "Guard #{GuardCounter++}", 1
    @userData.description =
      header: 'A Guard'
      text: 'Stay away from him! He will cost you a life.'

  onClick: ->
    @onClickHandler()

  onInteract: (person) ->


  onAction: (done) ->
    console.log 'onAction'

    if @currentRoom is @targetRoom or not @targetRoom?
      @targetRoom = @chooseRoom()

    @nextRoom = @findNextRoom()

    @setRoom @nextRoom

    @waitTime = Constants.baseMoveDelay
    setTimeout done, Constants.msToMoveToRoom

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
