# a heavy shiny piece of valueness that makes you slow and rich

Treasure = require './Treasure'
Constants = require '../../config/Constants'

class GoldIngot extends Treasure
  constructor: (inventoryHolder) ->
    super 'GoldIngot', inventoryHolder

module.exports = GoldIngot