# a collectable item that helps you escape

InventoryItem = require './InventoryItem'

class Tool extends InventoryItem
  constructor: ->
    super 'tool'