# an abstract collectable item

class InventoryItem
  constructor: (@type, @name, @inventoryHolder) ->

  changeOwner: (newOwner) ->
    @inventoryHolder.inventory?.onObjectTaken(@)
    @inventoryHolder = newOwner
    newOwner.inventory?.onReceiveObject(@)

module.exports = InventoryItem