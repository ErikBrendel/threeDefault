Room = require './AlarmRoom'
Camera = require './objects/Camera'

class CameraRoom extends AlarmRoom
  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super({up, right, down, left, type, objectClickHandler})
    @description = 'Camera Room'

  addObjects: (objectClickHandler) ->
    super(objectClickHandler)
    @objects.push new Camera @, objectClickHandler


module.exports = CameraRoom
