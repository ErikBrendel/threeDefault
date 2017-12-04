# a heavy shiny bag of coins that makes you loud and rich

Treasure = require './Treasure'
Constants = require '../../config/Constants'

class SuitCase extends Treasure
  constructor: (inventoryHolder) ->
    super 'SuitCase', inventoryHolder

module.exports = SuitCase