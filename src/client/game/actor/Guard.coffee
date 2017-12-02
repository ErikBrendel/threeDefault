# the feared watching enemy who wants to find the Players
Person = require './Person'

class Guard extends Person
  constructor: ->
    super 'guard'

  onAction: ->
    @currentRoom.
    x = Math.floor(Math.random() * 4)
    y = Math.floor(Math.random() * 4)
    @setPosition(new THREE.Vector3(x * 4, 0, y * 4))


module.exports = Guard
