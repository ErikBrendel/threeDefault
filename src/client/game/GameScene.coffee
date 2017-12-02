# The GameScene encapsulates the three-stuff behind a running game

require '../util/ThrottleResizeEvent'
Floor = require './building/Floor'
Player = require './actor/Player'
Guard = require './actor/Guard'
layouts = require './building/floors/Layouts'
PlayerCamera = require './actor/PlayerCamera'
PlayerLight = require './actor/PlayerLight'

class GameScene
  constructor: (@updateCallback) ->
    @scene = new THREE.Scene()

    @floor = new Floor layouts[0], @
    @add @floor

    @player = new Player
    @player.setRoom @floor.rooms[0][0]
    @add @player

    @guard = new Guard
    @add @guard
    @guard.setPosition new THREE.Vector3 4, 0, 4

    @camera = new PlayerCamera @player


    # uncomment for nice fog
    # @scene.fog = new THREE.FogExp2 0x000000, 0.1

    ambiColor = '#ffffff'
    ambientLight = new THREE.AmbientLight ambiColor, 0.2
    @scene.add ambientLight
    @playerLight = new PlayerLight @player

    @scene.add( @playerLight );

    plh = new THREE.PointLightHelper(@playerLight, 0.1)
    @scene.add(plh)


    @renderer = new THREE.WebGLRenderer
      antialias: true
    @renderer.setClearColor 0x000000, 1
    @renderer.shadowMap.enabled = true
    @renderer.shadowMap.type = THREE.PCFSoftShadowMap

    #@controls = new THREE.OrbitControls @camera, @renderer.domElement
    #@controls.enableZoom = true

    @mouse = new THREE.Vector2
    window.addEventListener 'mousemove', @onMouseMove, false
    window.addEventListener 'click', ((event) => @onClick event), false
    @rayCaster = new THREE.Raycaster
    @hoveredObjects = []

    # uncomment to hide all shader compilation warnings
    @ignoreShaderLogs()

    @resize()
    window.addEventListener 'optimizedResize', =>
      @resize()

    @lastUpdate = undefined

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
    return if not hovered?
    hovered.userData.hoverHandler?()

  add: (newObject) ->
    @scene.add if newObject.mesh then newObject.mesh else newObject

  onClick: (event) ->
    event.preventDefault()
    clicked = @hoveredObjects[0]
    return if not clicked?
    clicked.userData.clickHandler?()


  onRoomHover: (room) ->
    console.log(room.position)

  onGroundClicked: (room) ->
    if(@player.position.distanceTo(room.position) <= 4)
      @player.setRoom room

module.exports = GameScene
