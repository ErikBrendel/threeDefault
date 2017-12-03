# the feared watching enemy who wants to find the Players
Person = require './Person'

GuardCounter = 0

class Guard extends Person
  constructor: ->
    super 'guard', "Guard #{GuardCounter++}", 1

  onAction: (done) ->
    movementOptions = []

    for direction, neighbourRoom of @currentRoom.neighbourRooms
      movementOptions.push neighbourRoom if @currentRoom.canEnter(neighbourRoom)

    nextRoom = movementOptions[Math.floor(Math.random() * movementOptions.length)]

    @setRoom nextRoom

    @waitTime = 4 #TODO: balancing here
    setTimeout done, 50


module.exports = Guard
