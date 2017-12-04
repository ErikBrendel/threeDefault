Room = require './Room'
Camera = require './objects/Camera'

class CameraRoom extends Room
  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super({up, right, down, left, type, objectClickHandler})
    @description =
      header: 'Camera Room'
      text: 'You will get seen (and an alarm will get triggered) when you are in a Camera Room and a Guard is in another Camera Room'

  addObjects: (objectClickHandler) ->
    @objects.push new Camera @, objectClickHandler


module.exports = CameraRoom
