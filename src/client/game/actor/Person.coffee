# abstract parent of guards and players
#AssetCache = require './'

class Person
  constructor: (@type) ->
    @position =
      x: 0
      y: 0
    @mesh = AssetCache.getModel type

  setPosition: (@position) ->
    @mesh.position. position
