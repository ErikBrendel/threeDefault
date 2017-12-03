SmoothVector = require '../../util/SmoothVector3'

Z_OFFSET = 2
MIN_HEIGHT = 5
DEFAULT_HEIGHT = 10
MAX_HEIGHT = 30

class PlayerCamera extends THREE.PerspectiveCamera
  constructor: (@player) ->
    super 45, 1, 0.1, 100
    @focusMode = false # true to focus a specific thing and disable controls
    @focusLookAtTarget = undefined
    @height = MIN_HEIGHT
    @position.set @positionTarget()

    @setLookAt @player.position
    @smoothPosition = new SmoothVector 1000, @positionTarget(), 1
    @smoothPosition.addUpdateHandler @positionUpdateHandler
    @positionUpdateHandler @positionTarget()

    @player.moveCamera = => @setPosition()
    @eventAttatschden()

  positionUpdateHandler: (pos) =>
    @position.copy pos
    @setLookAt @lookAtTarget()

  focusObject: ({offset, cameraPosition, cameraLookAt}) ->
    @focusMode = true

    @focusLookAtTarget = new SmoothVector 500, @lookVector.clone()

    @smoothPosition.set cameraPosition.clone().add offset
    @focusLookAtTarget.set cameraLookAt.clone().add offset

  resetFocus: ->
    @focusMode = false
    @focusLookAtTarget.addFinishHandler () =>
      @focusLookAtTarget.destroy()
      @focusLookAtTarget = undefined
    @focusLookAtTarget.set @lookAtTarget true
    @height = MIN_HEIGHT
    @setPosition()


  lookAtTarget: (ignoreFocus = false) ->
    # where to look at
    return @focusLookAtTarget.get() if @focusLookAtTarget? and not ignoreFocus
    return new THREE.Vector3 @position.x, 0, @position.z - Z_OFFSET
  positionTarget: ->
    # where to be in normal (not focus) mode
    focusRoom = if @player.newRoom? then @player.newRoom else @player.currentRoom
    return new THREE.Vector3 focusRoom.position.x, @height, focusRoom.position.z + Z_OFFSET

  setLookAt: (vec) ->
    @lookVector = vec
    @lookAt vec

  setPosition: () ->
    return if @focusMode
    @smoothPosition.set @positionTarget()
    @setLookAt @lookAtTarget()


  eventAttatschden: ->
    document.addEventListener 'wheel', @mouseWheel

  applyZoom: (factor) ->
    @height -= Math.max(-2, Math.min(factor, 2))
    @height = Math.max(MIN_HEIGHT, Math.min(@height, MAX_HEIGHT))
    @smoothPosition.inject (pos) =>
      pos.y = @height
      return pos

  mouseWheel: (event) =>
    if gs.exitHandler?()
      return
    event.preventDefault()
    event.stopPropagation()
    @applyZoom event.deltaY * -0.25

module.exports = PlayerCamera