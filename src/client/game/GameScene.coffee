# The GameScene encapsulates the three-stuff behind a running game

require '../util/ThrottleResizeEvent'
Floor = require './building/Floor'
Player = require './actor/Player'

class GameScene
  constructor: (@updateCallback) ->
    @camera = new THREE.PerspectiveCamera 45, 1, 0.1, 100
    @camera.position.z = 5
    @camera.position.y = 3

    @scene = new THREE.Scene()

    # uncomment for nice fog
    # @scene.fog = new THREE.FogExp2 0x000000, 0.1

    ambiColor = '#ffffff'
    ambientLight = new THREE.AmbientLight ambiColor
    @scene.add ambientLight

    @renderer = new THREE.WebGLRenderer
      antialias: true
    @renderer.setClearColor 0x000000, 1

    @controls = new THREE.OrbitControls @camera, @renderer.domElement
    @controls.enableZoom = true

    @mouse = new THREE.Vector2
    window.addEventListener 'mousemove', @onMouseMove, false
    @rayCaster = new THREE.Raycaster
    @hoveredObjects = []

    @floor = new Floor {x: 5, y: 5}, @
    @player = new Player
    @add @player
    # uncomment to hide all shader compilation warnings
    # @ignoreShaderLogs()

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
    # @rayCaster.setFromCamera @mouse, @camera
    # @hoveredObjects = (res.object for res in (@rayCaster.intersectObjects @scene.children, true))

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

  add: (newObject) ->
    @scene.add if newObject.mesh then newObject.mesh else newObject

module.exports = GameScene
