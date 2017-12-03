SmoothVector = require '../../util/SmoothVector3'

Z_OFFSET = 2
MIN_HEIGHT = 5
DEFAULT_HEIGHT = 10
MAX_HEIGHT = 30

class PlayerCamera extends THREE.PerspectiveCamera
  constructor: (@player) ->
    super 45, 1, 0.1, 100
    @focusMode = false # true to focus a specific thing and disable controls
    @position.set 0, 0, 0
    @position.y = DEFAULT_HEIGHT
    @setLookAt @player.position
    @smoothPosition = new SmoothVector 1000, @position.clone(), 1
    @smoothPosition.addUpdateHandler (pos) =>
      @position.x = pos.x
      @position.z = pos.z + Z_OFFSET
      @setLookAt new THREE.Vector3 pos.x, 0, pos.z
    @player.moveCamera = (position) => @setPosition position
    @eventAttatschden()

  focusObject: (offset, {cameraPosition, cameraLookAt}) ->
    @focusMode = true
    @smoothPosition.halt()

    @focusSmoothLookAt = new SmoothVector 500, @lookVector.clone()
    @focusSmoothLookAt.addUpdateHandler (focus) =>
      @setLookAt focus
    @focusSmoothPosition = new SmoothVector 500, @position.clone()
    @focusSmoothPosition.addUpdateHandler (pos) =>
      @position.copy pos

    @focusSmoothPosition.set cameraPosition.clone().add offset
    @focusSmoothLookAt.set cameraLookAt.clone().add offset

  setLookAt: (vec) ->
    @lookVector = vec
    @lookAt vec

  applyLookAt: ->
    @lookAt @lookVector

  setPosition: (position) ->
    return if @focusMode
    @smoothPosition.set(position)

  eventAttatschden: ->
    document.addEventListener 'wheel', @mouseWheel

  applyZoom: (factor) ->
    @position.y -= Math.max(-2, Math.min(factor, 2))
    @position.y = Math.max(MIN_HEIGHT, Math.min(@position.y, MAX_HEIGHT))
    @applyLookAt()

  mouseWheel: (event) =>
    return if @focusMode
    event.preventDefault()
    event.stopPropagation()
    @applyZoom event.deltaY * -0.25

module.exports = PlayerCamera