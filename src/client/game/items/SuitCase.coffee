# a heavy shiny bag of coins that makes you loud and rich

Treasure = require './Treasure'
BankNotePile = require './BankNotePile'
Constants = require '../../config/Constants'

class SuitCase extends Treasure
  constructor: (inventoryHolder) ->
    super 'SuitCase', inventoryHolder

  onLeave: (room) ->
    number = Math.floor Math.random() * 3
    if number == 0
      room.objects.push new BankNotePile room, (->)

module.exports = SuitCase