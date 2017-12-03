class ResourceCache
  constructor: ->
    @models = {}
    @sounds = {}
    @textures = {}
    @jsonLoader = new THREE.JSONLoader()

  loadModel: (name) ->
    unless @models[name]?
      @jsonLoader.load "assets/models/#{name}.json", (geom, mat) =>
        mat[0].map.anisotropy = 4
        m.fog = false for m in mat
        @models[name] =
          geometry: geom
          materials: mat
    else
      console.warn "Model #{name} already loaded."

  getModel: (name) ->
    unless @models[name]?
      console.error "Cannot find model named #{name}. Have you added it to config/resources?"
    mesh = new THREE.Mesh @models[name].geometry, @models[name].materials
    mesh.castShadow = true
    mesh.receiveShadow = true
    mesh

window.AssetCache = new ResourceCache
