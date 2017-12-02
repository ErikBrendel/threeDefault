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
        @models[name] =
          geometry: geom
          materials: mat
    else
      console.warn "Model #{name} already loaded."

  getModel: (name, castShadow = true, receiveShadow = true) ->
    unless @models[name]?
      console.error "Cannot find model named #{name}. Have you added it to config/resources?"
    mesh = new THREE.Mesh @models[name].geometry, @models[name].materials
    mesh.castShadow = castShadow
    mesh.receiveShadow = receiveShadow
    mesh

window.AssetCache = new ResourceCache
