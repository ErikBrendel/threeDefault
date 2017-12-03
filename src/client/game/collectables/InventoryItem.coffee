# an abstract collectable item

Constants = require '../../config/Constants'

class InventoryItem
  constructor: (@type, @name, @inventoryHolder) ->
    @hasFocus = true
    @mesh = AssetCache.getModel "objects/item_#{@name}",
      copyMaterials: true


  onInteract: (person)  ->
    console.log 'You got: ' + @name
    @changeOwner(person)
    return Constants.baseTakeItemDelay

  changeOwner: (newOwner) ->
    @inventoryHolder.inventory?.onObjectTaken(@)
    @inventoryHolder = newOwner
    newOwner.inventory?.onReceiveObject(@)

module.exports = InventoryItem