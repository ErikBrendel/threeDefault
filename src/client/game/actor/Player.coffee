# the controllable player object
Person = require './Person'

class Player extends Person
  constructor: ->
    super 'player'
    @inventory = []

  setPosition: (position) ->
    super(position)
    @moveCamera? position

module.exports = Player
