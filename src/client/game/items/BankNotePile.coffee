
RoomObject = require '../building/objects/RoomObject'

class BankNotePile extends RoomObject
  constructor: (room, clickHandler) ->
    super 'BankNotePile', room, clickHandler
    roomX = Math.random() * 3 - 1
    roomZ = Math.random() * 3 - 1
    @mesh.position.copy new THREE.Vector3 roomX, 0.001, roomZ
    @isBankNotePile = true
    @looksSuspicious = true

module.exports = BankNotePile