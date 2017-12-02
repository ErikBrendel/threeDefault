class ResourceCache
  contructor: ->
    @models = {}
    @sounds = {}
    @textures = {}
    @jsonLoader = new THREE.JSONLoader()
    #TODO: Set THREE.DefaultLoadingManager listeners for progress reports

  loadModel: (name) ->
    unless @models[name]?
      @jsonLoader.load "assets/models/#{name}.json", (geom, mat) =>
        @models[name] =
          geometry: geom
          materials: mat
    else
      console.warn "Model #{name} already loaded."

  getModel: (name) ->
    new THREE.Mesh @models[name].geometry @models[name].materials

window.AssetCache = new RessourceCache
