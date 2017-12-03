# the un(penetrable) vault that stores all kinds of treasures
RoomObject = require './RoomObject'

class Camera extends RoomObject
  constructor: (room, clickHandler) ->
    super 'camera', room, clickHandler
    @loadCamera()

  loadCamera: ->
    @mesh = AssetCache.getModel 'objects/camera'

  onInteract: (person) ->


module.exports = Camera
