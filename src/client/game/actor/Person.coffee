# abstract parent of guards and players

class Person
  constructor: (@type) ->
    @position =
      new THREE.Vector3 0, 0, 0
    @mesh = AssetCache.getModel @type

  setPosition: (@position) ->
    @mesh.position.copy @position

  setRoom: (newRoom) ->
    oldRoom = @currentRoom
    @currentRoom?.onLeave newRoom
    @currentRoom = newRoom
    @setPosition(@currentRoom.position)
    @currentRoom.onEnter oldRoom

module.exports = Person
