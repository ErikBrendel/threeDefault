# a collectable item that is worth stealing

InventoryItem = require './InventoryItem'

class Treasure extends InventoryItem
  constructor: (name, @value, inventoryHolder) ->
    super 'treasure', name, inventoryHolder

module.exports = Treasure