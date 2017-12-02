# The connection between two rooms,
# including mesh, type and logic

SmoothValue = require '../../util/SmoothValue'

class Door
  constructor: (rotated) ->
    @mesh = AssetCache.getModel 'door'
    @rotationOffset = if rotated then Math.PI / 2 else 0
    @mesh.rotation.y = @rotationOffset

    @openCloseAnimationProgress = new SmoothValue 400, 0
    @openCloseAnimationProgress.addUpdateHandler (progress) =>
      @mesh.rotation.y = progress * Math.PI / 2 + @rotationOffset

  playOpenCloseAnimation: (goesUpOrRight) ->
    @playOpenAnimation goesUpOrRight
    setTimeout (=>
      @playCloseAnimation()
    ), 700

  playOpenAnimation: (goesUpOrRight) ->
    direction = 1
    if (goesUpOrRight) then direction = 1 else direction = -1
    @openCloseAnimationProgress.set direction

  playCloseAnimation: ->
    @openCloseAnimationProgress.set 0

module.exports = Door
