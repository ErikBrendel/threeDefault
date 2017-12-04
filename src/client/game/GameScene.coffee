# The GameScene encapsulates the three-stuff behind a running game

require '../util/ThrottleResizeEvent'
Floor = require './building/Floor'
Player = require './actor/Player'
Guard = require './actor/Guard'
layouts = require './building/floors/Layouts'
PlayerCamera = require './actor/PlayerCamera'
PlayerLight = require './actor/PersonLight'
AlarmLight = require './actor/AlarmLight'
Scheduler = require './Scheduler'

class GameScene
  constructor: (@updateCallback) ->
    window.gs = @
    @scene = new THREE.Scene()

    @floor = new Floor layouts[0], @
    @add @floor

    @audioListener = new THREE.AudioListener
    window.audioListener = @audioListener

    @guard = new Guard @floor
    @add @guard
    @guard.setRoom @floor.rooms[1][1]

    @player = new Player @audioListener
    @player.setRoom @floor.rooms[0][0]
    @add @player

    @add AlarmLight.instance()
    @add AlarmLight.instance().target


    @scheduler = new Scheduler @player, @guard
    @camera = new PlayerCamera @player

    # uncomment for nice fog
    # @scene.fog = new THREE.FogExp2 0x000000, 0.225

    ambiColor = '#ffffff'
    ambientLight = new THREE.AmbientLight ambiColor, 0.4 #TODO: Discuss about this in the end, not now!
    @scene.add ambientLight

    @renderer = new THREE.WebGLRenderer
      antialias: true
    @renderer.setClearColor 0x000000, 1
    @renderer.shadowMap.enabled = true
    @renderer.shadowMap.type = THREE.PCFSoftShadowMap

    @mouse = new THREE.Vector2
    window.addEventListener 'mousemove', @onMouseMove, false
    window.addEventListener 'click', ((event) => @onClick event), false
    @rayCaster = new THREE.Raycaster
    @hoveredObjects = []
    @lastHoveredObject

    # uncomment to hide all shader compilation warnings
    @ignoreShaderLogs()

    @resize()
    window.addEventListener 'optimizedResize', =>
      @resize()

    @lastUpdate = undefined

    # called on "user want to exit the current view",
    # returning true when event was handled
    @exitHandler = undefined

  ignoreShaderLogs: ->
    @renderer.context.getShaderInfoLog = () -> ''

  addAxisHelper: (size) ->
    @scene.add new THREE.AxisHelper size

  resize: ->
    @resizeTo window.innerWidth, window.innerHeight
  resizeTo: (width, height) ->
    @camera.aspect = width / height
    @camera.updateProjectionMatrix()
    @renderer.setSize width, height

  appendChildFullscreen: ->
    @appendTo document.body
  appendTo: (elem) ->
    elem.appendChild @renderer.domElement

  animation: ->
    if not @lastUpdate?
      @lastUpdate = Date.now()
      window.requestAnimationFrame => @animation()
      return

    # uncomment to use raycasting for mouse-object interaction
    @rayCaster.setFromCamera @mouse, @camera
    @hoveredObjects = (res.object for res in (@rayCaster.intersectObjects @scene.children, true))
    worldPos = @rayCaster.ray.intersectPlane new THREE.Plane(new THREE.Vector3(0, 1, 0), 0)
    if @camera.focusMode
      worldPos = @rayCaster.ray.intersectPlane new THREE.Plane(new THREE.Vector3(0, 0, 1), 2 - @player.currentRoom.position.z)
    if worldPos?
      @player.lookTo worldPos

    # update loop
    now = Date.now()
    deltaTime = now - @lastUpdate

    @updateCallback? deltaTime
    child.userData.updateCallback? deltaTime for child in @scene.children

    @lastUpdate = now

    # rendering
    @renderer.render @scene, @camera

    # keep this loop going
    window.requestAnimationFrame => @animation()

  onMouseMove: (event) =>
    # calculate mouse position in normalized device coordinates
    # (-1 to +1) for both components
    @mouse.x = event.clientX / window.innerWidth * 2 - 1
    @mouse.y = -(event.clientY / window.innerHeight) * 2 + 1
    hovered = @hoveredObjects[0]
    @describe hovered

    while hovered? and not (hovered.userData.mouseEnterHandler? or hovered.userData.mouseLeaveHandler?)
      hovered = hovered.parent

    if hovered isnt @lastHoveredObject
      @lastHoveredObject?.userData.mouseLeaveHandler?()
      hovered?.userData.mouseEnterHandler?()
      @lastHoveredObject = hovered

  describe: (aMesh) ->
    toDescribe = aMesh
    while toDescribe? and not toDescribe.userData.description?
      toDescribe = toDescribe.parent
    showDescription toDescribe?.userData.description

  add: (newObject) ->
    @scene.add if newObject.mesh then newObject.mesh else newObject

  onClick: (event) ->
    return unless event.target is @renderer.domElement

    event.preventDefault()
    clicked = @hoveredObjects[0]

    while clicked? and not clicked.userData.clickHandler?
      clicked = clicked.parent

    clicked?.userData.clickHandler?()

  onRoomClicked: (room) ->
    @player.onRoomClicked room
    @camera.resetFocus()
    @exitHandler = undefined

module.exports = GameScene
