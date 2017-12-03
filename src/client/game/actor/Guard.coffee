# the feared watching enemy who wants to find the Players
Person = require './Person'
Constants = require '../../config/Constants'

GuardCounter = 0

class Guard extends Person
  constructor: (@floor) ->
    super 'guard', "Guard #{GuardCounter++}", 1

  onAction: (done) ->
    console.log 'onAction'
    console.dir @targetRoom
    console.dir @nextRoom

#movementOptions = []

    #for direction, neighbourRoom of @currentRoom.neighbourRooms
      #movementOptions.push neighbourRoom if @currentRoom.canEnter(neighbourRoom)

    #nextRoom = movementOptions[Math.floor(Math.random() * movementOptions.length)]
    if @currentRoom is @targetRoom or not @targetRoom?
      @targetRoom = @chooseRoom()
      @nextRoom = @findNextRoom()
    @setRoom @nextRoom
    @nextRoom = @findNextRoom()
    console.dir @nextRoom

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
    console.log "new target: #{roomX} : #{roomY}"
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
          console.log 'nextRoomFound'
          console.dir currentRoom
          console.log 'for targetroom'
          console.dir @targetRoom
          return currentRoom
        if currentRoom.canEnter(room) and not finishedRooms.has(room) then foundRooms.push(room)
      finishedRooms.add(currentRoom)

module.exports = Guard
