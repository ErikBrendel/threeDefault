# the (un)penetrable vault that stores all kinds of treasures

RoomObject = require './RoomObject'
SmoothValue = require '../../../util/SmoothValue'
Constants = require '../../../config/Constants'

DOOR_X = 1.69044
DOOR_Y = 0

HANDLE_X = 1.00324 - DOOR_X

LOCK_X = HANDLE_X
LOCK_Y = 0.73733 - DOOR_Y
LOCK_Z = 0

rawRotationToValue = (rawRotation) ->
  lockValue = Math.round rawRotation
  while lockValue <= 0 then lockValue += 20
  while lockValue > 20 then lockValue -= 20
  return lockValue

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
    @autoInteract = true

    @mesh.userData.description =
      header: 'Safe Lock'
      text: 'Click here to start cracking the safe.'
    @mesh.position.set LOCK_X, LOCK_Y, LOCK_Z
    @safe.doorMesh.add @mesh
    @lockValue = new SmoothValue 300, 20

    @solution = [7, 2]
    #crackHardness = 3
    #@solution = []
    #for [ 1 .. crackHardness]
    #  @solution.push Math.floor(Math.random() * 20) + 1

    @lockValue.addUpdateHandler @updateLockValue
    @lastLockValue = undefined
    @sounds = {}
    @sounds[true] = []
    @sounds[false] = []
    for [1 .. 1]
      sound = AssetCache.getSound 'lock_correct'
      @sounds[true].push sound
      @mesh.add sound
    for [1 .. 5]
      sound = AssetCache.getSound 'lock_tick'
      @sounds[false].push sound
      @mesh.add sound

  updateLockValue: (rawRotation = @lockValue.get()) =>
    @mesh.rotation.z = Math.PI * (rawRotation / 10)
    if @currentCrackingLayer?
      document.getElementById("safe-led-#{@currentCrackingLayer - 1}")?.classList.add 'locked'
      if @currentCrackingLayer is @solution.length
        document.getElementById('safe-open-button').disabled = false
        return
      lockValue = rawRotationToValue rawRotation
      rightValue = lockValue is @solution[@currentCrackingLayer]
      currentDiv = document.getElementById "safe-led-#{@currentCrackingLayer}"
      @maybePlaySound lockValue, rightValue
      #bugfix incoming
      if @signum isnt @lastSignum
        @lastSignum = @signum
        if rightValue
          currentDiv.classList.remove 'correct'
          currentDiv.classList.add 'locked'
          @currentCrackingLayer++
        else
          @failedToOpen()
        return
      if lockValue is @solution[@currentCrackingLayer] + @signum #overshoot
        @failedToOpen()
        return
      currentDiv.classList.toggle 'correct', rightValue
      currentDiv.classList.toggle 'incorrect', not rightValue
      if rightValue and @currentCrackingLayer is @solution.length - 1
        document.getElementById('safe-open-button').disabled = false

  maybePlaySound: (lockValue, isRight) ->
    return if lockValue is @lastLockValue
    @lastLockValue = lockValue
    sounds = @sounds[isRight]
    index = 0
    while sounds[index]? and sounds[index].isPlaying
      index++
    sounds[index]?.play()

  onInteract: (person) ->
    return if @safe.safeOpened
    return unless person.type is 'player'
    @initOpening()

  initOpening: ->
    window.crack_rotate = @crack_rotate
    window.crack_open = @crack_open

    ledsDiv = document.getElementById 'safe-leds'
    ledsDivContent = ''
    ledId = 0
    for number in @solution
      ledsDivContent += "<div id='safe-led-#{ledId}'></div>"
      ledId++
    ledsDiv.innerHTML = ledsDivContent
    document.getElementById('safe-led-0').classList.add 'incorrect'

    document.getElementById('safe-open-button').disabled = true
    document.getElementById('safe-container').style.visibility = 'visible'

    @currentCrackingLayer = 0
    @lastSignum = @signum

  failedToOpen: ->
    @initOpening()

  isVisible: ->
    super() and not @safe.safeOpened

  crack_rotate: (amount) =>
    # only +-1 and +-5 are inputs here

    @lockValue.set @lockValue.target + amount

    newSign = Math.sign amount
    @lastSignum = @signum
    @signum = newSign
    @lastSignum = @signum unless @lastSignum?
    @updateLockValue()

  crack_open: =>
    @hasFocus = true
    @crackingDone()
    gs.camera.focusObject @safe.getFocusData(), @safe
    @safe.onSafeOpenAnimation()

  crackingDone: ->
    @safe.safeOpened = true
    @onFocusLost()
    @currentCrackingLayer = undefined

  onFocusLost: ->
    document.getElementById('safe-container').style.visibility = 'hidden'
    @safe.mesh.userData.description.cost = Constants.baseCloseSafeDelay
    window.crack_rotate = undefined
    window.crack_open = undefined

module.exports = SafeLock
