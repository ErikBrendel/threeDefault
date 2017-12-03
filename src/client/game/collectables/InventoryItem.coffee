# an abstract collectable item

class InventoryItem
  constructor: (@type, @name, @inventoryHolder) ->

  changeOwner: (newOwner) ->
    @inventoryHolder.onObjectTaken?(@)
    @inventoryHolder = newOwner
    newOwner.onReceiveObject(@)

module.exports = InventoryItem