# the controllable player object
Person = require './Person'

class Player extends Person
  constructor: ->
    super 'player'
    @inventory = []
    @positionSmoother.addUpdateHandler (newPosition) =>
      @moveLight? newPosition

  setPosition: (position) ->
    super position
    @direction = position
    @moveCamera? position

module.exports = Player
