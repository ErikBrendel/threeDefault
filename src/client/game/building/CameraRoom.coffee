AlarmRoom = require './AlarmRoom'
Camera = require './objects/Camera'

class CameraRoom extends AlarmRoom
  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super({up, right, down, left, type, objectClickHandler})
    @isCameraRoom = true
    Object.assign @description,
      header: 'Camera Room'
      text: 'You will get seen (and an alarm will get triggered) when you are in a Camera Room and a Guard is in another Camera Room'

  addObjects: (objectClickHandler) ->
    super(objectClickHandler)
    @objects.push new Camera @, objectClickHandler

  onEnter: (person, oldRoom) =>
    super(person, oldRoom)
    return unless gs.player.currentRoom? and gs.guard.currentRoom?
    if gs.player.currentRoom.isCameraRoom and gs.guard.currentRoom.isCameraRoom and gs.player.currentRoom isnt gs.guard.currentRoom
      gs.player.currentRoom.triggerAlarm()
      gs.guard.currentRoom.discover()


module.exports = CameraRoom
