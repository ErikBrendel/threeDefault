class ResourceCache
  constructor: ->
    @models = {}
    @sounds = {}
    @textures = {}
    @jsonLoader = new THREE.JSONLoader()

  loadModel: (name) ->
    unless @models[name]?
      @jsonLoader.load "assets/models/#{name}.json", (geom, mats) =>
        @applyGeometryOptions geom
        @applyMaterialOptions m for m in mats
        @models[name] =
          geometry: geom
          materials: mats
    else
      console.warn "Model #{name} already loaded."

  getModel: (name, {copyGeometry = false, copyMaterials = false} = {}) ->
    unless @models[name]?
      console.error "Cannot find model named #{name}. Have you added it to config/resources?"
    geometry = @models[name].geometry
    geometry = geometry.clone() if copyGeometry
    materials = @models[name].materials
    materials = (m.clone() for m in materials) if copyMaterials
    mesh = new THREE.Mesh geometry, materials
    @applyMeshOptions mesh
    mesh

  applyGeometryOptions: (geometry) ->
    #Nothing yet

  applyMaterialOptions: (material) ->
    material.map.anisotropy = 4
    material.fog = false

  applyMeshOptions: (mesh) ->
    mesh.castShadow = true
    mesh.receiveShadow = true

window.AssetCache = new ResourceCache
