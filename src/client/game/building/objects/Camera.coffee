# the un(penetrable) vault that stores all kinds of treasures
RoomObject = require './RoomObject'
Inventory = require '../../collectables/Inventory'
GoldIngot = require '../../collectables/GoldIngot'
SmoothValue = require '../../../util/SmoothValue'
Constants = require '../../../config/Constants'

class Camera extends RoomObject
  constructor: (room, clickHandler) ->
    super 'camera', room, clickHandler
    @loadCamera()

  loadCamera: ->
    @mesh = AssetCache.getModel 'objects/camera'

  onInteract: (person) ->


module.exports = Camera
