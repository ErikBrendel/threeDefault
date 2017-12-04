# the (un)penetrable vault that stores all kinds of treasures

RoomObject = require './RoomObject'
SmoothValue = require '../../../util/SmoothValue'

DOOR_X = 1.69044
DOOR_Y = 0

HANDLE_X = 1.00324 - DOOR_X

LOCK_X = HANDLE_X
LOCK_Y = 0.73733 - DOOR_Y
LOCK_Z = 0

class SafeLock extends RoomObject
  constructor: (room, clickHandler, @safe) ->
    super 'safe_lock', room, clickHandler, (
      cameraPosition: new THREE.Vector3 1.00262, 0.69845, -1.07407
      cameraLookAt: new THREE.Vector3 1.00262, 0.73845, -1.42407
      playerPosition: new THREE.Vector3 1.3, 0, -0.5
      ),
      baseIntensity: 0.1
      r: 1
      g: 0.3
      b: 0

    @mesh.userData.description =
      header: 'Safe Lock'
      text: 'Click here to start cracking the safe.'
    @mesh.position.set LOCK_X, LOCK_Y, LOCK_Z
    @safe.doorMesh.add @mesh
    @lockValue = new SmoothValue 300, 20

    @solution = [7, 2, 18]

    @lockValue.addUpdateHandler (rawRotation) =>
      @mesh.rotation.z = Math.PI * (rawRotation / 10)


  onInteract: (person) ->
    return unless person.type is 'player'

    window.crack_rotate = @crack_rotate
    window.crack_open = @crack_open
    document.getElementById('safe-container').style.visibility = 'visible'

    ledsDiv = document.getElementById 'safe-leds'
    ledsDivContent = ''
    ledId = 0
    for number in @solution
      ledsDivContent += "<div id='safe-led-#{ledId}'></div>"
      ledId++
    ledsDiv.innerHTML = ledsDivContent

  crack_rotate: (amount) =>
    newValue = @lockValue.target + amount
    @lockValue.set newValue

  crack_open: =>
    #TODO: if opened
    @crackingDone()
    gs.exitHandler?()

  crackingDone: ->
    document.getElementById('safe-container').style.visibility = 'hidden'
    @safe.safeOpened = true
    window.crack_rotate = undefined
    window.crack_open = undefined

module.exports = SafeLock
