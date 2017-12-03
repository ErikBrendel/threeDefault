# an abstract collectable item

class InventoryItem
  constructor: (@type, @name, @inventoryHolder) ->
    @mesh = AssetCache.getModel "objects/item_#{@name}",
      copyMaterials: true

  changeOwner: (newOwner) ->
    @inventoryHolder.inventory?.onObjectTaken(@)
    @inventoryHolder = newOwner
    newOwner.inventory?.onReceiveObject(@)

module.exports = InventoryItem