# the un(penetrable) vault that stores all kinds of treasures
RoomObject = require './RoomObject'
Constants = require '../../../config/Constants'

class Monitor extends RoomObject
  constructor: (room, clickHandler) ->
    super 'monitor', room, clickHandler,
      cameraPosition: new THREE.Vector3 0, 1, 0
      cameraLookAt: new THREE.Vector3 1.2, 0.56, -1.4
      playerPosition: new THREE.Vector3 1.3, 0, -0.5

    @mesh.userData.description =
      header: 'Monitor'
      text: 'Click here to reveal the positions of all other camera rooms on this floor.<br><br>Be careful since the guard can see you here when he is in a camera room as well.'
      cost: Constants.basicMonitorDelay

  onInteract: (person) ->
    cameraRoom.discover() for cameraRoom in @room.otherCameras
    gs.exitHandler?()
    return Constants.basicMonitorDelay

module.exports = Monitor
