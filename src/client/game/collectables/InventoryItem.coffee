# an abstract collectable item

Constants = require '../../config/Constants'

class InventoryItem
  constructor: (@type, @name, @inventoryHolder) ->
    @hasFocus = true
    @mesh = AssetCache.getModel "objects/item_#{@name}",
      copyMaterials: true
    @mesh.userData.description =
      header: Constants.Items[@name]?.title
      text: Constants.Items[@name]?.description

  onInteract: (person)  ->
    console.log 'You got: ' + @name
    @changeOwner(person)
    return Constants.baseTakeItemDelay

  changeOwner: (newOwner) ->
    @inventoryHolder.inventory?.onObjectTaken(@)
    @inventoryHolder = newOwner
    newOwner.inventory?.onReceiveObject(@)
    @addToPlayerInventory() if newOwner.type is 'player'

  addToPlayerInventory: ->
    inf = document.getElementById('inventory')
    img = document.createElement('img')
    img.src = "assets/texture/item/#{@name}.png"
    inf.appendChild(img)

module.exports = InventoryItem