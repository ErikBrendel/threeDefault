# a collectable item that is worth stealing

InventoryItem = require './InventoryItem'
Constants = require '../../config/Constants'

class Treasure extends InventoryItem
  constructor: (name, inventoryHolder) ->
    super 'treasure', name, inventoryHolder
    @mesh.userData.description.value = @value()

  value: ->
    Constants.Items[@name]?.value

module.exports = Treasure