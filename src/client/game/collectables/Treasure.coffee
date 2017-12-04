# a collectable item that is worth stealing

InventoryItem = require './InventoryItem'
Constants = require '../../config/Constants'

class Treasure extends InventoryItem
  constructor: (name, inventoryHolder) ->
    super 'treasure', name, inventoryHolder
    @mesh.userData.description.value = Constants.Items[@name]?.value

  getDescriptionObject: ->
    s = super()
    s.value = @value
    s

module.exports = Treasure