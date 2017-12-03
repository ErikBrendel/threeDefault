Room = require './Room'
Camera = require './objects/Camera'

class CameraRoom extends Room
  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super({up, right, down, left, type, objectClickHandler})
    @description = 'Camera Room'

  addObjects: (objectClickHandler) ->
    @objects.push new Camera @, objectClickHandler


module.exports = CameraRoom
