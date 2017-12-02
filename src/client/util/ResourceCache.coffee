class ResourceCache
  constructor: ->
    @models = {}
    @sounds = {}
    @textures = {}
    @jsonLoader = new THREE.JSONLoader()

  loadModel: (name) ->
    unless @models[name]?
      @jsonLoader.load "assets/models/#{name}.json", (geom, mat) =>
        @models[name] =
          geometry: geom
          materials: mat
    else
      console.warn "Model #{name} already loaded."

  getModel: (name) ->
    mesh = new THREE.Mesh @models[name].geometry, @models[name].materials
    mesh.castShadow = true
    mesh.receiveShadow = true
    mesh

window.AssetCache = new ResourceCache
