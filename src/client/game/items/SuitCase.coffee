# a heavy shiny bag of coins that makes you loud and rich

Treasure = require './Treasure'
Constants = require '../../config/Constants'

class SuitCase extends Treasure
  constructor: (inventoryHolder) ->
    super 'SuitCase', inventoryHolder

  onLeave: (room) ->
    number = Math.floor Math.random() * 3
    if number == 0
      room.push new BankNotePile

module.exports = SuitCase