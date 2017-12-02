# abstract parent of guards and players

class Person
  constructor: (@type) ->
    @position =
      x: 0
      y: 0
    @mesh = AssetCache.getModel @type



  setPosition: (@position) ->
    console.log @position
    @mesh.position.set @position.x * 4, 0, @position.y * 4

module.exports = Person
