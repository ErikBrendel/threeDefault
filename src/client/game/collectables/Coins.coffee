# a heavy shiny bag of coins that makes you loud and rich

Treasure = require './Treasure'
Constants = require '../../config/Constants'
class Coins extends Treasure
  constructor: (inventoryHolder) ->
    super 'Coins', Constants.CoinsValue, inventoryHolder

module.exports = Coins