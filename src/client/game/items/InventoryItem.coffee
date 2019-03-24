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
    @collectSound = AssetCache.getGlobalSound 'collect_coin' # TODO: add per item sound

  onInteract: (person)  ->
    console.log 'You got: ' + @name
    @changeOwner(person)
    return Constants.baseTakeItemDelay

  onEnter: (room) ->
  onLeave: (room) ->

  changeOwner: (newOwner) ->
    @inventoryHolder.inventory?.onObjectTaken(@)
    @inventoryHolder = newOwner
    newOwner.inventory?.onReceiveObject(@)
    @addToPlayerInventory newOwner if newOwner.type is 'player'

  addToPlayerInventory: (player) ->
    score = document.getElementById('inventory-score')

    @collectSound.play()
    score.innerText = 'Score: ' + player.inventory.totalValue()

    inf = document.getElementById('inventory')
    img = document.createElement('img')
    img.src = "assets/texture/item/#{@name}.png"
    img.onmouseenter = =>
      showDescription @mesh.userData.description, true
    img.onmouseleave = =>
      hideDescription(true)
    img.onclick = =>
      @inventoryHolder.inventory?.onObjectTaken @
      img.parentNode.removeChild img
      score.innerText = 'Score: ' + player.inventory.totalValue()
    inf.appendChild(img)

module.exports = InventoryItem