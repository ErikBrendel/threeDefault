# The connection between two rooms,
# including mesh, type and logic

class Door
  constructor: (rotated) ->
    @mesh = AssetCache.getModel 'door'
    if rotated
      @mesh.rotation.y = Math.PI / 2

  playOpenAnimation: ->

  playCloseAnimation: ->

module.exports = Door
