class ResourceCache
  constructor: ->
    @models = {}
    @sounds = {}
    @musics = {}
    @textures = {}
    @jsonLoader = new THREE.JSONLoader
    @audioLoader = new THREE.AudioLoader
    @textureLoader = new THREE.TextureLoader

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

  loadMusic: (name) ->
    unless @musics[name]?
      url = "assets/music/#{name}.mp3"
      @audioLoader.manager.itemStart "Decode: #{url}"
      @audioLoader.load url, (buffer) =>
        console.debug "Loaded music #{name}."
        @musics[name] = buffer
        @audioLoader.manager.itemEnd "Decode: #{url}"
    else
      console.warn "Music #{name} already loaded."

  loadSound: (name) ->
    unless @sounds[name]?
      url = "assets/sounds/#{name}.mp3"
      @audioLoader.manager.itemStart "Decode: #{url}"
      @audioLoader.load url, (buffer) =>
        console.debug "Loaded sound #{name}."
        @sounds[name] = buffer
        @audioLoader.manager.itemEnd "Decode: #{url}"
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
    @applyMeshOptions mesh unless name is 'objects/laser'
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

  getMusic: (name, listener = window.audioListener) ->
    buffer = @musics[name]
    unless buffer?
      console.error "Cannot find music named #{name}. Have you added it to config/resources?"
      return
    audio = new THREE.Audio listener
    audio.setBuffer buffer
    @applyMusicOptions audio
    audio

  applyTextureOptions: (texture) ->
    return unless texture?
    texture.anisotropy = 4

  applyGeometryOptions: (geometry) ->
    #Nothing yet

  applyMaterialOptions: (material) ->
    @applyTextureOptions material.map
    material.fog = false

  applyMeshOptions: (mesh) ->
    mesh.castShadow = true
    mesh.receiveShadow = true

  applyAudioOptions: (audio) ->
    audio.setVolume 1

  applyMusicOptions: (music) ->
    @applyAudioOptions(music)
    music.setLoop true
    music.setVolume 0.5

  applyPositionalAudioOptions: (sound) ->
    @applyAudioOptions sound
    sound.setRefDistance 1.0

window.AssetCache = new ResourceCache
