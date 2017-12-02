# abstract parent of guards and players

class Person
  constructor: (@type) ->
    @position =
      new THREE.Vector3 0, 0, 0
    @mesh = AssetCache.getModel @type

  setPosition: (@position) ->
    console.log @position
    @mesh.position.copy @position

module.exports = Person
