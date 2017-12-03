# a heavy shiny piece of valueness that makes you slow and rich

Treasure = require './Treasure'

class GoldIngot extends Treasure
  constructor: (inventoryHolder) ->
    super 'GoldIngot', 100, inventoryHolder

module.exports = GoldIngot