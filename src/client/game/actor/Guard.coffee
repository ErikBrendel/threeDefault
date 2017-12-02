# the feared watching enemy who wants to find the Players
Person = require './Person'

class Guard extends Person
  constructor: ->
    super 'guard', 1

  onAction: (done) ->
    x = Math.floor(Math.random() * 4)
    y = Math.floor(Math.random() * 4)
    @setPosition(new THREE.Vector3(x * 4, 0, y * 4))
    @waitTime = 4 #TODO: balancing here
    setTimeout done


module.exports = Guard
