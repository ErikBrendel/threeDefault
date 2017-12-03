class ResourceCache
  constructor: ->
    @models = {}
    @sounds = {}
    @textures = {}
    @jsonLoader = new THREE.JSONLoader
    @audioLoader = new THREE.AudioLoader

  loadModel: (name) ->
    unless @models[name]?
      @jsonLoader.load "assets/models/#{name}.json", (geom, mats) =>
        console.debug "Loaded model #{name}."
        @applyGeometryOptions geom
        @applyMaterialOptions m for m in mats
        @models[name] =
          geometry: geom
          materials: mats
    else
      console.warn "Model #{name} already loaded."

  loadSound: (name) ->
    unless @sounds[name]?
      console.debug "Loading sound #{name}."
      @audioLoader.load "assets/sounds/#{name}.mp3", (buffer) =>
        console.debug "Loaded sound #{name}."
        @sounds[name] = buffer
    else
      console.warn "Sound #{name} already loaded."

  getModel: (name, {copyGeometry = false, copyMaterials = false} = {}) ->
    unless @models[name]?
      console.error "Cannot find model named #{name}. Have you added it to config/resources?"
      return
    geometry = @models[name].geometry
    geometry = geometry.clone() if copyGeometry
    materials = @models[name].materials
    materials = (m.clone() for m in materials) if copyMaterials
    mesh = new THREE.Mesh geometry, materials
    @applyMeshOptions mesh
    mesh

  getSound: (name, listener = window.audioListener) ->
    buffer = @sounds[name]
    unless buffer?
      console.error "Cannot find sound named #{name}. Have you added it to config/resources?"
      return
    audio = new THREE.PositionalAudio listener
    audio.setBuffer buffer
    @applyPositionalAudioOptions audio
    audio

  applyGeometryOptions: (geometry) ->
    #Nothing yet

  applyMaterialOptions: (material) ->
    material.map.anisotropy = 4
    material.fog = false

  applyMeshOptions: (mesh) ->
    mesh.castShadow = true
    mesh.receiveShadow = true

  applyAudioOptions: (sound) ->
    sound.setVolume 1

  applyPositionalAudioOptions: (sound) ->
    @applyAudioOptions sound
    sound.setRefDistance 20

window.AssetCache = new ResourceCache
