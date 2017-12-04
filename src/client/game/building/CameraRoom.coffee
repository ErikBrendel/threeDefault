Room = require './AlarmRoom'
Camera = require './objects/Camera'

class CameraRoom extends AlarmRoom
  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super({up, right, down, left, type, objectClickHandler})
    @description =
      header: 'Camera Room'
      text: 'You will get seen (and an alarm will get triggered) when you are in a Camera Room and a Guard is in another Camera Room'

  addObjects: (objectClickHandler) ->
    super(objectClickHandler)
    @objects.push new Camera @, objectClickHandler


module.exports = CameraRoom
